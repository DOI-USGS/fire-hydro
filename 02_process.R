# Fire types to include. "Wildland Fire Use" is a managed natural ignition, so
# it counts as wildfire for this story. Prescribed Fire and Other are excluded.
fire_types_keep <- c("Wildfire", "Wildland Fire Use")

# Last year MTBS considers fully mapped.
#
# MTBS lags real time — as of 2026-08 their data availability page states the
# 2023 and 2024 seasons are still being mapped, targeted for completion by end
# of FY2026. Observed record counts agree: ~530 fires in 2022 vs 339 in 2023,
# 51 in 2025, 20 in 2026.
#
# Bump this after checking 02_process/out/fire_coverage.csv against
# https://mtbs.gov/data-availability
mtbs_complete_through <- 2022

p2_targets_list <- list(

  # Western states, already EPSG:5070 from the fetch step
  tar_target(
    p2_states_sf,
    read_sf_norm(p1_states_gpkg) |>
      dplyr::group_by(NAME, STATEFP, STUSPS) |>
      dplyr::summarize(.groups = "drop") |>
      sf::st_make_valid()
  ),

  # Dissolved boundary used to clip fire perimeters
  tar_target(
    p2_clip_boundary,
    sf::st_union(p2_states_sf)
  ),

  # Every MTBS wildfire in the western states, all years. Kept unfiltered so
  # coverage can be audited and so a future WFIGS supplement has a full
  # baseline to join against.
  tar_target(
    p2_fires_all,
    process_mtbs_fires(
      gpkg = p1_mtbs_gpkg,
      clip_boundary = p2_clip_boundary,
      keep_types = fire_types_keep
    )
  ),

  # Record counts per year with a completeness flag. This is the artifact to
  # check each year to decide whether mtbs_complete_through can move.
  tar_target(
    p2_fire_coverage_csv,
    write_fire_coverage(
      fires_sf = p2_fires_all,
      complete_through = mtbs_complete_through,
      out_csv = "02_process/out/fire_coverage.csv"
    ),
    format = "file"
  ),

  # SEAM FOR MIXED SOURCES
  # Everything downstream reads from this target. Today it is MTBS trimmed to
  # complete years. To add WFIGS for the trailing incomplete years, bind it in
  # here — the `source` column already exists to keep the origin of each
  # perimeter distinguishable in the front end.
  tar_target(
    p2_fires_display,
    p2_fires_all |> dplyr::filter(YEAR <= mtbs_complete_through)
  ),

  # Years actually present after trimming — drives the branching below
  tar_target(
    p2_fire_years,
    sort(unique(p2_fires_display$YEAR))
  ),

  # Dissolve + simplify one year at a time so each year caches independently.
  # iteration = "list" keeps sf objects intact through the branching.
  tar_target(
    p2_fires_year_branch,
    dissolve_fire_year(p2_fires_display, year = p2_fire_years),
    pattern = map(p2_fire_years),
    iteration = "list"
  ),

  # Stack the per-year branches back into one sf object
  tar_target(
    p2_fires_by_year,
    dplyr::bind_rows(p2_fires_year_branch) |> dplyr::arrange(YEAR)
  ),

  # Annual area burned, written for the D3 bar chart. Area comes from the
  # dissolved geometry so it matches the map; counts come from the fire records.
  tar_target(
    p2_fire_timeseries_csv,
    write_fire_timeseries(
      fires_by_year = p2_fires_by_year,
      fires_sf = p2_fires_display,
      out_csv = "02_process/out/fire_timeseries.csv"
    ),
    format = "file"
  ),

  # Area burned as published on the 2020 site, built from NIFC/GeoMAC
  # perimeters. Kept as a regression reference for the MTBS series.
  tar_target(
    p2_reference_timeseries_csv,
    "02_process/in/fire_timeseries_reference_2020.csv",
    format = "file"
  ),

  # QAQC: MTBS series vs the 2020 reference. Expect ratios near 1 with MTBS
  # slightly lower; investigate anything far off or systematically skewed.
  tar_target(
    p2_source_comparison_csv,
    write_source_comparison(
      timeseries_csv = p2_fire_timeseries_csv,
      reference_csv = p2_reference_timeseries_csv,
      out_csv = "02_process/out/source_comparison.csv"
    ),
    format = "file"
  ),

  # Important water supply watersheds (IMP_R >= 50) in the western states
  tar_target(
    p2_important_watersheds,
    process_important_watersheds(
      gpkg = p1_f2f_gpkg,
      clip_boundary = p2_clip_boundary,
      importance_threshold = 50
    )
  )
)
