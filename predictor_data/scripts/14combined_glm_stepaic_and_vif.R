## Masterarbeit 
##
##
## by Kai Nehl



library(mgcv)   
library(MASS)   
library(car)    
library(terra)
library(sf)


setwd("Git/Data/predictor_data")


data <- st_read("train_data.gpkg")

#remove geometry
data_no_geom <- st_drop_geometry(data)
env_vars<- c("LULC_impervious","LULC_trees", "LULC_grass", "LULC_water",
             "LULC_crops", "elevation", "distance_motorway", "distance_railway",
             "distance_waterway", "wc_bio1", "wc_bio2", "wc_bio3", "wc_bio4",
             "wc_bio5", "wc_bio6", "wc_bio7", "wc_bio8", "wc_bio9", "era5_precipitation",
             "era5_temperature", "bevoelkerungsdichte", "slope", "clc_continuous_urban_fabric", "clc_discontinuous_urban_fabric",
             "clc_industrial_or_commercial_units", "clc_road_and_rail_networks_and_associated_land", "clc_port_areas",
             "clc_airports", "clc_traffic_infrastructure", "clc_vineyards", "clc_bare_rocks", "clc_urban_areas", "aspect")


#GLm with the chosen variables of the correlation_matrix, and the clc predictors. Here, clc_continuous_urban_fabric, clc_discontinuous_urban_fabric and 
#clc_industrial_or_commercial_unit get removed, because they are translated into clc_urban_areas. Sam for clc_airport, clc_port-areas and clc_road_and_rail_networks_and_associated_land
#which are put together to clc-traffic_infrastructure


# create glm  
model <- glm(status ~ LULC_impervious + LULC_trees + LULC_grass + LULC_water+
               LULC_crops + distance_motorway + distance_railway + distance_waterway+
               wc_bio1 + wc_bio2 + wc_bio3 + wc_bio8 + wc_bio9 + era5_precipitation+
               era5_temperature + bevoelkerungsdichte + slope + aspect +
               clc_traffic_infrastructure + clc_vineyards + clc_bare_rocks + clc_urban_areas + elevation, data = data_no_geom, family = binomial)
summary(model)

plot(model)

# Stepwise AIC to find the best predictors

step_model <- stepAIC(model, direction = "both", trace = FALSE)


summary(step_model)

model_coefficients <- summary(step_model)$coefficients

# save as .csv
write.csv(model_coefficients, file = "results_glm_stepAIC.csv")

#selected variables: LULC_trees, LULC_water, LULC_crops, distance_railway , distance_waterway, wc_bio1, wc_bio9, era5_temperature, slope,
#                       clc_urban_areas, elevation


#calculating variance inflation factor (VIF) to check multicollinearity

vif(step_model)
#all values far below 10, no multicollinearity detected