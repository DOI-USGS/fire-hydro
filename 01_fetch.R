# Western US states included in the analysis
western_states <- c("CA", "WA", "NV", "UT", "CO", "AZ", "NM", "MT", "WY", "OR", "ID")

p1_targets_list <- list(

  # US states boundary (Census 2018 cartographic)
  tar_target(
    p1_states_shp,
    fetch_states_boundary(
      out_dir = "01_fetch/out",
      states = western_states
    ),
    format = "file"
  ),

  # NIFC Interagency Fire Perimeter History (all years)
  tar_target(
    p1_fire_perimeters_gpkg,
    fetch_fire_perimeters(
      out_gpkg = "01_fetch/out/fire_perimeters.gpkg"
    ),
    format = "file"
  ),

  # Forest to Faucets v2 important watersheds
  tar_target(
    p1_f2f_gpkg,
    fetch_forest_to_faucets(
      out_gpkg = "01_fetch/out/forest_to_faucets.gpkg"
    ),
    format = "file"
  )
)
