## Masterarbeit 
##
##
## by Kai Nehl

library(terra)


setwd("Git/Data/predictor_data")

# load study area (Shapefile)
ext <- vect("study_area.shp")


# load raster predictor
raster_data <- rast("dem.tif")

ext_proj <- project(ext, crs(raster_data))

# clip to extent

raster_masked <- mask(raster_data, ext_proj)  # omits values out of extent

# save results
writeRaster(raster_masked, "dem_ger.tif", overwrite=TRUE)