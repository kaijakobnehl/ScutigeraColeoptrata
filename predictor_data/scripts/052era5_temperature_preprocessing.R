## Masterarbeit 
##
##
## by Kai Nehl

library(terra)


setwd("Git/Data/predictor_data")

# load study area (Shapefile)
ext <- vect("study_area.shp")


# load raster predictor
raster_data <- rast("era5_temperature.tif")

ext_proj <- project(ext, crs(raster_data))

# clip raster to extent (Clipping)

raster_masked <- mask(raster_data, ext_proj)  # omits values out of extent

#save results
writeRaster(raster_masked, "era5_temperature_ger.tif", overwrite=TRUE)
