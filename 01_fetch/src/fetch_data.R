#' Download western US state boundaries using tigris
#' Returns a gpkg in EPSG:5070 (Albers Equal Area CONUS)
fetch_states_boundary <- function(out_dir, states) {
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  out_gpkg <- file.path(out_dir, "states.gpkg")

  tigris::states(cb = TRUE, resolution = "20m", progress_bar = FALSE) |>
    dplyr::filter(STUSPS %in% states) |>
    sf::st_transform(5070) |>
    sf::st_write(out_gpkg, delete_dsn = TRUE, quiet = TRUE)

  out_gpkg
}

#' Fetch MTBS Burned Area Boundaries (national, 1984-present)
#'
#' Verified structure (2026-08):
#'   - 30,930 features, CRS EPSG:4269
#'   - ig_date    : String "YYYY-MM-DD" (range 1984-01-26 to 2026-06-05)
#'   - burnbndac  : Real, acres
#'   - incid_name : String
#'   - incid_type : String, one of Wildfire / Prescribed Fire /
#'                  Wildland Fire Use / Other
#'
#' Source: https://mtbs.gov (Burned Area Boundaries composite)
fetch_mtbs_perimeters <- function(out_gpkg) {
  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)

  url <- paste0(
    "https://edcintl.cr.usgs.gov/downloads/sciweb1/shared/MTBS_Fire/data/",
    "composite_data/burned_area_extent_shapefile/mtbs_perimeter_data.zip"
  )

  zip_path <- file.path(dirname(out_gpkg), "mtbs_perimeters.zip")
  extract_dir <- file.path(dirname(out_gpkg), "mtbs_perimeters")

  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout), add = TRUE)
  options(timeout = 900)

  message("Downloading MTBS burned area boundaries...")
  download.file(url, zip_path, mode = "wb", quiet = TRUE)
  unzip(zip_path, exdir = extract_dir)

  shp <- list.files(extract_dir, pattern = "\\.shp$",
                    full.names = TRUE, recursive = TRUE)[1]
  if (is.na(shp)) stop("No shapefile found in MTBS archive")

  sf::st_read(shp, quiet = TRUE) |>
    sf::st_write(out_gpkg, delete_dsn = TRUE, quiet = TRUE)

  unlink(zip_path)
  unlink(extract_dir, recursive = TRUE)

  out_gpkg
}

#' Fetch WFIGS interagency fire perimeters (national, 2020-present)
#'
#' Supplements MTBS for seasons MTBS has not finished mapping. WFIGS is the
#' operational interagency feed, current within days of a fire, so it covers
#' the trailing years MTBS is still working through.
#'
#' Structure (verified 2026-08):
#'   - ~2,500 national wildfire records >= 1,000 acres since 2020
#'   - Coverage begins 2020; 2016-2019 return zero records
#'   - poly_FeatureCategory mixes "Wildfire Final Fire Perimeter" and
#'     "Wildfire Daily Fire Perimeter", so one incident can appear several
#'     times. Not filtered here — see process_wfigs_fires().
#'   - attr_IrwinID is frequently NA, so it cannot carry the dedupe
#'
#' `min_acres` matches MTBS's effective mapping floor. Without it WFIGS would
#' contribute thousands of small fires MTBS never records, and fire counts
#' would jump at the source seam.
#'
#' Source: https://data-nifc.opendata.arcgis.com/datasets/nifc::wfigs-interagency-fire-perimeters
fetch_wfigs_perimeters <- function(out_gpkg, start_year, min_acres = 1000) {
  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)

  url <- paste0(
    "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/",
    "WFIGS_Interagency_Perimeters/FeatureServer/0"
  )

  # Only the fields the pipeline reads; the service carries ~100 attributes.
  fields <- c(
    "poly_IncidentName", "poly_GISAcres", "poly_FeatureCategory",
    "attr_IncidentTypeCategory", "attr_FireDiscoveryDateTime", "attr_IrwinID"
  )

  # WF excludes prescribed burns, matching the incid_type filter on MTBS.
  where <- sprintf(
    paste0(
      "attr_IncidentTypeCategory = 'WF' AND poly_GISAcres >= %s ",
      "AND attr_FireDiscoveryDateTime >= timestamp '%d-01-01 00:00:00'"
    ),
    format(min_acres, scientific = FALSE), start_year
  )

  message("Downloading WFIGS interagency perimeters...")
  perimeters <- arcgislayers::arc_open(url) |>
    arcgislayers::arc_select(fields = fields, where = where, crs = 4269)

  if (nrow(perimeters) == 0) {
    stop("WFIGS query returned no features — check the service and filters")
  }

  sf::st_write(perimeters, out_gpkg, delete_dsn = TRUE, quiet = TRUE)

  out_gpkg
}

#' Fetch USFS Forests to Faucets 2.0 HUC12 watersheds
#'
#' Verified structure (2026-08):
#'   - Outer zip contains Forests2Faucets/F2F2_June2021.zip
#'   - Inner zip contains F2F2_2019.gdb (OpenFileGDB driver)
#'   - Layer F2F2_HUC12 with fields HUC12, NAME, STATES, Acres,
#'     FOREST, PER_FOR, IMP, IMP_R, WFP, WFP_IMP_R
#'
#' Source: https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn
fetch_forest_to_faucets <- function(out_gpkg) {
  dir.create(dirname(out_gpkg), recursive = TRUE, showWarnings = FALSE)

  url <- "https://new.cloudvault.usda.gov/index.php/s/GKDoTosMaC2BeNn/download"
  work_dir <- file.path(dirname(out_gpkg), "f2f2")
  zip_path <- file.path(dirname(out_gpkg), "f2f2.zip")

  old_timeout <- getOption("timeout")
  on.exit(options(timeout = old_timeout), add = TRUE)
  options(timeout = 900)

  if (!file.exists(zip_path)) {
    message("Downloading Forests to Faucets 2.0 (~900 MB)...")
    download.file(url, zip_path, mode = "wb", quiet = TRUE)
  }

  unzip(zip_path, exdir = work_dir, overwrite = TRUE)

  # Outer archive nests a second zip holding the geodatabase
  inner_zip <- list.files(work_dir, pattern = "F2F2_.*\\.zip$",
                          full.names = TRUE, recursive = TRUE)[1]
  if (is.na(inner_zip)) stop("Inner F2F2 archive not found")

  gdb_dir <- file.path(work_dir, "gdb")
  unzip(inner_zip, exdir = gdb_dir, overwrite = TRUE)

  gdb <- list.files(gdb_dir, pattern = "\\.gdb$",
                    full.names = TRUE, include.dirs = TRUE)[1]
  if (is.na(gdb)) stop("F2F2 geodatabase not found")

  sf::st_read(gdb, layer = "F2F2_HUC12", quiet = TRUE) |>
    sf::st_write(out_gpkg, delete_dsn = TRUE, quiet = TRUE)

  unlink(work_dir, recursive = TRUE)

  out_gpkg
}
