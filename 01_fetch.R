# Western US states included in the analysis
western_states <- c("CA", "WA", "NV", "UT", "CO", "AZ", "NM", "MT", "WY", "OR", "ID")

# Year range for the fire record
# 2016+ are fetched from the WFIGS API (current interagency perimeters)
# 1984-2015 use a static archive in 01_fetch/in/ (the old NIFC service was retired)
fire_years_api <- 2016:as.integer(format(Sys.Date(), "%Y"))

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

  # Historical fire perimeters from MTBS (1984-2022)
  # MTBS maps all fires >=1000 acres in the West from 1984 to present
  # Source: https://mtbs.gov/direct-download (Burned Area Boundaries)
  tar_target(
    p1_fire_history_gpkg,
    fetch_mtbs_perimeters(
      out_gpkg = "01_fetch/out/mtbs_fire_perimeters.gpkg"
    ),
    format = "file"
  ),

  # Vector of API years to iterate over
  tar_target(p1_fire_years, fire_years_api),

  # Fetch recent fire perimeters per year from WFIGS API (dynamic branching)
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
