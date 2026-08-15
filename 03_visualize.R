p3_targets_list <- list(

  # Shared bounding box for all map layers
  tar_target(
    p3_plot_bbox,
    compute_plot_bbox(p2_states_sf)
  ),

  # Export state boundaries as SVG
  tar_target(
    p3_states_svg,
    export_sf_layer_svg(
      sf_obj = p2_states_sf,
      out_svg = "03_visualize/out/states.svg",
      bbox = p3_plot_bbox,
      id_column = "STUSPS"
    ),
    format = "file"
  ),

  # Export important watersheds as SVG
  tar_target(
    p3_watersheds_svg,
    export_sf_layer_svg(
      sf_obj = p2_important_watersheds,
      out_svg = "03_visualize/out/important_watersheds.svg",
      bbox = p3_plot_bbox,
      simplify = "5%"
    ),
    format = "file"
  ),

  # Export fire perimeters as per-year SVG groups
  tar_target(
    p3_fire_perimeters_svg,
    export_fire_years_svg(
      fires_by_year = p2_fires_by_year,
      out_svg = "03_visualize/out/fire_perimeters.svg",
      bbox = p3_plot_bbox,
      simplify = "5%"
    ),
    format = "file"
  ),

  # Copy the fire timeseries CSV to public/data for the Vue app
  tar_target(
    p3_timeseries_public,
    {
      file.copy(
        p2_fire_timeseries_csv,
        "public/data/fire_timeseries.csv",
        overwrite = TRUE
      )
      "public/data/fire_timeseries.csv"
    },
    format = "file"
  ),

  # Assemble final fire map SVG (states + watersheds + fire perimeters)
  tar_target(
    p3_fire_map_svg,
    assemble_fire_map_svg(
      states_svg = p3_states_svg,
      watersheds_svg = p3_watersheds_svg,
      fire_svg = p3_fire_perimeters_svg,
      out_svg = "public/data/fire_map.svg",
      bbox = p3_plot_bbox
    ),
    format = "file"
  )
)
