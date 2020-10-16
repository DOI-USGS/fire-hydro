map_shapes <- function(states_in){
  proj<-'+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'
  
  state_sf <- st_read(states_in) %>% 
    dplyr::select(ID = STUSPS, NAME)  %>% 
    st_transform(proj) %>% 
    filter(ID %in% c('CA','WA','NV','UT','CO','AZ','NM', 'MT', 'WY', 'OR', 'ID')) 
  
  return(states_west)
}

fetch_fire_perimeter <- function(target_name, query, usa_map)  {

  got <- content(GET(query), 'text')
  
  fire_sf <- geojson_sf(got) 
  
  fire_crop <- fire_sf %>%
    st_buffer(0) %>%
    st_crop(usa_map%>%st_transform(st_crs(fire_sf))%>%st_bbox())%>%
    st_buffer(0)%>%
    mutate(Incident=str_trim(tolower(IncidentName)), 
           YEAR = as.numeric(word(CreateDate, 1, 1, sep='-'))) 
  
  saveRDS(fire_crop, file = target_name)
}
