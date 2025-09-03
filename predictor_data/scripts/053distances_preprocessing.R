## Masterarbeit 
##
##
## by Kai Nehl
## special thanks to Hanna Meyer for creating and contributing distances via the "geofabrik" osm data
library(terra)

setwd("Git/Data/predictor_data")

# load study area (Shapefile)
ext <- vect("study_area.shp")


# load predictor raster
raster_data <- rast("distances.tif")

ext_proj <- project(ext, crs(raster_data))

# clip raster to extent

raster_masked <- mask(raster_data, ext_proj)  # omits values out of extent

# save results
writeRaster(raster_masked, "distances_ger.tif", overwrite=TRUE)