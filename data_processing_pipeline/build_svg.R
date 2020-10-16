## build svg map

library(tidyverse)
library(sf);library(raster)
library(scico)
library(rmapshaper)
library(maptools)
library(maps)
library(units)
library(patchwork)
library(beepr)
library(xml2)

## layers

proj<-'+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'

states<-c('CA','WA','NV','UT','CO','AZ','NM', 'MT', 'WY', 'OR', 'ID')
states_in <-'1_fetch/out/cb_2018_us_state_5m/cb_2018_us_state_5m.shp'

state_sf <- st_read(states_in) %>% 
  dplyr::select(ID = STUSPS, NAME)  %>% 
  st_transform(proj)
plot(state_sf)
states_west <- state_sf %>% 
  filter(ID %in% states) 
plot(states_west)

plot(st_union(states_west))
states_west_crop <- states_west %>%
  st_crop(st_bbox(states_west))

past<-readRDS('1_fetch/out/fire_perimeter_past.rds')
glimpse(past)

proj<-'+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'

fire_in <- readRDS('1_fetch/out/fire_perimeter_past.rds') %>%st_transform(proj)

if ('INCIDENT' %in% colnames(fire_in)) {
  fire_in <- fire_in %>%
    select(IncidentName = INCIDENT, CreateDate = FIRE_YEAR, everything())
} else {
  fire_in <- fire_in
}
length(unique(fire_in$CreateDate))
glimpse(fire_in)
plot(fire_in)

fire_in%>%st_drop_geometry()%>%View
bbox_crop <- usa_map %>% st_transform(st_crs(proj)) %>% st_bbox()

fire_incident <- fire_in %>%
  st_buffer(0) #%>%
  st_crop(bbox_crop)#%>%
  mutate(Incident=str_trim(tolower(IncidentName)), 
         CreateDate = as.POSIXct(as.numeric(CreateDate)/1000, origin = "1970-01-01", tz= "GMT"),
         YEAR = as.numeric(word(CreateDate, 1, 1, sep='-'))) #%>%
  st_transform(proj) %>%
  st_buffer(0) %>% 
  group_by(YEAR, Incident) %>%
  summarize() %>% 
  ms_simplify() %>%
  st_buffer(0)
glimpse(fire_incident)

ggplot(data=usa_map)+
  geom_sf(color="black", fill=NA)+
  geom_sf(data=fire_in, fill="orangered", color=NA)+
  theme_void()

st_write(fire_incident, target_name, driver = 'ESRI Shapefile', delete_layer = TRUE)

bbox_crop <- usa_map%>%st_transform(st_crs(fire_in))%>%st_bbox()

fire_incident <- fire_in %>%
  st_buffer(0)%>%
  st_crop(bbox_crop)%>%
  mutate(Incident=str_trim(tolower(IncidentName)), 
         CreateDate = as.POSIXct(as.numeric(CreateDate)/1000, origin = "1970-01-01", tz= "GMT"),
         YEAR = as.numeric(word(CreateDate, 1, 1, sep='-'))) %>%
  st_transform(proj) %>%
  st_buffer(0) %>% 
  group_by(YEAR, Incident) %>%
  summarize() %>% 
  ms_simplify() %>%
  st_buffer(0)

# states
# usa outline

states <- st_read('shapes/cb_2018_us_state_5m') %>% dplyr::select(ID = STUSPS, NAME)  %>% 
  st_transform(crs_albers)
states_west <- states %>% 
  filter(ID %in% c('CA','WA','NV','UT','CO','AZ','NM', 'MT', 'WY', 'OR', 'ID')) 

bbox_albers <- states_west%>% st_bbox()
states_west <- states  %>% st_crop(bbox_west_albers)%>%st_transform(crs_forest)
usa <- states_west %>%st_union() 

plot_base <- ggplot()+geom_sf(data=states_west, fill=NA, color='grey90')+geom_sf(data=usa, fill=NA, color="black")+theme_void()
plot_base


########################
#forest and watersheds
# NAD83 (EPSG:4269)
# +init=epsg:4269 +proj=longlat +ellps=GRS80 +datum=NAD83
# +no_defs +towgs84=0,0,0

crs_albers <-'+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'

