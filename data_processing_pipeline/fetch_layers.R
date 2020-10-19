# fire - hydrology --------------------------------------------------------


# preliminaries -----------------------------------------------------------

library(tidyverse)
library(sf);library(raster)
library(scico)
library(rmapshaper)
library(maptools)
library(maps)
library(units)
library(patchwork)
library(beepr)

num<-function(x){length(unique(x))}
theme_set(theme_classic(base_size=18))

fire_2020<-readRDS('1_fetch/out/fire_perimeter_present.rds')
glimpse(fire_2020)

crop<-readRDS('2_process/out/fire_present_incident.rds')
glimpse(crop)
plot(crop)

layers_in = I(c('2_process/out/fire_present_incident.rds'))
fire_all <- do.call(rbind, lapply(layers_in, function(x)readRDS(x))) %>%
  filter(YEAR >=1983, YEAR <=2020) %>%
  mutate(Incident = word(Incident, 1,2), YEAR=as.character(YEAR)) 
str(fire_all)
unique(fire_all$YEAR)

fire_agg <- fire_all %>%
  group_by(YEAR, Incident) %>%
  summarize() %>%
  st_buffer(0) %>% 
  st_as_sf()
glimpse(fire_agg)
str(fire_agg)


fire_yr <- fire_agg %>% ungroup() %>% mutate(km2 = as.numeric(set_units(st_area(.), km^2)),
         acres = as.numeric(set_units(st_area(.), mi^2))*640,
         YEAR = as.factor(YEAR)) %>%
  st_drop_geometry() %>%
  group_by(YEAR) %>%
  summarize(area_km2 = sum(km2, na.rm=TRUE),
            area_acres = sum(acres, na.rm=TRUE))
View(fire_yr)
write.csv(fire_yr, '2_process/out/fire_timeseries.csv', row.names=FALSE)



# read in states ----------------------------------------------------------

states <- st_read('shapes/cb_2018_us_state_5m') %>% dplyr::select(ID = STUSPS, NAME) 
states_west <- states %>% 
  filter(ID %in% c('CA','WA','NV','UT','CO','AZ','NM', 'MT', 'WY', 'OR', 'ID'))

# crs projections  ----------------------------------------------------------

crs_laea <- "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"
crs_wgs84 <- '+proj=longlat +datum=WGS84 +no_defs'
crs_nad83 <- states %>% st_crs()
crs_albers <-'+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs'

# states bbox -------------------------------------------------------------

bbox_west_nad83 <- states_west %>% st_transform(crs_nad83) %>% st_bbox() 
bbox_wgs84 <- states_west %>% st_transform(crs_wgs84) %>% st_bbox() 
bbox_west_albers <- states_west %>% st_transform(crs_albers) %>% st_bbox()

# build basemap -----------------------------------------------------

## crop shapefile with bbox to get partial states
states_west <- states_west %>% st_transform(crs_albers) #%>% st_crop(bbox_west_albers)
usa <- states_west %>%st_union() 

