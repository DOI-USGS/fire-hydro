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

#' Fetch Forest to Faucets 2.0 important watersheds from USFS ArcGIS MapServer
#' Source: https://apps.fs.usda.gov/arcx/rest/services/EDW/EDW_ForeststoFaucets_02/MapServer/2
#' HUC12 level data with importance rankings for surface drinking water supply
fetch_forest_to_faucets <- function(out_gpkg) {
  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)

  url <- paste0(
    "https://apps.fs.usda.gov/arcx/rest/services/",
    "EDW/EDW_ForeststoFaucets_02/MapServer/2"
  )

  f2f <- arcgislayers::arc_open(url) |>
    arcgislayers::arc_select(
      fields = c("HUC12", "NAME", "STATES", "IMP", "IMP_R",
                 "FOREST", "PER_FOR", "Acres")
    )

  sf::st_write(f2f, out_gpkg, delete_dsn = TRUE, quiet = TRUE)
  out_gpkg
}
