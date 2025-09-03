## Masterarbeit 
##
##
## by Kai Nehl

library(terra)

setwd("Git/Data/predictor_data")

# load dem
dem <- rast("dem_ger.tif")

# calculate slope
slope <- terrain(dem, v = "slope", unit = "degrees")

# save as .tif
writeRaster(slope, "slope_ger.tif", overwrite=TRUE)

# calculate aspect
aspect <- terrain(dem, v = "aspect", unit = "degrees")

# save as .tif
writeRaster(aspect, "aspect_ger.tif", overwrite=TRUE)
