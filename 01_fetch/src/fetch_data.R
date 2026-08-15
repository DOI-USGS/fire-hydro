#' Download western US state boundaries using tigris (same approach as gulf-hypoxia)
fetch_states_boundary <- function(out_dir, states) {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_file <- file.path(out_dir, "states.gpkg")

  states_sf <- tigris::states(cb = TRUE, resolution = "20m", progress_bar = FALSE) |>
    dplyr::filter(STUSPS %in% states) |>
    sf::st_transform(crs = 5070)

  sf::st_write(states_sf, out_file, delete_dsn = TRUE, quiet = TRUE)
  out_file
}

#' Fetch fire perimeters from NIFC WFIGS Interagency Perimeters (ArcGIS Feature Server)
#' Source: https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Interagency_Perimeters/FeatureServer/0
fetch_fire_perimeters <- function(out_gpkg) {
  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)

  url <- paste0(
    "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/",
    "WFIGS_Interagency_Perimeters/FeatureServer/0"
  )

  fires <- arcgislayers::arc_open(url) |>
    arcgislayers::arc_select()

  sf::st_write(fires, out_gpkg, delete_dsn = TRUE, quiet = TRUE)
  out_gpkg
}

#' Fetch Forest to Faucets v2 important watersheds
#' Source: https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn
fetch_forest_to_faucets <- function(out_gpkg) {
  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)
  # TODO: download F2F2 data from USDA CloudVault
  message("fetch_forest_to_faucets: stub - implement F2F download")
  out_gpkg
}
