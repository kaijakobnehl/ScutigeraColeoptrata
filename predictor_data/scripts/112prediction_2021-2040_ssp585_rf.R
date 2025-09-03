## Masterarbeit 
##
##
## by Kai Nehl


#prediction 2021-2040_ssp245


library(raster)
library(caret)
library(terra)
library(sf)
setwd("Git/Data/predictor_data")


r_selected <-stack("predictor_stack_2021-2040_ssp585.grd")
NAvalue(r_selected) <- -9999  

model <- get(load("ffsmodel.RData"))


vals <- as.data.frame(getValues(r_selected))


suitability <- rep(NA, nrow(vals))


valid <- complete.cases(vals)


probs <- predict(model_ffs, newdata = vals[valid, ], type = "prob")


suitability[valid] <- probs[, "1"]  


suit_raster <- setValues(raster(r_selected), suitability)


writeRaster(suit_raster, "prediction_rf_2021-2040_ssp585.tif", overwrite = TRUE)

