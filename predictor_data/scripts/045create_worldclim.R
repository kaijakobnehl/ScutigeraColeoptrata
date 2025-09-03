## Masterarbeit 
##
##
## by Kai Nehl


library(geodata)
library(sf)
library(terra)

setwd("Git/Data/predictor_data")

ext <- st_read("study_area.shp")


# get worldclim from "geodata"
wc <- worldclim_global(var="bio",res=2.5)
wc <- crop(wc,ext)

names(wc) <- substr(names(wc),nchar(names(wc))-5,nchar(names(wc)))
names(wc)<- gsub("_bio_","bio_0",names(wc))
writeRaster(wc,"wc.tif",overwrite=T)



