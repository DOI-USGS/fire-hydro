#' Compute shared bounding box for all map layers
compute_plot_bbox <- function(states_sf) {
  sf::st_bbox(states_sf)
}

#' Copy a pipeline output into public/ for the Vue app to fetch at runtime
copy_to_public <- function(in_file, out_file) {
  dir.create(dirname(out_file), recursive = TRUE, showWarnings = FALSE)
  file.copy(in_file, out_file, overwrite = TRUE)
  out_file
}

#' Fetch a DEM covering the shared plot bbox
#'
#' Kept separate from the hillshade build so that tuning the sun angle or
#' vertical exaggeration doesn't re-trigger the elevatr download.
#'
#' @param bbox sf bbox (with CRS); the shared plot extent
#' @param res_m numeric; grid resolution in bbox CRS units (metres for 5070)
#' @param z integer; elevatr zoom level — higher is finer and slower
#' @param expand numeric; bbox padding in CRS units, so edge cells have
#'   neighbours to compute slope from
#'
#' @returns SpatRaster; elevation on the plot grid
#'
get_plot_dem <- function(bbox, res_m = 2000, z = 6, expand = 10000) {
  template <- terra::rast(
    terra::ext(bbox["xmin"], bbox["xmax"], bbox["ymin"], bbox["ymax"]),
    resolution = res_m, crs = sf::st_crs(bbox)$wkt
  )
  elevatr::get_elev_raster(template, z = z, expand = expand, clip = "tile") |>
    terra::rast() |>
    terra::project(template) |>
    terra::resample(template) |>
    setNames("dem")
}

#' Build a shaded-relief land PNG from a DEM, on the shared plot-bbox grid
#'
#' This is the map's land layer, not a blend overlay: the flat-terrain tone is
#' baked in as `land_color` and everything outside `mask_sf` is written fully
#' transparent. That lets it sit beneath the SVG without a blend mode, and
#' means the SVG's states need no fill of their own — an opaque fill on top
#' would hide the relief, and a blend mode would tint the perimeters too.
#'
#' @param dem SpatRaster; elevation raster
#' @param bbox sf bbox (with CRS); the shared plot extent
#' @param mask_sf sf; land polygons to confine the shading to (NULL for none)
#' @param out_png character; path to write the RGBA PNG
#' @param width_px integer; output width — 2x the 720px SVG width for retina
#' @param land_color character; hex tone for flat terrain
#' @param angle numeric; sun altitude (degrees above horizon)
#' @param direction numeric; sun azimuth (degrees clockwise from north)
#' @param shadow_floor numeric; darkest a shadow may go, as a fraction of
#'   `land_color` — floored so deep shadows don't swallow the perimeters on top
#' @param z_factor numeric; vertical exaggeration so gentle relief reads
#'
#' @returns character; `out_png`
#'
build_hillshade_png <- function(dem, bbox, mask_sf, out_png, width_px = 1440,
                                land_color = "#f0f0f0",
                                angle = 45, direction = 315,
                                shadow_floor = 0.55, z_factor = 8) {
  dir.create(dirname(out_png), recursive = TRUE, showWarnings = FALSE)
  # Exaggerate elevation so gentle regional relief produces visible shading.
  dem <- dem * z_factor
  slope <- terra::terrain(dem, v = "slope", unit = "radians")
  aspect <- terra::terrain(dem, v = "aspect", unit = "radians")
  hs <- terra::shade(slope, aspect, angle = angle, direction = direction)

  # Resample onto the exact plot-bbox grid so it registers with the SVG layers.
  # Height comes from the bbox aspect ratio, the same way mapshaper derives the
  # SVG viewBox height — hardcoding it would drift from the map.
  height_px <- round(width_px *
                       (bbox["ymax"] - bbox["ymin"]) /
                       (bbox["xmax"] - bbox["xmin"]))
  template <- terra::rast(
    terra::ext(bbox["xmin"], bbox["xmax"], bbox["ymin"], bbox["ymax"]),
    ncol = width_px, nrow = height_px, crs = sf::st_crs(bbox)$wkt
  )
  hs <- terra::resample(hs, template)

  # Mask after resampling so the land edge falls on the same grid as the SVG.
  if (!is.null(mask_sf)) {
    mask_v <- terra::vect(sf::st_transform(mask_sf, sf::st_crs(bbox)))
    land <- !is.na(terra::mask(hs * 0, mask_v))
  } else {
    land <- terra::setValues(hs, 1)
  }

  # Scale relative to mean (flat) terrain so average ground keeps land_color and
  # only below-average slopes darken. Cap at 1 rather than letting sunlit faces
  # blow out past the land tone into white.
  ref <- terra::global(hs, "mean", na.rm = TRUE)[[1]]
  shade_frac <- terra::clamp(hs / ref, shadow_floor, 1)

  as_matrix <- function(r) matrix(terra::values(r), nrow = terra::nrow(r),
                                  ncol = terra::ncol(r), byrow = TRUE)
  s <- as_matrix(shade_frac)
  a <- as_matrix(land)
  # Flat interior cells with no DEM coverage still belong to the land mask, so
  # give them the unshaded tone rather than dropping them out of the polygon.
  s[is.na(s)] <- 1
  a[is.na(a)] <- 0

  rgb_land <- grDevices::col2rgb(land_color)[, 1] / 255
  img <- array(0, dim = c(nrow(s), ncol(s), 4))
  for (i in 1:3) img[, , i] <- rgb_land[i] * s
  img[, , 4] <- a

  png::writePNG(img, out_png)
  out_png
}

