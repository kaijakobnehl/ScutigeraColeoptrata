## Masterarbeit 
##
##
## by Kai Nehl

library(sf)        
library(ggplot2)   


setwd("Git/Data/predictor_data")

train_data<-st_read("train_data.gpkg")

# load predictor data
raster_layer <- raster("aspect_ger.tif")



# extract values
train_data$aspect <- raster::extract(raster_layer, train_data)


# kendall correlation

# check for normal distribution
shapiro_test <- shapiro.test(train_data$aspect) 

print(shapiro_test) #no nd

shapiro_test <- shapiro.test(train_data$status)

print(shapiro_test) #no nd, use kendall

result <- cor.test(train_data$aspect, train_data$status, method = "kendall")   


print(result)



#no signicant correlation found, p=0.2228, z=1.2191