## shapefiles
imp <- st_read('2_process/out/f2f2_IMP50.shp', driver = "ESRI Shapefile")#%>%st_as_sf()# important watersheds - top 50%
glimpse(imp)

forest <- st_read('2_process/out/f2f2_FOREST_20.shp', driver = "ESRI Shapefile")# forested area - over 20%
forest_imp <- st_read('2_process/out/f2f2_FOREST_20_IMP_50.shp', driver = "ESRI Shapefile") #intersection of watersheds and forested area
nlcd_forest <- raster('2_process/out/nlcd_reclass.grd') # rasters
plot(nlcd_forest)

## land cover
crs_forest<-crs(nlcd_forest)
crs_forest

crs_albers
# different - lat_0
## hwat does it mean when there are 2 lat values given??
# datum=NAD83 vs none
# towgs84??
##GRS=80
bbox_stat<-extent(c(st_bbox(usa)))
bbox_stat
extent(c(xmin=-2356114, xmax=-504612.5, ymin = 991812.8, ymax = 3172567.9))
c(st_bbox(usa))
st_bbox(usa)

extent(nlcd_forest)
# crop to states
forest_crop<-crop(nlcd_forest, extent(c(xmin=-2356114, xmax=-504612.5, ymin = 991812.8, ymax = 3172567.9)))
plot(forest_crop)
writeRaster(forest_crop, 'rasters/nlcd_reclass.grd', overwrite=TRUE)

# convert  to df for plotting
forest_df <- as.data.frame(nlcd_forest, xy=TRUE)


## fire layers
fire_total<- st_read('2_process/out/fire_by_year.shp')%>%transform(YEAR = as.numeric(FIRE_YEAR))%>%st_transform(crs_albers)%>%
  select(YEAR) %>%ms_simplify()
glimpse(fire_total)

st_write(fire_total, 'fire_shp/fire_years.shp', driver='ESRI Shapefile')

fire_2020 <-st_read('2_process/out/fire_2020_now.shp')
glimpse(fire_2020)
length(unique(fire_2020$Incident))

fire_2020_simp <- fire_2020 %>% ms_simplify()
glimpse(fire_2020_simp)

fire_2020<-fire_2020_simp%>%group_by(YEAR)%>%summarize()
glimpse(fire_2020)
plot(fire_2020)

st_write(fire_2020, 'fire_shp/fire_years_2020.shp', driver='ESRI Shapefile')

##important watersheds - top 50%
layer_imp<-st_read('shapes/f2f2_imp_50_agg.shp')%>%ms_simplify()%>%st_buffer(0)%>%st_intersection(usa)

plot_base + geom_sf(data=layer_imp, fill='paleturquoise', color=NA)
ggsave('6_visualize/out/IMP_50.svg', width=10, height=10)

layer_for_simp<-layer_for_simp%>%ms_simplify()
plot_base + geom_sf(data=layer_for_simp, fill='forestgreen', color=NA)
ggsave('6_visualize/out/forest_20.svg', width=10, height=10)

plot_base + geom_sf(data=forest_imp, fill='darkorchid3', color=NA)


## plot each year of fires
lapply(1984:2018, function(x){
  fire_yr<-fire_total%>%filter(YEAR == x)%>%
    ms_simplify()
  
  #plot_base + 
  #  geom_sf(data=fire_yr, fill='orange', color=NA)
  
  #ggsave(paste0('6_visualize/out/fire_', x, '.svg'), width=10, height=10)
})

fire_now<-fire_2020%>%ms_simplify()
fire_2020<-fire_now%>%group_by(YEAR)%>%summarize()%>%ms_simplify()

plot_base + 
  geom_sf(data=fire_2020, fill='orange', color=NA)

ggsave('6_visualize/out/fire_2020.svg', width=10, height=10)

## intersect fire years with forest watersheds
forest_imp<-st_read('shapes/f2f2_FOREST_20_IMP_50.shp')
st_crs(forest_imp)
st_crs(fire_total)

## plot each year of fires
lapply(1984:2018, function(x){
  
  fire_yr<-fire_total%>%
    filter(YEAR == x)%>%
    ms_simplify()%>%
    st_buffer(0)%>%
    st_intersection(forest_imp)%>%
    st_buffer(0)
  
  
  st_write(fire_yr, paste0('6_visualize/tmp/fire_', x, '.shp'), driver = 'ESRI Shapefile', delete_layer=TRUE)
})