#' Export an sf object as an SVG using mapshaper
#' Follows the same pattern as gulf-hypoxia export_sf_layer_svg
export_sf_layer_svg <- function(sf_obj, out_svg, bbox, id_column = NULL, 
                                width_px = 720, simplify = NULL) {
  dir.create(dirname(out_svg), recursive = TRUE, showWarnings = FALSE)

  if (!is.null(id_column)) {
    raw <- as.character(sf_obj[[id_column]])
    sf_obj[[id_column]] <- gsub("^-+|-+$", "", gsub("[^a-z0-9]+", "-", tolower(raw)))
  }

  temp_gj <- tempfile(fileext = ".geojson")
  on.exit(unlink(temp_gj), add = TRUE)
  suppressWarnings(sf::st_write(sf_obj, temp_gj, quiet = TRUE))

  bbox_str <- sprintf("%.3f,%.3f,%.3f,%.3f",
                      bbox["xmin"], bbox["ymin"], bbox["xmax"], bbox["ymax"])
  args <- shQuote(temp_gj)

  if (!is.null(simplify)) {
    args <- c(args, "-simplify", simplify, "keep-shapes")
  }
  args <- c(
    args,
    "-o", "format=svg",
    paste0("svg-bbox=", bbox_str),
    paste0("width=", width_px)
  )
  if (!is.null(id_column)) {
    args <- c(args, paste0("id-field=", id_column))
  }
  args <- c(args, shQuote(out_svg))

  log <- system2("mapshaper", args = args, stdout = TRUE, stderr = TRUE)
  status <- attr(log, "status")
  if (!is.null(status) && status != 0) {
    stop("mapshaper SVG export failed (status ", status, "):\n",
         paste(log, collapse = "\n"))
  }

  out_svg
}

