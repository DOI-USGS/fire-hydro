# Western US states included in the analysis
western_states <- c("CA", "WA", "NV", "UT", "CO", "AZ", "NM", "MT", "WY", "OR", "ID")

# First year WFIGS carries usable coverage. Fetched from here rather than from
# the first published year so the overlap with MTBS is available to the
# coverage comparison in 02_process.
wfigs_start_year <- 2020

p1_targets_list <- list(

  # US states boundary (Census cartographic via tigris)
  tar_target(
    p1_states_gpkg,
    fetch_states_boundary(
      out_dir = "01_fetch/out",
      states = western_states
    ),
    format = "file"
  ),

  # MTBS Burned Area Boundaries — covers 1984 through present (verified 2026-06)
  # Single national shapefile; fields: ig_date, burnbndac, incid_name, incid_type
  tar_target(
    p1_mtbs_gpkg,
    fetch_mtbs_perimeters(
      out_gpkg = "01_fetch/out/mtbs_fire_perimeters.gpkg"
    ),
    format = "file"
  ),

  # WFIGS Interagency Perimeters — operational perimeters, 2020 to present.
  # Supplies the trailing years MTBS has not finished mapping.
  tar_target(
    p1_wfigs_gpkg,
    fetch_wfigs_perimeters(
      out_gpkg = "01_fetch/out/wfigs_fire_perimeters.gpkg",
      start_year = wfigs_start_year
    ),
    format = "file"
  ),

  # USFS Forests to Faucets 2.0 — HUC12 watersheds with importance rankings
  # Nested zip from USDA CloudVault; layer F2F2_HUC12, field IMP_R
  tar_target(
    p1_f2f_gpkg,
    fetch_forest_to_faucets(
      out_gpkg = "01_fetch/out/forest_to_faucets.gpkg"
    ),
    format = "file"
  )
)
