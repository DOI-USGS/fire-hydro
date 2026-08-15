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

#' Fetch fire perimeters for a single year
#' Tries the Full History service first (has older certified data).
#' Falls back to the current Interagency Perimeters service for recent years.
#' Uses a WHERE clause to query only the requested year — keeps downloads small.
fetch_fire_perimeters_by_year <- function(year, out_dir) {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_gpkg <- file.path(out_dir, paste0("fire_", year, ".gpkg"))

  # Full history service (1984 through ~2 years ago)
  history_url <- paste0(
    "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/",
    "WFIGS_-_Wildland_Fire_Perimeters_Full_History/FeatureServer/0"
  )

  # Current interagency perimeters (2021+ including current season)
  current_url <- paste0(
    "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/",
    "WFIGS_Interagency_Perimeters/FeatureServer/0"
  )

  where_clause <- paste0("FireDiscoveryDateTime >= DATE '", year, "-01-01' ",
                         "AND FireDiscoveryDateTime < DATE '", year + 1, "-01-01'")

  # Try full history first

  fires <- tryCatch({
    layer <- arcgislayers::arc_open(history_url)
    result <- arcgislayers::arc_select(layer, where = where_clause)
    if (nrow(result) == 0) stop("No records in history")
    result
  }, error = function(e) {
    # Fall back to current service for recent years
    layer <- arcgislayers::arc_open(current_url)
    arcgislayers::arc_select(layer, where = where_clause)
  })

  if (nrow(fires) > 0) {
    sf::st_write(fires, out_gpkg, delete_dsn = TRUE, quiet = TRUE)
  } else {
    # Write empty gpkg so targets doesn't error
    sf::st_write(sf::st_sf(geometry = sf::st_sfc(crs = 4326)), out_gpkg,
                 delete_dsn = TRUE, quiet = TRUE)
    message("No fire perimeters found for year ", year)
  }

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
