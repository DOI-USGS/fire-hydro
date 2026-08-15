p2_targets_list <- list(

  # Read and filter western states

  tar_target(
    p2_states_sf,
    read_states(p1_states_shp, western_states)
  ),

  # Union of western states for clipping
  tar_target(
    p2_usa_clip,
    sf::st_union(p2_states_sf)
  ),

  # Clean and crop fire perimeters to western US, 1984-present
  tar_target(
    p2_fires_sf,
    process_fire_perimeters(
      gpkg = p1_fire_perimeters_gpkg,
      clip_boundary = p2_usa_clip,
      year_range = c(1984, 2024)
    )
  ),

  # Aggregate fire perimeters by year (dissolved)
  tar_target(
    p2_fires_by_year,
    aggregate_fires_by_year(p2_fires_sf)
  ),

  # Compute annual fire statistics (area burned, frequency, etc.)
  tar_target(
    p2_fire_timeseries_csv,
    compute_fire_timeseries(
      fires_sf = p2_fires_sf,
      states_sf = p2_states_sf,
      out_csv = "02_process/out/fire_timeseries.csv"
    ),
    format = "file"
  ),

  # Filter Forest to Faucets watersheds (importance >= 50)
  tar_target(
    p2_important_watersheds,
    process_important_watersheds(
      gpkg = p1_f2f_gpkg,
      clip_boundary = p2_usa_clip,
      importance_threshold = 50
    )
  )
)
