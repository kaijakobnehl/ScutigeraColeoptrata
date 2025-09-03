## Masterarbeit 
##
##
## by Kai Nehl

library(terra)
library(sf)
library(CAST)
library(tmap)

setwd("Git/Data/predictor_data")


#current prediction

model_ffs <- get(load("ffsmodel.RData"))


r_selected <-stack("predictor_stack_current.grd")
NAvalue(r_selected) <- -9999   # Set NA
r_selected <- raster::subset(r_selected, 
                             c("clc_urban_areas", "distance_railway", "distance_waterway", "wc_bio9"))

vals <- as.data.frame(getValues(r_selected))

#prepare empty raster
suitability <- rep(NA, nrow(vals))

#set valid cases
valid <- complete.cases(vals)

# predict
probs <- predict(model_ffs, newdata = vals[valid, ], type = "prob")

#insert propabilities
suitability[valid] <- probs[, "1"] 


suit_raster <- setValues(raster(r_selected), suitability)


writeRaster(suit_raster, "prediction_rf_current.tif", overwrite = TRUE)
