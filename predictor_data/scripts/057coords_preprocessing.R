## Masterarbeit 
##
##
## by Kai Nehl

library(terra)


setwd("C:/Users/Kai Nehl/Desktop/Spinnenläufer/praediktoren_hanna/europe")
# coords where isolated from the point_data via QGIS (Bialowieza, 3.22)
# load study area (Shapefile)
ext <- vect("study_area.shp")

# load predictor raster
raster_data <- rast("coords.tif")

ext_proj <- project(ext, crs(raster_data))

# clip raster to extent

raster_masked <- mask(raster_data, ext_proj)  # omits values out of extent

# save results
writeRaster(raster_masked, "coords_ger.tif", overwrite=TRUE)