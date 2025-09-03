## Masterarbeit 
##
##
## by Kai Nehl


library(geodata)
library(sf)
library(terra)

setwd("Git/Data/predictor_data")

ext <- st_read("study_area.shp")

#ERA5 is downloaded from https://cds.climate.copernicus.eu/datasets/reanalysis-era5-single-levels-monthly-means?tab=overview

era5 <- rast("Era5/a593c676f2adc1afcfa4d41ac8a3071b.grib")
era5_crop <- crop(era5,ext)
precipitation <- era5_crop[[grepl("precip",names(era5_crop))]]*1000*30 #conversion to mm
temperature <- era5_crop[[grepl("temperature",names(era5_crop))]]- 273.15 #convert Kelvin to C
names(precipitation) <- paste0("ERA5_prec_",format_ISO8601(ceiling_date(time(precipitation), "month"), precision = "ym"))
names(temperature) <-  paste0("ERA5_temp_",format_ISO8601(ceiling_date(time(temperature), "month"), precision = "ym"))
writeRaster(temperature,"era5_temperature.tif",overwrite=T)
writeRaster(precipitation,"era5_precipitation.tif",overwrite=T)



