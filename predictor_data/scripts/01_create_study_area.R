## Masterarbeit 
##
##
## by Kai Nehl

library(terra)
library(sf)

#GADM with getData, references https://gadm.org

setwd("Git/Data/predictor_data")

gadm_G <- getData('GADM', country='Germany', level=1)

# load data
raster <- getData('GADM', country='Germany', level=1)


# transform to vector 
vector_boundary <- as (raster, "sf")

# save as Shapefile
st_write(st_as_sf(vector_boundary), "study_area.shp")
