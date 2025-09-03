## Masterarbeit 
##
##
## by Kai Nehl

# Lade benötigte Pakete
library(terra)    
library(sf)

setwd("Git/Data/predictor_data")

# load point_data

points <- st_read("point_data.shp")

# load raster data

slope<-rast("slope_ger.tif")
LULC<-rast("LULC_ger.tif")
dem<-rast("dem_ger.tif")
coords<-rast("coords_ger.tif")
distances<-rast("distances_ger.tif")
wc_ger<-rast("wc_ger.tif")
era5_precipitation<-rast("era5_precipitation_ger.tif")
era5_precipitation<- app(era5_precipitation, mean)  # mean era_5 
era5_temperature<-rast("era5_temperature_ger.tif")
era5_temperature<- app(era5_temperature, mean)      # mean era_5 
bevoelkerungsdichte<-rast("population_density_raster.tif") #calculated from NUTS-3 in QGIS (Bialowieza, 3.22)
CLC<-rast("clc_reprojected.tif")
CLC<-resample(CLC, LULC, method = "near") #near because we need integer
clc_continuous_urban_fabric <- rast("clc_continuous_urban_fabric_crop.tif")
clc_discontinuous_urban_fabric <- rast("clc_discontinuous_urban_fabric_crop.tif")
clc_industrial_or_commercial_units <- rast("clc_industrial_or_commercial_units_crop.tif")
clc_urban_areas <- clc_continuous_urban_fabric | clc_discontinuous_urban_fabric | clc_industrial_or_commercial_units # combined to urban_areas
clc_road_and_rail_networks_and_associated_land <- rast("clc_road_and_rail_networks_and_associated_land_crop.tif")
clc_port_areas <- rast("clc_port_areas_crop.tif")
clc_airports <- rast("clc_airports_crop.tif")
clc_traffic_infrastructure<- clc_road_and_rail_networks_and_associated_land | clc_port_areas | clc_airports # combined to traffic_infrastructure
clc_vineyards <- rast("clc_vineyards_crop.tif")
clc_bare_rocks <- rast("clc_bare rocks_crop.tif")
aspect <- rast("aspect_ger.tif")




# extract values at points
value1 <- extract(LULC$impervious, vect(points))
value2 <- extract(LULC$trees, vect(points))
value3 <- extract(LULC$grass, vect(points))
value4 <- extract(LULC$water, vect(points))
value5 <- extract(LULC$crops, vect(points))

value6 <- extract(dem$elevation, vect(points))
value7 <- extract(coords, vect(points))
value8 <- extract(distances$dist_motorway, vect(points))
value9 <- extract(distances$dist_railways, vect(points))
value10 <- extract(distances$dist_waterways, vect(points))

value11<- extract(wc_ger$bio_01, vect(points))
value12<- extract(wc_ger$bio_02, vect(points))
value13<- extract(wc_ger$bio_03, vect(points))
value14<- extract(wc_ger$bio_04, vect(points))
value15<- extract(wc_ger$bio_05, vect(points))
value16<- extract(wc_ger$bio_06, vect(points))
value17<- extract(wc_ger$bio_07, vect(points))
value18<- extract(wc_ger$bio_08, vect(points))
value19<- extract(wc_ger$bio_09, vect(points))

value20<- extract(era5_precipitation, vect(points))
value21<- extract(era5_temperature, vect(points))
value22<- extract(bevoelkerungsdichte$bevoelkerungsdichte_raster, vect(points))
value23<- extract(slope$slope, vect(points))
value24<- extract(CLC$clc_reprojected, vect(points))

value25<- extract(clc_continuous_urban_fabric, vect(points))
value26<- extract(clc_discontinuous_urban_fabric, vect(points))
value27<- extract(clc_industrial_or_commercial_units, vect(points))
value28<- extract(clc_urban_areas, vect(points))
value29<- extract(clc_road_and_rail_networks_and_associated_land, vect(points))
value30<- extract(clc_port_areas, vect(points))
value31<- extract(clc_airports, vect(points))
value32<- extract(clc_traffic_infrastructure, vect(points))
value33<- extract(clc_vineyards, vect(points))
value34<- extract(clc_bare_rocks, vect(points))
value35 <-extract(aspect, vect(points))



# add extracted values to the rasterstack
points$LULC_impervious <- value1[,2]  # column 2 holds the values 
points$LULC_trees <- value2[,2] 
points$LULC_grass <- value3[,2] 
points$LULC_water <- value4[,2] 
points$LULC_crops <- value5[,2] 
points$elevation <- value6[,2] 
points$coords <- value7[,2] 
points$distance_motorway <- value8[,2] 
points$distance_railway <- value9[,2] 
points$distance_waterway <- value10[,2] 
points$wc_bio1 <- value11[,2] 
points$wc_bio2 <- value12[,2] 
points$wc_bio3 <- value13[,2] 
points$wc_bio4 <- value14[,2] 
points$wc_bio5 <- value15[,2] 
points$wc_bio6 <- value16[,2] 
points$wc_bio7 <- value17[,2] 
points$wc_bio8 <- value18[,2] 
points$wc_bio9 <- value19[,2] 
points$era5_precipitation <- value20[,2] 
points$era5_temperature <- value21[,2] 
points$bevoelkerungsdichte <- value22[,2] 
points$slope <- value23[,2] 
points$CLC <-value24[,2]
points$clc_continuous_urban_fabric <-value25[,2]
points$clc_discontinuous_urban_fabric <-value26[,2]
points$clc_industrial_or_commercial_units <-value27[,2]
points$clc_urban_ares <-value28[,2]
points$clc_road_and_rail_networks_and_associated_land <-value29[,2]
points$clc_port_areas <-value30[,2]
points$clc_airports <-value31[,2]
points$clc_traffic_infrastructure <-value32[,2]
points$clc_vineyards <-value33[,2]
points$clc_bare_rocks <-value34[,2]
points$aspect <- value35[,2]

#FALSE TRUE boolean data into numeric
points$clc_urban_areas <- as.numeric(points$clc_urban_areas)
points$clc_traffic_infrastructure <- as.numeric(points$clc_traffic_infrastructure)


# save as geopackage
st_write(points, "train_data.gpkg", append = FALSE)
