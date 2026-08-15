#' Read and filter state boundaries to western states
read_states <- function(states_file, state_codes) {
  proj <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

  sf::st_read(states_file, quiet = TRUE) |>
    dplyr::filter(STUSPS %in% state_codes) |>
    sf::st_transform(proj)
}

#' Process raw fire perimeters: crop, filter years, clean geometry
process_fire_perimeters <- function(gpkg, clip_boundary, year_range) {
  proj <- sf::st_crs(clip_boundary)

  fires <- sf::st_read(gpkg, quiet = TRUE) |>
    sf::st_transform(proj) |>
    sf::st_make_valid() |>
    dplyr::filter(
      FIRE_YEAR >= year_range[1],
      FIRE_YEAR <= year_range[2]
    ) |>
    sf::st_crop(sf::st_bbox(clip_boundary)) |>
    sf::st_make_valid() |>
    dplyr::mutate(
      YEAR = as.integer(FIRE_YEAR),
      Incident = stringr::str_trim(tolower(INCIDENT))
    ) |>
    dplyr::select(YEAR, Incident)

  fires
}

#' Dissolve fire perimeters by year and simplify
aggregate_fires_by_year <- function(fires_sf) {
  fires_sf |>
    dplyr::group_by(YEAR) |>
    dplyr::summarize(.groups = "drop") |>
    rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE) |>
    sf::st_make_valid()
}

#' Compute annual fire statistics
compute_fire_timeseries <- function(fires_sf, states_sf, out_csv) {
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)

  fire_stats <- fires_sf |>
    dplyr::mutate(
      area_acres = as.numeric(units::set_units(sf::st_area(geometry), "acres"))
    ) |>
    sf::st_drop_geometry() |>
    dplyr::group_by(YEAR) |>
    dplyr::summarize(
      area_acres = sum(area_acres, na.rm = TRUE),
      .groups = "drop"
    )

  readr::write_csv(fire_stats, out_csv)
  out_csv
}

#' Filter Forest to Faucets watersheds by importance threshold
process_important_watersheds <- function(gpkg, clip_boundary, importance_threshold) {
  proj <- sf::st_crs(clip_boundary)

  sf::st_read(gpkg, quiet = TRUE) |>
    sf::st_transform(proj) |>
    dplyr::filter(IMP_R >= importance_threshold) |>
    sf::st_union() |>
    sf::st_make_valid() |>
    sf::st_crop(sf::st_bbox(clip_boundary)) |>
    rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE) |>
    sf::st_make_valid() |>
    sf::st_sf(geometry = _)
}
