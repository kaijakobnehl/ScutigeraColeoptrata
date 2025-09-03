## Masterarbeit 
##
##
## by Kai Nehl


library(terra)

setwd("Git/Data/predictor_data")


#clc downloaded manually from: https://land.copernicus.eu/en/products/corine-land-cover

# load raster 
clc_raster <- rast("clc_reprojected.tif")

# define selected categories
selected_categories <- c(1, 2, 3, 4, 5, 6, 15, 31)

# workflow for selected categories
for (cat in selected_categories) {
  # create binary raster (1 = Pixel of this category, 0 = all other)
  cat_raster <- clc_raster == cat
  
  # save raster as .tif 
  writeRaster(cat_raster, paste0("clc_category_", cat, ".tif"), overwrite = TRUE)
}

clc_1.1.1 <- rast("clc_1.1.1_continuous_urban_fabric.tif")
clc_1.1.2 <- rast("clc_1.1.2_discontinuous_urban_fabric.tif")
clc_1.2.1 <- rast("clc_1.2.1_industrial_or_commercial_units.tif")
clc_1.2.2 <- rast("clc_1.2.2_road_and_rail_networks_and_associated_land.tif")
clc_1.2.3 <- rast("clc_1.2.3_port_areas.tif")
clc_1.2.4 <- rast("clc_1.2.4_airports.tif")
clc_2.2.1 <- rast("clc_2.2.1_vineyards.tif")
clc_3.3.2 <- rast("clc_3.3.2_bare_rocks.tif")



ext <- vect("study_area.shp")


ext_proj <- project(ext, crs(clc_1.1.1))
ext_proj2 <- project(ext, crs(clc_1.1.2))
ext_proj3 <- project(ext, crs(clc_1.2.1))
ext_proj4 <- project(ext, crs(clc_1.2.2))
ext_proj5 <- project(ext, crs(clc_1.2.3))
ext_proj6 <- project(ext, crs(clc_1.2.4))
ext_proj7 <- project(ext, crs(clc_2.2.1))
ext_proj8 <- project(ext, crs(clc_3.3.2))



# clip Raster to shapefiles 

raster_masked <- mask(clc_1.1.1, gebiet_proj)  # omits values outside of the extent
raster_masked2 <- mask(clc_1.1.2, gebiet_proj2)
raster_masked3 <- mask(clc_1.2.1, gebiet_proj3)
raster_masked4 <- mask(clc_1.2.2, gebiet_proj4)
raster_masked5 <- mask(clc_1.2.3, gebiet_proj5)
raster_masked6 <- mask(clc_1.2.4, gebiet_proj6)
raster_masked7 <- mask(clc_2.2.1, gebiet_proj7)
raster_masked8 <- mask(clc_3.3.2, gebiet_proj8)


# save results
writeRaster(raster_masked, "clc_continuous_urban_fabric_crop.tif", overwrite=TRUE)
writeRaster(raster_masked2, "clc_discontinuous_urban_fabric_crop.tif", overwrite=TRUE)
writeRaster(raster_masked3, "clc_industrial_or_commercial_units_crop.tif", overwrite=TRUE)
writeRaster(raster_masked4, "clc_road_and_rail_networks_and_associated_land_crop.tif", overwrite=TRUE)
writeRaster(raster_masked5, "clc_port_areas_crop.tif", overwrite=TRUE)
writeRaster(raster_masked6, "clc_airports_crop.tif", overwrite=TRUE)
writeRaster(raster_masked7, "clc_vineyards_crop.tif", overwrite=TRUE)
writeRaster(raster_masked8, "clc_bare rocks_crop.tif", overwrite=TRUE)

