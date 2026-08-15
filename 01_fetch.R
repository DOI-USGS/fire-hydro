# Western US states included in the analysis
western_states <- c("CA", "WA", "NV", "UT", "CO", "AZ", "NM", "MT", "WY", "OR", "ID")

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
