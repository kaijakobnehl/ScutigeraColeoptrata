## Masterarbeit 
##
##
## by Kai Nehl


library(geodata)
library(sf)
library(terra)

setwd("Git/Data/predictor_data")

ext <- st_read("study_area.shp")


# Land Cover 2019 was downloaded, as raster with a spatial resolution of 100 m
# https://land.copernicus.eu/en/products/global-dynamic-land-cover/copernicus-global-land-service-land-cover-100m-collection-3-epoch-2019-globe

LULC <- rast(c("PROBAV_LC100_global_v3.0.1_2019-nrt_BuiltUp-CoverFraction-layer_EPSG-4326.tif",
               "PROBAV_LC100_global_v3.0.1_2019-nrt_Tree-CoverFraction-layer_EPSG-4326.tif",
               "PROBAV_LC100_global_v3.0.1_2019-nrt_Grass-CoverFraction-layer_EPSG-4326.tif",
               "PROBAV_LC100_global_v3.0.1_2019-nrt_PermanentWater-CoverFraction-layer_EPSG-4326.tif",
               "PROBAV_LC100_global_v3.0.1_2019-nrt_Crops-CoverFraction-layer_EPSG-4326.tif"))

LULC <- crop(LULC,ext_sf)
names(LULC)<-c("impervious","trees","grass","water","crops")

writeRaster(LULC,"LULC.tif",overwrite=T)
