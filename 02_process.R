# Fire types to include. "Wildland Fire Use" is a managed natural ignition, so
# it counts as wildfire for this story. Prescribed Fire and Other are excluded.
fire_types_keep <- c("Wildfire", "Wildland Fire Use")

# Last year MTBS has finished mapping.
#
# MTBS lags real time and releases quarterly. Their data availability page
# lists 2023 onward as in progress, but the data disagrees for 2023: MTBS holds
# more western fires than WFIGS for that year and 98% of its acreage, so 2023
# was a light season rather than an unmapped one. 2024 is still short of WFIGS
# and 2025 is barely started, so both come from WFIGS below.
#
# Bump this after checking mtbs_pct_of_wfigs in 02_process/out/fire_coverage.csv
# against https://mtbs.gov/data-availability — when a year approaches 100, MTBS
# has caught up and that year should move back to MTBS.
mtbs_complete_through <- 2023

# Years published from WFIGS because MTBS has not finished them.
#
# A closed range rather than "everything after the MTBS cutoff": the current
# calendar year is a partial season and would draw a misleadingly short bar.
# Extend as seasons end, and drop years off the front as MTBS catches up.
wfigs_display_years <- 2024:2025

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
  # coverage can be audited against WFIGS below.
  tar_target(
    p2_fires_all,
    process_mtbs_fires(
      gpkg = p1_mtbs_gpkg,
      clip_boundary = p2_clip_boundary,
      keep_types = fire_types_keep
    )
  ),

  # Every WFIGS wildfire in the western states, 2020 onward. Kept untrimmed so
  # the coverage comparison can use the full overlap with MTBS.
  tar_target(
    p2_wfigs_fires_all,
    process_wfigs_fires(
      gpkg = p1_wfigs_gpkg,
      clip_boundary = p2_clip_boundary
    )
  ),

  # SEAM FOR MIXED SOURCES
  # Everything downstream reads from this target: MTBS through the years it has
  # finished, WFIGS for the trailing years it has not. The `source` column
  # carries the origin of each perimeter through to the front end.
  #
  # The two sources measure different things — MTBS maps satellite burned-area
  # extent, WFIGS records operational fire-line perimeters — so this is a
  # methodological break, not just a change of provider. They agree to within a
  # few percent on annual totals where they overlap, which is what makes
  # splicing them defensible.
  tar_target(
    p2_fires_display,
    dplyr::bind_rows(
      p2_fires_all |> dplyr::filter(YEAR <= mtbs_complete_through),
      p2_wfigs_fires_all |> dplyr::filter(YEAR %in% wfigs_display_years)
    )
  ),

  # MTBS vs WFIGS per year, plus which source each year shipped from. Review
  # this each year to decide whether mtbs_complete_through can move.
  tar_target(
    p2_fire_coverage_csv,
    write_fire_coverage(
      mtbs_sf = p2_fires_all,
      wfigs_sf = p2_wfigs_fires_all,
      display_sf = p2_fires_display,
      out_csv = "02_process/out/fire_coverage.csv"
    ),
    format = "file"
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
