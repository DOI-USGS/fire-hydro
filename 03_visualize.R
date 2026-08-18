p3_targets_list <- list(

  # QAQC: small multiple map of fire perimeters by year.
  # Branches of p2_fires_by_year are aggregated automatically.
  tar_target(
    p3_qaqc_fire_map,
    qaqc_fire_map(
      fires_by_year = p2_fires_by_year,
      states_sf = p2_states_sf,
      out_png = "03_visualize/out/qaqc_fire_by_year.png"
    ),
    format = "file"
  ),

  # Shared bounding box so every exported layer overlays exactly
  tar_target(
    p3_plot_bbox,
    compute_plot_bbox(p2_states_sf)
  ),

  # Elevation over the plot extent. Split from the hillshade build so retuning
  # the sun angle or exaggeration doesn't repeat the elevatr download.
  geotargets::tar_terra_rast(
    p3_plot_dem,
    get_plot_dem(bbox = p3_plot_bbox)
  ),

  # Grayscale relief the Vue app multiply-blends behind the map SVG. Masked to
  # the states so shading stops at the coastline and the national border.
  tar_target(
    p3_hillshade_png,
    build_hillshade_png(
      dem = p3_plot_dem,
      bbox = p3_plot_bbox,
      mask_sf = p2_states_sf,
      out_png = "public/data/hillshade.png"
    ),
    format = "file"
  ),

  # State outlines. Not simplified upstream, so simplify here.
  tar_target(
    p3_states_svg,
    export_sf_layer_svg(
      sf_obj = p2_states_sf,
      out_svg = "03_visualize/out/states.svg",
      bbox = p3_plot_bbox,
      id_column = "STUSPS",
      simplify = "10%"
    ),
    format = "file"
  ),

  # Important watersheds. Already simplified in 02_process, so no simplify here.
  tar_target(
    p3_watersheds_svg,
    export_sf_layer_svg(
      sf_obj = p2_important_watersheds,
      out_svg = "03_visualize/out/important_watersheds.svg",
      bbox = p3_plot_bbox
    ),
    format = "file"
  ),

  # Fire perimeters, one group per year. Already simplified in 02_process.
  tar_target(
    p3_fire_perimeters_svg,
    export_fire_years_svg(
      fires_by_year = p2_fires_by_year,
      out_svg = "03_visualize/out/fire_perimeters.svg",
      bbox = p3_plot_bbox
    ),
    format = "file"
  ),

  # Timeseries CSV for the D3 bar chart
  tar_target(
    p3_timeseries_public,
    copy_to_public(p2_fire_timeseries_csv, "public/data/fire_timeseries.csv"),
    format = "file"
  ),

  # Composite SVG the Vue app fetches at runtime
  tar_target(
    p3_fire_map_svg,
    assemble_fire_map_svg(
      states_svg = p3_states_svg,
      watersheds_svg = p3_watersheds_svg,
      fire_svg = p3_fire_perimeters_svg,
      out_svg = "public/data/fire_map.svg"
    ),
    format = "file"
  )
)
