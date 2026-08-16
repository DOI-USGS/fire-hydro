#' Clip MTBS fire perimeters to the western states and tidy attributes
#'
#' MTBS fields used: ig_date (String "YYYY-MM-DD"), burnbndac (acres),
#' incid_name, incid_type. Source CRS is EPSG:4269; output matches
#' clip_boundary (EPSG:5070).
#'
#' st_intersection clips fires that straddle the state boundary so reported
#' acreage matches what the map draws. It is the slow step (~5 min over ~17k
#' fires) but only runs when the inputs change.
process_mtbs_fires <- function(gpkg, clip_boundary, keep_types) {
  target_crs <- sf::st_crs(clip_boundary)

  read_sf_norm(gpkg) |>
    dplyr::filter(incid_type %in% keep_types) |>
    dplyr::transmute(
      YEAR = as.integer(substr(ig_date, 1, 4)),
      incident = stringr::str_squish(stringr::str_to_lower(incid_name)),
      acres_reported = burnbndac,
      source = "MTBS"
    ) |>
    dplyr::filter(!is.na(YEAR)) |>
    sf::st_transform(target_crs) |>
    sf::st_make_valid() |>
    sf::st_filter(clip_boundary, .predicate = sf::st_intersects) |>
    sf::st_intersection(clip_boundary) |>
    sf::st_make_valid() |>
    drop_empty_geometry()
}

#' Clip WFIGS fire perimeters to the western states and tidy attributes
#'
#' Returns the same schema as process_mtbs_fires() — YEAR, incident,
#' acres_reported, source — so the two can be bound at the display seam.
#'
#' WFIGS fields used: poly_IncidentName, poly_GISAcres,
#' attr_FireDiscoveryDateTime. Source CRS is EPSG:4269.
#'
#' Duplicate perimeters: WFIGS carries both daily-progression and final
#' perimeters, so one fire can appear many times. Records are unioned per
#' (YEAR, incident) rather than reduced to a single "best" record. A daily
#' perimeter is contained by its final, so the union collapses to the final and
#' loses nothing, while two distinct fires sharing a name in one year both
#' survive as parts of a multipolygon.
#'
#' Timezone: the service returns discovery times in UTC, but a GeoPackage round
#' trip drops the tzone attribute, so R would format them in the pipeline
#' machine's local zone. Formatting in UTC keeps the year assignment identical
#' everywhere — a fire discovered just after midnight on January 1 UTC would
#' otherwise land in the previous year on a US-local machine.
process_wfigs_fires <- function(gpkg, clip_boundary) {
  target_crs <- sf::st_crs(clip_boundary)

  read_sf_norm(gpkg) |>
    dplyr::transmute(
      YEAR = as.integer(
        format(attr_FireDiscoveryDateTime, "%Y", tz = "UTC")
      ),
      incident = stringr::str_squish(stringr::str_to_lower(poly_IncidentName)),
      acres_reported = poly_GISAcres
    ) |>
    dplyr::filter(!is.na(YEAR), !is.na(incident), incident != "") |>
    sf::st_transform(target_crs) |>
    sf::st_make_valid() |>
    dplyr::group_by(YEAR, incident) |>
    dplyr::summarize(
      # Largest perimeter in the group, which is the final one where a final
      # exists. Used only for coverage QA; published acreage comes from
      # dissolved geometry.
      acres_reported = max(acres_reported, na.rm = TRUE),
      .groups = "drop"
    ) |>
    dplyr::mutate(source = "WFIGS") |>
    sf::st_make_valid() |>
    sf::st_filter(clip_boundary, .predicate = sf::st_intersects) |>
    sf::st_intersection(clip_boundary) |>
    sf::st_make_valid() |>
    drop_empty_geometry()
}

#' Dissolve one year of fire perimeters into a single simplified geometry
#'
#' Simplification runs per year so the branch caches independently. keep = 0.05
#' retains enough detail for a 720px map while keeping the SVG small.
dissolve_fire_year <- function(fires_sf, year) {
  dissolved <- fires_sf |>
    dplyr::filter(YEAR == year) |>
    dplyr::group_by(YEAR) |>
    dplyr::summarize(.groups = "drop") |>
    rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE) |>
    sf::st_make_valid()

  dissolved$area_acres <- as.numeric(
    units::set_units(sf::st_area(dissolved), "acres")
  )

  dissolved
}

