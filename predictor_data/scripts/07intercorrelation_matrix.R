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


# load train_data

data <- st_read("train_data.gpkg")

data_no_geom <- st_drop_geometry(data)
env_vars<- c("LULC_impervious","LULC_trees", "LULC_grass", "LULC_water",
             "LULC_crops", "elevation", "distance_motorway", "distance_railway",
             "distance_waterway", "wc_bio1", "wc_bio2", "wc_bio3", "wc_bio4",
             "wc_bio5", "wc_bio6", "wc_bio7", "wc_bio8", "wc_bio9", "era5_precipitation",
             "era5_temperature", "bevoelkerungsdichte", "slope", "clc_continuous_urban_fabric", "clc_discontinuous_urban_fabric",
             "clc_industrial_or_commercial_units", "clc_road_and_rail_networks_and_associated_land", "clc_port_areas",
             "clc_airports", "clc_traffic_infrastructure", "clc_vineyards", "clc_bare_rocks", "clc_urban_areas", "aspect")

cor_matrix <- cor(data_no_geom[, env_vars], use = "complete.obs")

#standard derivation of some variables is 0 (binary), which means they cant be added to the correlation matrix-> clc data


apply(data_no_geom[, env_vars], 2, sd)

env_vars<- c("LULC_impervious","LULC_trees", "LULC_grass", "LULC_water",
             "LULC_crops", "elevation", "distance_motorway", "distance_railway",
             "distance_waterway", "wc_bio1", "wc_bio2", "wc_bio3", "wc_bio4",
             "wc_bio5", "wc_bio6", "wc_bio7", "wc_bio8", "wc_bio9", "era5_precipitation",
             "era5_temperature", "bevoelkerungsdichte", "slope", "aspect")

cor_matrix <- cor(data_no_geom[, env_vars], use = "complete.obs")


write.csv(cor_matrix, "intercorrelation_matrix.csv")


#(Threshold 0.8): 

#intercorrelating: 
#                  wc_bio1 vs wc_bio5 vs wc_bio6 -> all temperature, wc_bio1 correlating the strongest, keep
#                  wc_bio4 vs wc_bio7 -> not correlating significantly, get removed
#removed:         wc_bio5, wc_bio6, wc_bio4, wc_bio7

#chosen: LULC_impervious,LULC_trees, LULC_grass, LULC_water,
#LULC_crops, distance_motorway, distance_railway, distance_waterway,
#wc_bio1, wc_bio2, wc_bio3, wc_bio8, wc_bio9, era5_precipitation,
#era5_temperature, bevoelkerungsdichte, slope, aspect, elevation