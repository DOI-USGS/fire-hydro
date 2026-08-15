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

#' Fetch MTBS Burned Area Boundaries (national, 1984-present)
#' Contains perimeters for all fires >= 1000 acres (West) and >= 500 acres (East)
#' Source: https://mtbs.gov/direct-download → Burned Area Boundaries
#' The direct download redirects to the Burn Severity Portal
fetch_mtbs_perimeters <- function(out_gpkg) {

  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)

  # MTBS burned area boundaries direct download URL
  url <- "https://edcintl.cr.usgs.gov/downloads/sciweb1/shared/MTBS_Fire/data/composite_data/burned_area_extent_shapefile/mtbs_perimeter_data.zip"

  zip_path <- file.path(dirname(out_gpkg), "mtbs_perimeters.zip")
  extract_dir <- file.path(dirname(out_gpkg), "mtbs_perimeters")

  download.file(url, zip_path, mode = "wb", quiet = TRUE)
  unzip(zip_path, exdir = extract_dir)

  # Find the shapefile
  shp_file <- list.files(extract_dir, pattern = "\\.shp$",
                         full.names = TRUE, recursive = TRUE)[1]

  fires <- sf::st_read(shp_file, quiet = TRUE)
  sf::st_write(fires, out_gpkg, delete_dsn = TRUE, quiet = TRUE)

  # Clean up zip

  unlink(zip_path)
  unlink(extract_dir, recursive = TRUE)

  out_gpkg
}

#' Fetch fire perimeters for a single year from WFIGS Interagency Perimeters
#' This service has data from ~2016 onward.
#' Source: https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Interagency_Perimeters/FeatureServer/0
fetch_fire_perimeters_by_year <- function(year, out_dir) {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_gpkg <- file.path(out_dir, paste0("fire_", year, ".gpkg"))

  url <- paste0(
    "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/",
    "WFIGS_Interagency_Perimeters/FeatureServer/0"
  )

  where_clause <- paste0(
    "attr_FireDiscoveryDateTime >= '", year, "-01-01' ",
    "AND attr_FireDiscoveryDateTime < '", year + 1, "-01-01'"
  )

  fires <- tryCatch({
    layer <- arcgislayers::arc_open(url)
    arcgislayers::arc_select(layer, where = where_clause)
  }, error = function(e) {
    message("Failed to fetch year ", year, ": ", conditionMessage(e))
    sf::st_sf(geometry = sf::st_sfc(crs = 4326))
  })

  if (nrow(fires) > 0) {
    sf::st_write(fires, out_gpkg, delete_dsn = TRUE, quiet = TRUE)
  } else {
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
