#' Generate a small multiple QAQC map of fire perimeters by year
#' Produces a PNG with one facet per year for visual inspection
qaqc_fire_map <- function(fires_by_year, states_sf, out_png) {
  dir.create(dirname(out_png), recursive = TRUE, showWarnings = FALSE)

  # Drop years that dissolved to nothing
  fires_valid <- fires_by_year |>
    dplyr::filter(area_acres > 0) |>
    drop_empty_geometry()

  p <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = states_sf, fill = "#f0f0f0", color = "#cccccc", linewidth = 0.2) +
    ggplot2::geom_sf(data = fires_valid, fill = "#fa6d31", color = NA, alpha = 0.7) +
    ggplot2::facet_wrap(~YEAR, ncol = 6) +
    ggplot2::theme_void() +
    ggplot2::theme(
      strip.text = ggplot2::element_text(size = 7, margin = ggplot2::margin(b = 2)),
      panel.border = ggplot2::element_rect(fill = NA, color = "#e0e0e0", linewidth = 0.3)
    )

  ggplot2::ggsave(out_png, p, width = 12, height = 10, dpi = 150, bg = "white")
  out_png
}