#' Export fire perimeters as a single SVG with year-grouped layers
export_fire_years_svg <- function(fires_by_year, out_svg, bbox, 
                                  width_px = 720, simplify = NULL) {
  dir.create(dirname(out_svg), recursive = TRUE, showWarnings = FALSE)

  # Add class column for CSS targeting: "fire yearXXXX"
  fires_by_year <- fires_by_year |>
    dplyr::mutate(class = paste0("fire year", YEAR))

  temp_gj <- tempfile(fileext = ".geojson")
  on.exit(unlink(temp_gj), add = TRUE)
  suppressWarnings(sf::st_write(fires_by_year, temp_gj, quiet = TRUE))

  bbox_str <- sprintf("%.3f,%.3f,%.3f,%.3f",
                      bbox["xmin"], bbox["ymin"], bbox["xmax"], bbox["ymax"])
  args <- shQuote(temp_gj)

  if (!is.null(simplify)) {
    args <- c(args, "-simplify", simplify, "keep-shapes")
  }
  args <- c(
    args,
    "-o", "format=svg",
    paste0("svg-bbox=", bbox_str),
    paste0("width=", width_px),
    "svg-data=class"
  )
  args <- c(args, shQuote(out_svg))

  log <- system2("mapshaper", args = args, stdout = TRUE, stderr = TRUE)
  status <- attr(log, "status")
  if (!is.null(status) && status != 0) {
    stop("mapshaper SVG export failed:\n", paste(log, collapse = "\n"))
  }

  out_svg
}

#' Assemble the final composite fire map SVG
#' Combines states, watersheds, and fire perimeters into a single SVG
#' that the Vue app loads at runtime
assemble_fire_map_svg <- function(states_svg, watersheds_svg, fire_svg,
                                  out_svg) {
  dir.create(dirname(out_svg), recursive = TRUE, showWarnings = FALSE)

  # Pull the drawing size out of a component rather than assuming it. mapshaper
  # sets height from the bbox aspect ratio, so for the western states this is
  # 720x845, not square. Hardcoding a square viewBox silently crops the
  # southern edge of the map.
  read_svg_dims <- function(svg_file) {
    header <- paste(readLines(svg_file, n = 5, warn = FALSE), collapse = " ")
    vb <- regmatches(header, regexpr('viewBox="[^"]+"', header))
    if (length(vb) == 0) stop("No viewBox found in ", basename(svg_file))
    as.numeric(strsplit(gsub('viewBox="|"', "", vb), "\\s+")[[1]])
  }

  dims <- read_svg_dims(states_svg)

  # Every layer shares the same bbox and width, so their viewBoxes must agree.
  # A mismatch means the layers would not register with each other.
  for (f in c(watersheds_svg, fire_svg)) {
    if (!isTRUE(all.equal(read_svg_dims(f), dims))) {
      stop("viewBox mismatch between ", basename(states_svg), " and ", basename(f))
    }
  }

  extract_svg_content <- function(svg_file) {
    lines <- readLines(svg_file, warn = FALSE)
    lines <- lines[!grepl("^<\\?xml", lines)]
    lines <- lines[!grepl("^<svg |^</svg>", lines)]
    paste(lines, collapse = "\n")
  }

  states_content <- extract_svg_content(states_svg)
  watersheds_content <- extract_svg_content(watersheds_svg)
  fire_content <- extract_svg_content(fire_svg)

  # No width/height attributes — the element scales to whatever its container
  # gives it, and CSS controls the fit. preserveAspectRatio keeps the projection
  # undistorted at any container shape.
  svg_out <- paste0(
    '<svg id="firemap" class="firemap" xmlns="http://www.w3.org/2000/svg" ',
    'preserveAspectRatio="xMidYMid meet" ',
    sprintf('viewBox="%s %s %s %s"', dims[1], dims[2], dims[3], dims[4]),
    ' role="img"',
    ' aria-label="Map of the western United States showing wildfire perimeters',
    ' by year over important water supply watersheds">\n',
    # Paint order: grey state fill, then the watershed overlay on top of it,
    # then fire perimeters above both. The acreage readout lives in the Vue
    # legend, so no text node is needed inside the SVG.
    '  <g id="basemap">\n',
    '    <g id="states">\n', states_content, '\n    </g>\n',
    '    <g class="IMP">\n', watersheds_content, '\n    </g>\n',
    '  </g>\n',
    '  <g class="fire_perimeters">\n', fire_content, '\n  </g>\n',
    '</svg>\n'
  )

  writeLines(svg_out, out_svg)
  out_svg
}
