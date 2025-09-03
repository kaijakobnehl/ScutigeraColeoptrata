## Masterarbeit 
##
##
## by Kai Nehl


library(mgcv)   
library(MASS)   
library(car)    
library(terra)    
library(sf)
library(raster)

setwd("Git/Data/predictor_data")

#for 2021-2040
predictor_stack_2021_2040_ssp245 <- rast("predictor_stack_raster.tif")  
predictor_stack_2021_2040_ssp585 <- rast("predictor_stack_raster.tif")  

#wc_bio1 and wc_bio9 for both scenarios have been manually downloaded from: https://cds.climate.copernicus.eu/datasets/projections-cmip6?tab=download
bio1_2021_2040_ssp245 <- rast("bio1_2021-2040_ssp245.tif")
bio1_2021_2040_ssp585 <- rast("bio1_2021-2040_ssp585.tif")

bio9_2021_2040_ssp245 <- rast("bio9_2021-2040_ssp245.tif")
bio9_2021_2040_ssp585 <- rast("bio9_2021-2040_ssp585.tif")

clc_urban_areas_2030 <- rast("clc_urban_areas2030.tif")
clc_urban_areas_2050 <- rast("clc_urban_areas2050.tif")

bio1_2021_2040_ssp245<-project(bio1_2021_2040_ssp245, predictor_stack_2021_2040_ssp245)
bio1_2021_2040_ssp245<-resample(bio1_2021_2040_ssp245, predictor_stack_2021_2040_ssp245, method = "bilinear")
bio9_2021_2040_ssp245<-project(bio9_2021_2040_ssp245, predictor_stack_2021_2040_ssp245)
bio9_2021_2040_ssp245<-resample(bio9_2021_2040_ssp245, predictor_stack_2021_2040_ssp245, method = "bilinear")
clc_urban_areas_2030<- project(clc_urban_areas_2030, predictor_stack_2021_2040_ssp245)
clc_urban_areas_2030<-resample(bio1_2021_2040_ssp245, predictor_stack_2021_2040_ssp245, method = "near")

predictor_stack_2021_2040_ssp245 <- c(predictor_stack_2021_2040_ssp245, bio1_2021_2040_ssp245, bio9_2021_2040_ssp245, clc_urban_areas_2030)
predictor_stack_2021_2040_ssp245 <- predictor_stack_2021_2040_ssp245[[!names(predictor_stack_2021_2040_ssp245) %in% c("clc_reprojected", "bio_01", "bio_09")]]
names(predictor_stack_2021_2040_ssp245) <- c("LULC_trees", "LULC_water", "LULC_crops", "distance_railway", "distance_waterway", "slope", "elevation", "wc_bio1", "wc_bio9", "clc_urban_areas")
writeRaster(predictor_stack_2021_2040_ssp245, "predictor_stack_2021-2040_ssp245.tif", overwrite=TRUE)

bio1_2021_2040_ssp585<-project(bio1_2021_2040_ssp585, predictor_stack_2021_2040_ssp585)
bio9_2021_2040_ssp585<-project(bio9_2021_2040_ssp585, predictor_stack_2021_2040_ssp585)
clc_urban_areas_2030<- project(clc_urban_areas_2030, predictor_stack_2021_2040_ssp585)

predictor_stack_2021_2040_ssp585 <- c(predictor_stack_2021_2040_ssp585, bio1_2021_2040_ssp585, bio9_2021_2040_ssp585, clc_urban_areas_2030)
names(predictor_stack_2021_2040_ssp585) <- c("trees", "water", "crops", "clc_urban_areas_alt", "dist_railways", 
                                             "dist_waterways", "bio_01_alt", "bio_09_alt", "era5_temperature", 
                                             "slope", "elevation", "bio_01", "bio_09", 
                                             "clc_urban_areas")

writeRaster(predictor_stack_2021_2040_ssp585, "predictor_stack_2021-2040_ssp585.tif", overwrite=TRUE)



#for 2041-2060
predictor_stack_2041_2060_ssp245 <- rast("predictor_stack_raster.tif")  
predictor_stack_2041_2060_ssp585 <- rast("predictor_stack_raster.tif")  

bio1_2041_2060_ssp245 <- rast("bio1_2041-2060_ssp245.tif")
bio1_2041_2060_ssp585 <- rast("bio1_2041-2060_ssp585.tif")

bio9_2041_2060_ssp245 <- rast("bio9_2041-2060_ssp245.tif")
bio9_2041_2060_ssp585 <- rast("bio9_2041-2060_ssp585.tif")

bio1_2041_2060_ssp245<-project(bio1_2041_2060_ssp245, predictor_stack_2041_2060_ssp245)
bio9_2041_2060_ssp245<-project(bio9_2041_2060_ssp245, predictor_stack_2041_2060_ssp245)
clc_urban_areas_2050<- project(clc_urban_areas_2050, predictor_stack_2041_2060_ssp245)

predictor_stack_2041_2060_ssp245 <- c(predictor_stack_2041_2060_ssp245, bio1_2041_2060_ssp245, bio9_2041_2060_ssp245, clc_urban_areas_2050)
names(predictor_stack_2041_2060_ssp245) <- c("trees", "water", "crops", "clc_urban_areas_alt", "dist_railways", 
                                             "dist_waterways", "bio_01_alt", "bio_09_alt", 
                                             "slope", "elevation", "bio_01", "bio_09", 
                                             "clc_urban_areas")

writeRaster(predictor_stack_2041_2060_ssp245, "predictor_stack_2041-2060_ssp245.tif", overwrite=TRUE)

bio1_2041_2060_ssp585<-project(bio1_2041_2060_ssp585, predictor_stack_2041_2060_ssp585)
bio9_2041_2060_ssp585<-project(bio9_2041_2060_ssp585, predictor_stack_2041_2060_ssp585)
clc_urban_areas_2050<- project(clc_urban_areas_2050, predictor_stack_2041_2060_ssp585)

predictor_stack_2041_2060_ssp585 <- c(predictor_stack_2041_2060_ssp585, bio1_2041_2060_ssp585, bio9_2041_2060_ssp585, clc_urban_areas_2050)
names(predictor_stack_2041_2060_ssp585) <- c("trees", "water", "crops", "clc_urban_areas_alt", "dist_railways", 
                                             "dist_waterways", "bio_01_alt", "bio_09_alt", "era5_temperature", 
                                             "slope", "elevation", "bio_01", "bio_09", 
                                             "clc_urban_areas")
writeRaster(predictor_stack_2041_2060_ssp585, "predictor_stack_2041-2060_ssp585.tif", overwrite=TRUE)