fire_yr<-fire_2020%>%
  ms_simplify()%>%
  st_buffer(0)%>%
  st_intersection(forest_imp)%>%
  st_buffer(0)


st_write(fire_yr, paste0('6_visualize/tmp/fire_2020.shp'), driver = 'ESRI Shapefile', delete_layer=TRUE)

fire_yr<-fire_2019%>%
  ms_simplify()%>%
  st_buffer(0)%>%
  st_intersection(forest_imp)%>%
  st_buffer(0)


st_write(fire_yr, paste0('6_visualize/tmp/fire_2019.shp'), driver = 'ESRI Shapefile', delete_layer=TRUE)

## what is the total area burned over time?
area_burn<-lapply(1984:2018, function(x){
  
  fire_yr<-fire_total%>%
    filter(YEAR == x)
  
  set_units(st_area(fire_yr), mi^2)
  
  
})

burn_past<-data.frame(burn_mi2 = area_burn%>%unlist(), year = 1984:2018)

burn_mi2<-rbind(burn_past,data.frame(burn_mi2 = as.numeric(set_units(st_area(fire_2019), mi^2)), year=2019),
      data.frame(burn_mi2 = as.numeric(set_units(st_area(fire_2020), mi^2)), year=2020))
write.csv(burn_mi2,'2_process/out/burn_mi2.csv')

## read in and calculate area for each year
## what is the total area in important watersheds burned over time?
areas <- lapply(list.files('6_visualize/tmp', pattern='.shp', full.names=TRUE), function(x)set_units(st_area(st_read(x)), mi^2))
gsub('.shp', '', gsub('fire_', '', list.files('6_visualize/tmp', pattern='.shp')))
imp_burn <-data.frame(for_imp_burn_mi2 = areas%>%unlist(), 
                      year = as.numeric(gsub('.shp', '', gsub('fire_', '', list.files('6_visualize/tmp', pattern='.shp')))))%>%
  left_join(burn_mi2)

ggplot(imp_burn)+
  geom_point(aes(x=year, for_imp_burn_mi2*640), color='paleturquoise')+
  geom_point(aes(year,y=burn_mi2*640), color='orangered')+
  labs(x='Year', y='Area burned (sq mi)')+
  geom_line(aes(x=year, for_imp_burn_mi2*640), color='paleturquoise')+
  geom_line(aes(x=year, burn_mi2*640), color='orangered')


## what proportion of area burned was in important watersheds?

# putting it all together -------------------------------------------------
burn<-read.csv('2_process/out/burn_mi2.csv')

ggplot(burn, aes(year, burn_mi2))+
  geom_bar(stat='identity')+
  geom_point(shape=21, stroke=2, size=3)+
  geom_line()+
  geom_smooth(method="lm", se=FALSE)+
  theme_classic(base_size=16)+
  labs(x='', y="Area burned")+
  scale_x_continuous(limits=c(1983, NA), expand=expansion(mult=c(0, 0)))+
  scale_y_continuous(expand=expansion(mult=c(0.1, .01)))

ggsave('6_visualize/out/area_time.svg', width=10, height=3)


ggplot(burn, aes(year, burn_mi2))+
  geom_bar(stat='identity')+
  geom_point(shape=21, stroke=2, size=3)+
  geom_line()+
  geom_smooth(method="lm", se=FALSE)+
  theme_classic(base_size=16)+
  labs(x='', y="Area burned")+
  scale_x_continuous(limits=c(1983, NA), expand=expansion(mult=c(0, 0)))+
  scale_y_continuous(expand=expansion(mult=c(0.1, .01)))

ggsave('6_visualize/out/area_time_line.svg', width=10, height=3)

burn_st <- burn %>%
  mutate(burn_km2 = burn_mi2*2.58999,
         burn_acres = burn_mi2*640,
         burn_acres_mil = burn_acres/1000000,
         burn_acres_mil_scaled =rescale(burn_acres_mil, c(0,100)),
         year_scaled = rescale(year, c(0,100)),
         burn_scaled_svg = 100-burn_acres_mil_scaled)
write.csv(burn_st,'2_process/out/burn_mi2.csv')

## how many large fires?