plot_base <- ggplot(states_west) +
  geom_sf(fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  theme_void() +
  theme(legend.position = 'none')

plot_base

# forests to faucets data -------------------------------------------------

st_layers("Forests2Faucets/Forests2Faucets/F2F2_Sept2020/F2F2_2019.gdb")

# USGS Estimated Use of Water in the United States, County-Level Data for 2015 
# use <- st_read("Forests2Faucets/Forests2Faucets/F2F2_Sept2020/F2F2_2019.gdb", layer="USGS_WaterUse")
# glimpse(use)

## Forests to Faucets data layers
f2f2 <- st_read("Forests2Faucets/Forests2Faucets/F2F2_Sept2020/F2F2_2019.gdb", layer="F2F2_HUC12") #%>% ms_simplify()
glimpse(f2f2)

## read in data and refine variables describing forest areas
f2f2 <- f2f2 %>% 
  dplyr::select(REGION, REGIONNAME, STATES, HUC12, NAME, Acres, FOREST, PER_FOR, IMP, IMP_R, WFP, WFP_IMP_R) %>%
  mutate(INFOR=round(IMP_R*PER_FOR/100,0)) %>%
  mutate(FOR=round(PER_FOR,0))%>%
  st_transform(crs_albers) %>% 
  st_buffer(0) %>%
  st_crop(bbox_west_albers) %>% 
  st_buffer(0)
glimpse(f2f2)

st_write(f2f2, 'shapes/f2f2_layers.shp', driver = 'ESRI Shapefile', delete_layer=TRUE)
f2f2 <- st_read('shapes/f2f2_layers.shp')

## generate Sheila's indices and aggregate maps
fire_imp <- function(region, varname){

  f2f2 %>%
    filter(REGION == region)%>%
    group_by(REGION, IMP_R)%>%
    summarize()%>%
    st_write(paste0('shapes/fire_state/region_', region,'_', varname, '.shp'), driver = "ESRI Shapefile", delete_layer=TRUE)

}

region_list <- unique(f2f2$REGION)

lapply(region_list, function(x)fire_imp(x, varname='IMP_R'))

# read back in and bind, aggregate

## top 50% most important watersheds
region_imp<-do.call(rbind, lapply(region_list, function(x)st_read(paste0('shapes/fire_state/region_', x, '_IMP_R.shp'))))%>%
  filter(IMP_R >= 50)%>%
  group_by(IMP_R)%>%
  summarize()%>%
  st_as_sf()
str(region_imp)

# beautiful!
plot_base + 
  geom_sf(data=region_imp, aes(fill=IMP_R), color=NA, alpha=.7)+
  scale_fill_scico(palette='hawaii')

st_write(region_imp, 'shapes/f2f2_imp_50.shp', driver = "ESRI Shapefile", delete_layer=TRUE)
region_imp<-st_read('shapes/f2f2_imp_50.shp')

## aggregate to just one block
layer_imp <- region_imp%>%st_union()%>%st_intersection(usa)

# cute
plot_base + 
  geom_sf(data=layer_imp, fill="paleturquoise", color=NA, alpha=.7)

st_write(layer_imp, 'shapes/f2f2_imp_50_agg.shp', driver = "ESRI Shapefile", delete_layer=TRUE)
layer_imp<-st_read('shapes/f2f2_imp_50_agg.shp')
str(layer_imp)

## repeat for percent forest cover
#lapply(region_list, function(x)fire_by_region(x, var='INFOR'))

fire_forest <- function(region, varname){
  
  f2f2 %>%
    filter(REGION == region)%>%
    group_by(REGION, FOR)%>%
    summarize()%>%
    st_write(paste0('shapes/fire_state/region_', region,'_', varname, '.shp'), driver = "ESRI Shapefile", delete_layer=TRUE)
  
}
lapply(region_list, function(x)fire_forest(x, var='FOR'))


#state_infor<-do.call(rbind, lapply(unique(fire$STATES), function(x)st_read(paste0('shapes/fire_state/region_', x, '_INFOR.shp'))))%>%
#  filter(INFOR >= 20)%>%
#  group_by(INFOR)%>%
#  summarize()
#glimpse(state_infor)
#
state_for<-do.call(rbind, lapply(region_list, function(x)st_read(paste0('shapes/fire_state/region_', x, '_FOR.shp'))))%>%
  filter(FOR > 0)%>%
  group_by(FOR)%>%
  summarize()
glimpse(state_for)
st_write(state_for, 'shapes/f2f2_PER_FOR.shp', driver = "ESRI Shapefile", delete_layer=TRUE)

state_for<-st_read('shapes/f2f2_PER_FOR.shp')#%>%ms_simplify()
str(state_for)

state_for_10 <- state_for %>%
  mutate()

# beautiful!
plot_base + 
  geom_sf(data=state_for, aes(fill=FOR), color=NA, alpha=.7)+
  scale_fill_scico(palette='bamako')

state_all<-state_for %>%
  group_by(FOR)%>%
  summarize() %>%
  st_intersection(usa)

layer_for <- state_for %>%
  filter(FOR >= 20)%>%
  group_by()%>%
  summarize()

st_write(layer_for, 'shapes/f2f2_PER_FOR_agg.shp', driver = "ESRI Shapefile", delete_layer=TRUE)
layer_for<-st_read('shapes/f2f2_PER_FOR_agg.shp') 
glimpse(layer_for)

plot_base + 
  geom_sf(data=layer_for, fill='forestgreen', color=NA, alpha=.7)

## make series of plots with percent forested

for (i in seq(10, 100, by=10)){
  
  state_i<-state_all %>%
    filter(FOR >= i)%>%
    group_by()%>%
    summarize();beep()
  
  plot_base + 
    geom_sf(data=state_i, fill='forestgreen', color=NA, alpha=.7)
  
  ggsave(paste0('6_visualize/out/forest_', i, '.svg'), width=10, height=10)
}

### simplify layers
layer_imp_simp <-layer_imp %>% st_buffer(0) %>% ms_simplify()
plot_base + geom_sf(data=layer_imp_simp, fill='forestgreen', color=NA, alpha=.7)
st_write(layer_imp_simp, 'shapes/f2f2_IMP50.shp', driver = "ESRI Shapefile", delete_layer=TRUE)

layer_for_simp <-layer_for %>% st_buffer(0) %>% ms_simplify() %>%st_as_sf()
plot_base + geom_sf(data=layer_imp_simp, fill='forestgreen', color=NA, alpha=.7)
st_write(layer_for_simp, 'shapes/f2f2_FOREST_20.shp', driver = "ESRI Shapefile", delete_layer=TRUE)

glimpse(layer_imp_simp%>%dplyr::mutate(layer="IMP"))
glimpse(layer_imp)

layer_for_simp <- st_read('shapes/f2f2_FOREST_20.shp')%>%st_buffer(0)%>%st_intersection(states_west)%>%ms_simplify()
layer_imp_simp<-st_read('shapes/f2f2_IMP50.shp')%>%st_buffer(0)%>%st_intersection(states_west)%>%st_union()

glimpse(layer_imp_simp)
unique(layer_imp_simp$ID)

plot_base+geom_sf(data=layer_imp_simp, fill=NA, color="forestgreen")+theme_void()

ggsave('maps/f2f2_IMP50.svg', width=10, height=10)
length(unique(fire_total$YEAR))

## the intersection of forest cover and important watersheds
forest_imp <- layer_for_simp %>% 
  st_buffer(0)%>%
  st_intersection(layer_imp_simp%>% st_buffer(0)) %>%
  st_buffer(0)%>%
  ms_simplify()%>%
  st_as_sf()
glimpse(forest_imp)

plot_base + geom_sf(data=forest_imp, fill='darkorchid3', color=NA, alpha=.7)
ggsave('6_visualize/out/forest_20_imp_50.svg', width=10, height=10)

st_write(forest_imp, 'shapes/f2f2_FOREST_20_IMP_50.shp', driver = "ESRI Shapefile", delete_layer=TRUE)

forest_imp<-st_read('shapes/f2f2_FOREST_20_IMP_50.shp')



# plott plot plt ----------------------------------------------------------


## take a look
ggplot() +
  geom_sf(data=state_imp, fill='blue', color=NA) +
  scale_fill_scico(palette = 'lajolla', direction = 1) +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  theme_void()

ggplot() +
  geom_sf(data=state_infor, fill='orchid3', color=NA) +
  scale_fill_scico(palette = 'lajolla', direction = 1) +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  theme_void()

ggplot() +
  geom_sf(data=state_for%>%filter(FOR>20), fill='forestgreen', color=NA) +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  theme_void()

ggplot() +
  geom_sf(data=forest_imp, fill='forestgreen', color=NA) +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  theme_void()

glimpse(forest_imp)
## make some maps

##WFP	(APCW_R * IMP_R * PER_WFP )/ 10,000 Wildfire Risk to Important Surface Drinking Water Watersheds 
ggplot() +
  geom_sf(data=fire%>%filter(IMP_R > 10) , aes(fill=IMP_r), color=NA) +
  scale_fill_scico(palette = 'lajolla', direction = 1) +
  geom_sf(data=states, fill='NA', color = 'grey93', size=.2) +
  theme_void()

ggsave('maps/WFP.png', width=11, height=9)


# MODIS -------------------------------------------------------------------

list.files('shapes/MODIS_C6_USA_contiguous_and_Hawaii_7d')
modis <- st_read('shapes/MODIS_C6_USA_contiguous_and_Hawaii_7d')
glimpse(modis)


# land cover --------------------------------------------------------------

list.files('shapes/NLCD_2016_Land_Cover_L48_20190424/NLCD2016_spatial_metadata')
library(raster);library(sp);library(rgdal)

meta <- st_read('shapes/NLCD_2016_Land_Cover_L48_20190424/NLCD2016_spatial_metadata/NLCD2016_spatial_metadata_20190205.shp')
glimpse(meta)
crs_nlcd<-st_crs(meta)

nlcd <- raster('shapes/NLCD_2016_Land_Cover_L48_20190424/NLCD_2016_Land_Cover_L48_20190424.img')
glimpse(nlcd)
extent(nlcd)
plot(nlcd)

## looka t data attributes
nlcd@data@attributes
unique(nlcd@data@attributes[[1]]$NLCD.Land.Cover.Class)
class_forest <- c('Deciduous Forest','Mixed Forest','Evergreen Forest')

ggplot()+
  geom_raster(data=nlcd)
crs(nlcd)


extent(states_west)

## crop to west
nlcd_crop <- crop(nlcd, extent(-2493045, 300000, 400285, 3200000))
plot(nlcd_crop)
summary(nlcd_crop)

nlcd_crop[1,1:17]
nlcd_data<-nlcd_crop@data@attributes[[1]]

nlcd_st_crop <- states_west %>%st_transform(crs(nlcd_crop))%>%st_crop(nlcd_crop)
plot(nlcd_st_crop)

# reclassification matrix
reclass_df <- c(2, 31, NA,
                32, 50, 1,
                51, 99, NA)

# reshape 
reclass_m <- matrix(reclass_df, ncol=3, byrow=TRUE)
reclass_m

nlcd_reclass <- reclassify(nlcd_crop, reclass_m)
plot(nlcd_reclass)

writeRaster(nlcd_reclass, 'rasters/nlcd_reclass.grd', overwrite=TRUE)

nlcd_reclass<-raster('rasters/nlcd_reclass.grd')

bbox_west_aea<-usa%>%st_transform(crs(nlcd_reclass))%>%st_bbox()
extent(bbox_west_aea)


## crop and intersect with usa to reduce raster size
usa_nlcd <- as(usa%>%st_transform(crs(nlcd_reclass)), 'Spatial')
plot(usa_nlcd)

nlcd<-crop(nlcd_reclass, extent(c(xmin=-2356114, xmax=-504612.5, ymin = 991812.8, ymax = 3172567.9)))
nlcd_reclass <- reclassify(nlcd, reclass_m)

png('nlcd_forest.png', width=1000, height=1000)
plot(nlcd_reclass)
dev.off()

writeRaster(nlcd_reclass, 'rasters/nlcd_reclass.grd', overwrite=TRUE)

nlcd_mask <- mask(nlcd_reclass, mask = usa_nlcd)
plot(nlcd_mask)

nlcd_crop <- crop(nlcd_mask, y = extent(usa_nlcd))

## REPROJECT??
nlcd <- projectRaster(nlcd, crs = crs_albers)
writeRaster(nlcd, 'rasters/nlcd_reproj.grd', overwrite=TRUE)

## pltot o save rasters
nlcd_df <- as.data.frame(nlcd_mask, xy=TRUE)
glimpse(nlcd_reclass)

ggplot(nlcd_reclass)+geom_tile(aes(fill=values))


# find centroid of 1 cells
colMeans(xyFromCell(nlcd_reclass, which(nlcd_reclass[]==1)))


# fire fire fire ----------------------------------------------------------


## Fires as of 9/25/2020
# “Current wildfire perimeters” has a layer for current fires, and also a layer for 2020 fires that have been put out. 
fire_archive <- st_read('shapes/Archived_Wildfire_Perimeters-shp') %>%
  filter(FeatureCat == 'Wildfire Daily Fire Perimeter', IsVisible == 'Yes', FeatureAcc == 'Public', FeatureSta == 'Approved') %>%
  mutate(Incident=str_trim(tolower(IncidentNa)), YEAR = as.numeric(word(CreateDate, 1, 1, sep='-')))%>%
  st_transform(crs_albers) %>%
  st_buffer(0) %>% 
  st_crop(bbox_west_albers)# %>%
length(unique(fire_archive$Incident))
fire_archive%>%filter(is.na(GISAcres))
str(fire_archive)

fire_2019 <- fire_archive %>%
  filter(YEAR == 2019) %>%
  group_by(YEAR, Incident) %>%
  summarize();beep()

#dont work
fire_2020 <- fire_archive %>%
  filter(YEAR == 2020) %>%
  group_by(YEAR, Incident) %>%
  summarize();beep()
glimpse(fire_2020)

fire_names<-unique(fire_archive$Incident)
fire_names[33]#pauses on 33

for (i in 769){

  fire_archive%>%
    filter(YEAR == 2020, Incident == fire_names[i])%>%
    group_by(YEAR, Incident)%>%
    summarize()%>%
    st_write(paste0('tmp/fire_2020_', i, '.shp'), driver='ESRI Shapefile', delete_layer=TRUE);beep()
}
##SOTP HERE - froze on 769
fire_archive_inci<-do.call(rbind, lapply(1:length(fire_names), function(x)st_read(paste0('tmp/fire_2020_', x, '.shp'))))
str(fire_archive_inci)
plot_base+
  geom_sf(data=fire_archive_inci, fill='blue')

fire_archive_2020 <- fire_archive_inci %>%group_by(YEAR)%>%summarize()
st_write(fire_2019, 'shapes/fire_2019_archive.shp', driver = 'ESRI Shapefile', delete_layer=TRUE)
st_write(fire_archive_inci, 'shapes/fire_2020_archive.shp', driver = 'ESRI Shapefile', delete_layer=TRUE)

fire_archive_inci <- st_read('shapes/fire_2020_archive.shp')%>%group_by(YEAR)%>%summarize()
glimpse(fire_archive_inci)

plot_base + geom_sf(data=fire_archive_inci, fill='red', color=NA)


fire_2019_2020 <- rbind(fire_2019,fire_archive_inci)
str(fire_2019)


## aggregate by year
fire_archive_year <- fire_2019_2020%>%
  
  group_by(YEAR)%>%
  summarize();beep()
glimpse(fire_archive_year)
unique(fire_archive$FeatureCat)

# currently active fires
fire_now <- st_read('shapes/Wildfire_Perimeters-shp') %>%
  filter(FeatureCat == 'Wildfire Daily Fire Perimeter', IsVisible == 'Yes', FeatureAcc == 'Public', FeatureSta == 'Approved')%>%
  mutate(Incident=str_trim(tolower(IncidentNa)), YEAR = as.numeric(word(CreateDate, 1, 1, sep='-'))) %>%
  st_transform(crs_albers) %>%
  st_buffer(0) %>% 
  st_crop(bbox_west_albers)%>%
  group_by(YEAR, Incident)%>%
  summarize()
glimpse(fire_now)
unique(fire_now$CreateDate)

st_write(fire_now, 'shapes/fire_2020_now.shp', driver = 'ESRI Shapefile', delete_layer=TRUE)

## spatially combine 
fire_2020 <- rbind(fire_archive, fire_now) %>%
  st_buffer(0) %>%
  group_by(YEAR, Incident) %>%
  summarize()

fire_2020<-fire_now%>%
  group_by(Incident)%>%
  summarize()
glimpse(fire_2020)
as.numeric(set_units(sum(st_area(fire_2020)), mi^2)) ## 2020 so far
## fire timeseries

# reproject and crop
## filter out dates before 1984 because reporting was not standardized/reliable
### include only fires that were over 1000 acres?
fire_all <- st_read('shapes/Interagency_Fire_Perimeter_History_All_Years_Read_Only-shp') %>% 
  filter(FIRE_YEAR >= 1984 & FIRE_YEAR <=2020) %>% 
 st_transform(crs_albers) %>%
 st_buffer(0) %>% 
 st_crop(bbox_west_albers) 
 str(fire_all)

st_write(fire_all, 'shapes/fire_all_crop.shp', driver = 'ESRI Shapefile', delete_layer=TRUE)
##GEO_ID - Primary key for linking geospatial objects with other database systems

fire_all <- st_read('shapes/fire_all_crop.shp')
glimpse(fire_all)

fire_df%>%
  group_by(FIRE_YEAR)%>%
  summarize(FIRE_INCI = num(INCIDENT), num(FID), num(OBJECTID), num(GEO_ID), FIRE_UNQ = num(UNQE_FIRE_), AREA_ACRES = sum(GIS_ACRES)/1000000)%>%View

ggplot() +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  geom_sf(data=fire_now, fill="orangered", color=NA) +
  geom_sf(data=fire_all, fill="orange", color=NA) +
  theme_void() 


ggsave('maps/fire_current.png', width=10, height=10)


ggplot(states_west) +

  geom_sf(data=fire_all%>%filter(INCIDENT == "Abney", FEATURE_CA == "Final Wildfire Perimeter"), aes(fill=FEATURE_CA), color=NA, alpha=.8) +

  theme_void() +
  theme(legend.position = 'none')


ggsave('maps/fire_all.png', width=10, height=10)


# questions ---------------------------------------------------------------

## what is the area of important watersheds burned over time?
## are they the same areas of new area? unique area over time?
## what is the total area burned of important watersheds? what percent that are forest have been burned?
## area per state overtime


fire_all <- st_read('shapes/fire_all_crop.shp')
str(fire_all)

fire_area<-fire_all%>%st_drop_geometry()%>%
  group_by(FIRE_YEAR, INCIDENT)%>%
  summarize(AREA_ACRES=sum(GIS_ACRES, na.rm=TRUE))
fire_area%>%
  filter(AREA_ACRES >= 1000)%>%
  group_by(FIRE_YEAR)%>%
  summarize(n = length(unique(INCIDENT)), mean_area = mean(AREA_ACRES, na.rm=TRUE))%>%View
            
fcas<-fire_all %>%
  st_drop_geometry() %>%
  filter(FIRE_YEAR >= 1984 & FIRE_YEAR <= 2020 & GIS_ACRES >= 1000) %>%
  group_by(FIRE_YEAR, INCIDENT, UNQE_FIRE_) %>%
  summarize(n = num(LOCAL_NUM), n_geo=num(GEO_ID), n_fca=num(FEATURE_CA), AREA_SHAPE = sum(SHAPE_Area, na.rm=TRUE), AREA_GIS = sum(GIS_ACRES)) %>%
  filter(n_fca >1)

fire_all %>%
  st_drop_geometry() %>%
  filter(INCIDENT %in% fcas$INCIDENT)%>%View

## what is the frequency, area,
## FEATURE_CA == "Wildfire"??
## area and frequency of fires over time
fire_all_time <- fire_all %>%
  group_by(FIRE_YEAR, INCIDENT) %>%
  summarize(n = num(LOCAL_NUM), AREA_SHAPE = sum(SHAPE_Area, na.rm=TRUE), AREA_GIS = sum(GIS_ACRES),
            AREA_KM2 = set_units(st_area(.), km^2), AREA_MI2 = set_units(st_area(.), mi^2)) #6:23 pm
glimpse(fire_all_time)

st_write(fire_all_time, 'shapes/fire_all_time.shp', driver = 'ESRI Shapefile', append=FALSE)

## agggregate data by year and incident
fire_years <- function(year){
  fire_yr <- fire_all %>%
    filter(FIRE_YEAR == year) %>%
    mutate(Incident = str_trim(tolower(INCIDENT)))%>%
    group_by(FIRE_YEAR, Incident) %>%
    summarize();beep()
    #mutate(AREA_KM2 = set_units(st_area(.), km^2), AREA_MI2 = set_units(st_area(.), mi^2))

  st_write(fire_yr, paste0('shapes/fire_year/fire_', year, '.shp'), driver = 'ESRI Shapefile', delete_layer=TRUE)
}

lapply(1984:2019, function(x)fire_years(x))

fire_yr <- fire_all %>%
  filter(FIRE_YEAR == 2019)#%>%
  mutate(Incident = str_trim(tolower(INCIDENT)))%>%
  group_by(FIRE_YEAR, Incident) %>%
  summarize()
glimpse(fire_yr)
plot(fire_yr)

## look at one year
year_2010 <- st_read('shapes/fire_year/fire_2019.shp')
str(year_2010)
plot(year_2010)
plot_base+
  geom_sf(data=year_2010, fill="orange", color=NA) +
  theme_void() +
  theme(legend.position = 'none')

## read all years in and combine by year
fire_all_time <- do.call(rbind, lapply(1984:2019, function(x)st_read(paste0('shapes/fire_year/fire_', x, '.shp'))))
glimpse(fire_all_time)

ggplot() +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  geom_sf(data=fire_all_time, aes(fill=FIRE_YEAR), color=NA) +
  theme_void() +
  scale_fill_scico_d(palette='lajolla')
  theme(legend.position = 'none')

ggsave('maps/fire_all_year.png', width=10, height=10)


str(fire_all_time)

##  combine by year
fire_total <- fire_all_time %>% 
  group_by(FIRE_YEAR) %>%
  summarize(n_fires = num(Incident))%>%
  mutate(AREA_KM2 = set_units(st_area(.), km^2), AREA_MI2 = set_units(st_area(.), mi^2))
str(fire_total)

st_write(fire_total, 'shapes/fire_by_year.shp', driver = 'ESRI Shapefile', delete_layer=TRUE)

fire_total<- st_read('shapes/fire_by_year.shp')%>%transform(YEAR = as.numeric(FIRE_YEAR))
str(fire_total)
unique(fire_total$FIRE_YEAR)


#2019 fire data
real_2019 <- st_read('shapes/Historic_GeoMAC_Perimeters_2019-shp/US_HIST_FIRE_PERIM_2019_dd83.shp')%>%
  mutate(Incident = str_trim(tolower(incidentna)), YEAR = fireyear)%>%
  st_transform(crs_albers)%>%
  st_buffer(0)%>%
  st_crop(bbox_west_albers)%>%
  st_buffer(0)
glimpse(real_2019)

length(unique(real_2019$Incident))

real <- real_2019%>%
  group_by(Incident, YEAR)%>%
  summarize()
glimpse(real)
fire_2019 <- real%>%st_as_sf()%>%group_by(YEAR)%>%summarize()%>%ms_simplify()

plot_base+geom_sf(data=fire_2019, fill='red', color=NA)
ggsave('6_visualize/out/fire_2019.svg', width=10, height=10)

# timeseries --------------------------------------------------------------

## how much 

### plotting timeseries

## intersect with states
fire_states <- fire_total %>%
  st_transform(crs_laea)%>%
  st_buffer(0)%>%
  st_intersection(states_west)%>%
  st_buffer(0)%>%
  mutate(AREA_KM2 = set_units(st_area(.), km^2), AREA_MI2 = set_units(st_area(.), mi^2))
str(fire_states)


fire_states_agg<-fire_states%>%group_by(YEAR, ID, NAME)%>%summarize(ACRES=sum(AREA_MILL_AC))
fire_states_agg%>%mutate(AREA_KM2 = set_units(st_area(.), km^2), AREA_MI2 = set_units(st_area(.), mi^2))
glimpse(fire_states_agg)

str(fire_total)
fire_total<-fire_total%>%transform(YEAR=as.numeric(FIRE_YEAR), AREA_MI2=as.numeric(AREA_MI2))

# timeseries
ggplot(data=fire_total, aes(YEAR, AREA_MI2))+
  geom_point()+
  geom_point(aes(x=2020, y=as.numeric(set_units(sum(st_area(fire_2020)), mi^2))), shape=21, stroke=1.5, size=3, color='red')+
  geom_line(stat='identity')+
  geom_smooth(method='glm', se=FALSE, color="orangered")+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 90, vjust=0.5))+
  labs(x='', y='Sq mi burned')+
  scale_x_continuous(breaks=seq(1980, 2020, by=5))


