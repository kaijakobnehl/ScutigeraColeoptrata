## Masterarbeit 
##
##
## by Kai Nehl


library(geodata)
library(sf)
library(terra)

setwd("Git/Data/predictor_data")

ext <- st_read("study_area.shp")


# get topographic parameters from "geodata" Package

dem <- elevation_global(res=0.5, mask=TRUE)
names(dem)<- "elevation"
dem <- crop(dem,ext)
writeRaster(dem,"dem.tif",overwrite=T)


