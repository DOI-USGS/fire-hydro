# Western US states included in the analysis
western_states <- c("CA", "WA", "NV", "UT", "CO", "AZ", "NM", "MT", "WY", "OR", "ID")

# Year range for the fire record
fire_years <- 1984:as.integer(format(Sys.Date(), "%Y"))

p1_targets_list <- list(

  # US states boundary (Census cartographic via tigris)
  tar_target(
    p1_states_shp,
    fetch_states_boundary(
      out_dir = "01_fetch/out",
      states = western_states
    ),
    format = "file"
  ),

  # Vector of years to iterate over

  tar_target(p1_fire_years, fire_years),

  # Fetch fire perimeters per year (dynamic branching)
  # Uses full history service for older years, current service for recent
  tar_target(
    p1_fire_perimeters_gpkg,
    fetch_fire_perimeters_by_year(
      year = p1_fire_years,
      out_dir = "01_fetch/out/fire_years"
    ),
    pattern = map(p1_fire_years),
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