#' Audit MTBS coverage against WFIGS so the completeness cutoff can be reviewed
#'
#' MTBS maps seasons retrospectively, so recent years are sparse until their
#' mapping finishes and the cutoff has to be re-judged each year.
#'
#' Read `mtbs_pct_of_wfigs`: values near 100 mean MTBS has finished that season,
#' a large shortfall means it has not. WFIGS is current within days of a fire,
#' which is what makes it a usable yardstick. A count-against-historical-median
#' test cannot do this job — it reads a quiet fire season as an unmapped one.
#'
#' The two sources measure different things (satellite burned-area extent versus
#' operational fire-line perimeter), so exact agreement is not expected and
#' small departures either way are normal. WFIGS coverage starts in 2020, so
#' earlier years have no comparison and are left blank.
#'
#' Acreage here is source-reported and used only for this diagnostic; published
#' acreage comes from dissolved geometry in write_fire_timeseries().
write_fire_coverage <- function(mtbs_sf, wfigs_sf, display_sf, out_csv) {
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)

  summarize_source <- function(x, prefix) {
    out <- x |>
      sf::st_drop_geometry() |>
      dplyr::group_by(YEAR) |>
      dplyr::summarize(
        n = dplyr::n_distinct(incident),
        acres = round(sum(acres_reported, na.rm = TRUE)),
        .groups = "drop"
      )
    names(out)[match(c("n", "acres"), names(out))] <-
      paste0(prefix, "_", c("n", "acres"))
    out
  }

  # Taken from the display set rather than re-deriving the seam rule, so this
  # cannot drift out of step with what the site publishes.
  published <- display_sf |>
    sf::st_drop_geometry() |>
    dplyr::group_by(YEAR) |>
    dplyr::summarize(
      published_source = paste(sort(unique(source)), collapse = "+"),
      .groups = "drop"
    )

  summarize_source(mtbs_sf, "mtbs") |>
    dplyr::full_join(summarize_source(wfigs_sf, "wfigs"), by = "YEAR") |>
    dplyr::left_join(published, by = "YEAR") |>
    dplyr::mutate(
      mtbs_pct_of_wfigs = ifelse(
        is.na(wfigs_acres) | wfigs_acres == 0 | is.na(mtbs_acres),
        NA_real_,
        round(100 * mtbs_acres / wfigs_acres)
      ),
      published_source = ifelse(is.na(published_source), "held back",
                                published_source)
    ) |>
    dplyr::arrange(YEAR) |>
    readr::write_csv(out_csv)

  out_csv
}

#' Write annual area burned to CSV for the D3 bar chart
#'
#' Area is taken from the dissolved per-year geometry, not by summing individual
#' fire areas. Summing double counts ground that burned twice in one season
#' (median 0.3% inflation, up to 2.3% in 2004) and would report a different
#' quantity than the map draws. The dissolved union is the same footprint the
#' SVG shows, so chart and map agree by construction.
#'
#' Fire counts still come from the undissolved records, since dissolving
#' destroys the per-incident rows.
#'
#' The `source` column travels with the series so the front end can mark which
#' years came from which source. Dissolving by year drops it, so it is recovered
#' from the undissolved records alongside the counts.
write_fire_timeseries <- function(fires_by_year, fires_sf, out_csv) {
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)

  area_by_year <- fires_by_year |>
    sf::st_drop_geometry() |>
    dplyr::select(YEAR, area_acres)

  count_by_year <- fires_sf |>
    sf::st_drop_geometry() |>
    dplyr::group_by(YEAR) |>
    dplyr::summarize(
      n_fires = dplyr::n_distinct(incident),
      source = paste(sort(unique(source)), collapse = "+"),
      .groups = "drop"
    )

  area_by_year |>
    dplyr::left_join(count_by_year, by = "YEAR") |>
    dplyr::arrange(YEAR) |>
    readr::write_csv(out_csv)

  out_csv
}

#' Compare the current area-burned series against an archived reference
#'
#' The 2020 site was built from NIFC/GeoMAC operational perimeters; this pipeline
#' uses MTBS. Totals are not expected to match exactly — MTBS excludes fires
#' under 1,000 acres — but a large or one-sided divergence signals a processing
#' problem rather than a source difference. Reviewed on each annual update.
write_source_comparison <- function(timeseries_csv, reference_csv, out_csv) {
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)

  current <- readr::read_csv(timeseries_csv, show_col_types = FALSE) |>
    dplyr::select(YEAR, mtbs_acres = area_acres)

  reference <- readr::read_csv(reference_csv, show_col_types = FALSE) |>
    dplyr::select(YEAR, reference_acres = area_acres)

  current |>
    dplyr::inner_join(reference, by = "YEAR") |>
    dplyr::mutate(
      ratio = round(mtbs_acres / reference_acres, 3),
      dplyr::across(c(mtbs_acres, reference_acres), round)
    ) |>
    dplyr::arrange(YEAR) |>
    readr::write_csv(out_csv)

  out_csv
}

#' Filter Forests to Faucets HUC12 watersheds to the important ones
#'
#' F2F2_HUC12 fields used: IMP_R (importance ranking), STATES.
#' Dissolved to a single geometry — the site draws these as one background layer
#' rather than per-watershed features.
process_important_watersheds <- function(gpkg, clip_boundary, importance_threshold) {
  target_crs <- sf::st_crs(clip_boundary)

  # The source holds 83k HUC12s nationally (~1.7 GB). Filter on IMP_R in SQL and
  # on extent via the spatial index so only the relevant subset is read into R,
  # rather than loading everything and discarding most of it.
  layer <- sf::st_layers(gpkg)$name[1]

  # wkt_filter must be expressed in the source CRS (EPSG:4269 here). Read zero
  # features to pick up the layer CRS without pulling any geometry.
  src_crs <- sf::st_crs(
    sf::st_read(
      gpkg,
      query = sprintf('SELECT * FROM "%s" LIMIT 0', layer),
      quiet = TRUE
    )
  )

  bbox_wkt <- clip_boundary |>
    sf::st_transform(src_crs) |>
    sf::st_bbox() |>
    sf::st_as_sfc() |>
    sf::st_as_text()

  read_sf_norm(
    gpkg,
    query = sprintf(
      'SELECT * FROM "%s" WHERE IMP_R >= %s', layer, importance_threshold
    ),
    wkt_filter = bbox_wkt
  ) |>
    sf::st_transform(target_crs) |>
    sf::st_make_valid() |>
    sf::st_filter(clip_boundary, .predicate = sf::st_intersects) |>
    dplyr::summarize(.groups = "drop") |>
    sf::st_intersection(clip_boundary) |>
    rmapshaper::ms_simplify(keep = 0.05, keep_shapes = TRUE) |>
    sf::st_make_valid() |>
    drop_empty_geometry()
}
