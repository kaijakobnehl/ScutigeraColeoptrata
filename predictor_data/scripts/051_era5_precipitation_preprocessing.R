## Masterarbeit 
##
##
## by Kai Nehl

library(terra)


setwd("Git/Data/predictor_data")

# load study area (Shapefile)
ext <- vect("study_area.shp")


# load predictor raster
raster_data <- rast("era5_precipitation.tif")

ext_proj <- project(ext, crs(raster_data))

# clip raster to extent (Clipping)

raster_masked <- mask(raster_data, ext_proj)  # omits values outside of extent

# save results
writeRaster(raster_masked, "era5_precipitation_ger.tif", overwrite=TRUE)