## by states
str(fire_states)
ggplot(data=fire_states%>%st_drop_geometry()%>%filter(!(ID %in% c('NE','SD','KS','ND','TX','OK'))), aes(as.numeric(FIRE_YEAR), as.numeric(AREA_MI2), group=NAME))+
  geom_point(aes(color=NAME))+
  geom_line(aes(color=NAME))+
  
  theme_classic()+
  theme(axis.text.x = element_text(angle = 90, vjust=0.5))+
  labs(x='', y='Millions of acres burned')+
  scale_x_continuous(breaks=seq(1980, 2020, by=5))




# area
ggplot() +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  geom_sf(data=state_imp, fill='paleturquoise', color=NA, alpha=.7) +
  geom_sf(data=fire_total, color=NA, fill="orange", alpha=.7) +
  geom_sf(data=fire_2020, color=NA, fill="orangered3", alpha=.7) +
  theme_void() 


ggplot() +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  geom_sf(data=state_infor, fill='orchid3', color=NA) +
  geom_sf(data=fire_total, color=NA, fill="orange", alpha=.7) +
  geom_sf(data=fire_2020, color=NA, fill="orangered3", alpha=.7) +
  theme_void() 


ggplot() +
  geom_sf(data = states_west, fill=NA, color = 'grey93') +
  geom_sf(data=usa, color="black", fill=NA, stroke=.4) +
  geom_sf(data=state_imp, fill='grey70', color=NA) +
  geom_sf(data=fire_total, aes(fill=FIRE_YEAR), color='orangered') +
  theme_void() +
  scale_fill_scico_d(palette='bamako')

### fire by decade
fire_decade <- fire_total %>%
  st_drop_geometry() %>%
  transform(YEAR=as.numeric(FIRE_YEAR)) %>%
  mutate(decade = case_when(
    YEAR >= 2011 ~ '2011-2020',
    YEAR >= 2001 & YEAR < 2011 ~ '2001-2010',
    YEAR >= 1991 & YEAR < 2001 ~ '1991-2000',
    YEAR >= 1981 & YEAR < 1991 ~ '1981-1990',
  ))%>%
  group_by(decade)%>%
  summarize(n_fire = sum(n_fires), mi2=sum(AREA_MI2))

ggplot(fire_decade, aes(x=decade, mi2))+
  geom_bar(stat="identity")

##unique acres burned?
fire_total

### need to add 2020 data?
### frequency
# by state
### intersect with important watersheds
## add hillshade


# viz ideas ---------------------------------------------------------------

# ways to comapre areas - increase in fire size
## tile boxes

## over time
## line chart boo
## area chart?

## compare areas by type - venn diagram

## what is the total area of watershed IMP that has burned over time?
## what proportion of top 50 watersheds are forested?
## what % of forested areas are top 50% water supply?

## % forest cover at different thresholds

