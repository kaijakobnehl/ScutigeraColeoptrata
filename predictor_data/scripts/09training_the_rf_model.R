## Masterarbeit 
##
##
## by Kai Nehl

library(raster)
library(caret)
library(terra)
library(sf)
library(CAST)

setwd("Git/Data/predictor_data")

extr <- readRDS("train_data.rds") #train data have been converted to .rds


# define the predictor names

predictors <- c("LULC_trees", "LULC_water", "LULC_crops", 
                "clc_urban_areas", "distance_railway", "distance_waterway",
                "wc_bio1", "wc_bio9", "slope", "elevation")
predictors <- setdiff(predictors, "geom")



trainIDs <- createDataPartition(extr$status,p=1.0,list = FALSE)
trainDat <- extr[trainIDs,]
trainDat <- st_drop_geometry(trainDat)
trainDat$status <- as.factor(trainDat$status)
#make sure theres no NA
trainDat <- trainDat[complete.cases(trainDat[,predictors]),]



# training the model

trainDat$coordsID <- 1:nrow(trainDat)
trainids <- CreateSpacetimeFolds(trainDat,spacevar="coordsID",class="status",k=5)


model_ffs <- CAST::ffs(trainDat[,predictors],
                       trainDat$status,
                       method="rf",
                       metric = "Kappa",
                       ntree=500,
                       tuneGrid=data.frame("mtry"=2:10),  
                       trControl=trainControl(method="cv",index=trainids$index))

plot(model_ffs)
plot(model_ffs,plotType="selected")
varImp(model_ffs)

save(model_ffs,file="ffsmodel.RData")
#selected predictors: clc_urban_areas, distance_railway, distance_waterway, wc_bio9