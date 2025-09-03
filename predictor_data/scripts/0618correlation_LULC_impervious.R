## Masterarbeit 
##
##
## by Kai Nehl

library(raster)   
library(ggplot2)   



setwd("Git/Data/predictor_data")

train_data<-st_read("train_data.gpkg")

# calculating kendall correlation

# test for normal distribution
shapiro_test <- shapiro.test(train_data$LULC_impervious) 

print(shapiro_test) #no nd

shapiro_test <- shapiro.test(train_data$status)

print(shapiro_test) #no nd, use kendall (ties)

result <- cor.test(train_data$LULC_impervious, train_data$status, method = "kendall")  


print(result)



#strong correlation found, p<0.001, z=23.788