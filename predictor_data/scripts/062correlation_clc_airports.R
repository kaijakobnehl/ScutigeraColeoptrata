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
shapiro_test <- shapiro.test(train_data$clc_airports) 

print(shapiro_test) #no nd

shapiro_test <- shapiro.test(train_data$status)

print(shapiro_test) #no nd, use of kendall  (ties)

result <- cor.test(punktdaten$clc_airports, punktdaten$status, method = "kendall")  


print(result)


#no significant correlation found, p=0.997, z=-0.003