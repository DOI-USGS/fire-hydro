build_svg_map <- function(svg_fp, svg_height, svg_width) {
  
  ##### Create whole SVG #####
  svg_root <- init_svg(viewbox_dims = c(0, 0, svg_width, svg_height))
  
  ##### Add the SVG nodes #####
  
  #add_background_map(svg_root, svg_width)
  add_shapes(svg_root, svg_width, imp_in = 'shapes/f2f2_imp_50_agg.shp')
  
  ##### Write out final SVG to file #####
    xml2::write_xml(svg_root, file = svg_fp)
  
}

add_background_map <- function(svg, svg_width) {
  map_data <- generate_usa_map_data()%>% 
    st_cast('MULTIPOLYGON')%>%
    st_cast(to='POLYGON', do_split=TRUE)%>%
    mutate(poly_id = paste0(STUSPS, '-', rownames(.)))
  
  bkgrd_grp <- xml_add_child(svg, 'g', id = "states")
  purrr::map(map_data$poly_id, function(polygon_id, map_data, svg_width) {
    d <- map_data %>%
      filter(poly_id == polygon_id) %>% 
      convert_coords_to_svg(view_bbox = st_bbox(map_data), svg_width) %>% 
      build_path_from_coords()
    xml_add_child(bkgrd_grp, 'path', d = d, class='outline-states', id=sprintf('outline-%s',polygon_id))
  }, map_data, svg_width)
  
}

add_shapes <- function(svg=svg_root, svg_width, imp_in ){
  
  imp_data <- st_read(imp_in)%>% 
    st_cast(to='POLYGON', do_split=TRUE)%>%
    mutate(poly_id = rownames(.)) %>%
    st_buffer(0) 
  
  imp_grp <- xml_add_child(svg, 'g', id = "IMP")
  
  purrr::map(imp_data$poly_id, function(polygon_id, imp_data, svg_width) {
    d <- imp_data %>%
      filter(poly_id == polygon_id) %>% 
      convert_coords_to_svg(view_bbox = st_bbox(imp_data), svg_width) %>% 
      build_path_from_coords()
    xml_add_child(imp_grp, 'path', d = d, class='IMP-50')
  }, imp_data, svg_width)

  
}

build_svg_map(svg_fp = '6_visualize/out/fires.svg', svg_height, svg_width)


