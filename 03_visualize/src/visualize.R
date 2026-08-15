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
