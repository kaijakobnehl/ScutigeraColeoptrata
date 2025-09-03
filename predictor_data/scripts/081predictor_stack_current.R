## Masterarbeit 
##
##
## by Kai Nehl




library(car)    
library(terra)    

setwd("Git/Data/predictor_data")


#selected variables: LULC_trees, LULC_water, LULC_crops, distance_railway , distance_waterway, wc_bio1, wc_bio9, slope,
#                       clc_urban_areas, elevation

# load data 

slope<-rast("slope_ger.tif")

LULC<-rast("LULC_ger.tif")
LULC_trees <- LULC$trees

#set reference
ref_crs <- crs(LULC_trees)
ref_raster <- LULC_trees

LULC_water <- LULC$water
LULC_crops <- LULC$crops

elevation<-rast("dem_ger.tif")

distances<-rast("distances_ger.tif")
distance_railway<- distances$dist_railways
distance_waterway <- distances$dist_waterways

wc_ger<-rast("wc_ger.tif")
wc_bio1 <- wc_ger$bio_01
wc_bio9 <- wc_ger$bio_09

ref_crs <- crs(LULC_trees)


clc_urban_areas <- rast("clc_urban_areas.tif")


rasters <- list(LULC_trees, LULC_water, LULC_crops, 
                distance_railway, distance_waterway,
                wc_bio1, wc_bio9, era5_temperature, 
                slope, clc_urban_areas, elevation)





# check metadata
lapply(rasters, function(r) list(res = res(r), crs = crs(r), ext = ext(r)))

#all apart from LULC have to get adjusted

clc_urban_areas <- resample(clc_urban_areas, ref_raster, method = "near")
distance_railway<- resample(distance_railway, ref_raster, method = "bilinear")
distance_waterway<- resample(distance_waterway, ref_raster, method = "bilinear")
wc_bio1<- resample(wc_bio1, ref_raster, method = "bilinear")
wc_bio9<- resample(wc_bio9, ref_raster, method = "bilinear")
era5_temperature<- resample(era5_temperature, ref_raster, method = "bilinear")
slope<- resample(slope, ref_raster, method = "bilinear")
elevation<- resample(elevation, ref_raster, method = "bilinear")



predictorstack <- c(LULC_trees, LULC_water, LULC_crops, clc_urban_areas, distance_railway, distance_waterway, wc_bio1,wc_bio9, era5_temperature, slope, elevation)
writeRaster(predictorstack, "predictor_stack_current.tif", overwrite=TRUE)
