#' Read a spatial layer and normalise the geometry column name to "geometry"
#'
#' GeoPackages name the geometry column according to whatever wrote them —
#' MTBS arrives as "geom", other sources use "geometry" or "SHAPE". Normalising
#' at read time lets downstream dplyr code refer to it by a stable name instead
#' of every function having to look up attr(x, "sf_column").
#' Extra arguments are passed to sf::st_read(), so `query` and `wkt_filter` can
#' be used to push filtering down to GDAL instead of loading everything first.
read_sf_norm <- function(dsn, ...) {
  x <- sf::st_read(dsn, ..., quiet = TRUE)

  geom_col <- attr(x, "sf_column")
  if (!identical(geom_col, "geometry")) {
    names(x)[names(x) == geom_col] <- "geometry"
    attr(x, "sf_column") <- "geometry"
  }

  x
}

#' Drop features with empty geometry
#'
#' Takes the whole sf object so it works regardless of the geometry column name,
#' which dplyr::filter() cannot do without naming the column.
drop_empty_geometry <- function(x) {
  x[!sf::st_is_empty(x), ]
}
