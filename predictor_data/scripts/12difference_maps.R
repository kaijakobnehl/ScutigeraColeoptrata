## Masterarbeit 
##
##
## by Kai Nehl



setwd("Git/Data/predictor_data")


library(terra)      
library(tmap)       


# Load predictions
r_current <- rast("prediction_rf_current.tif")
r_future  <- rast("prediction_rf_2021-2040_ssp585.tif")


r_diff <- r_future - r_current


map_currentx2021_585 <- tm_shape(r_diff, raster.downsample = FALSE) +
  tm_raster(col.scale = tm_scale(values = "viridis"), col.legend = tm_legend(title = "Change in habitat suitability current vs 2040 in ssp585")) +
  tm_scalebar(bg.color = "white") + #tm_scale_bar() → tm_scalebar()
  tm_grid(n.x = 5, n.y = 5 , lines= FALSE, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") +  # projection → crs
  tm_layout(legend.position = c("left", "bottom"),
            legend.bg.color = "white",
            bg.color = "black",
            legend.bg.alpha = 0.8)

tmap_mode("view")
map_currentx2021_585
tmap_save(map_currentx2021_585, "difference_current_vs_ssp585_2021.png")


#load next prediction-pair
r_current <- rast("prediction_rf_current.tif")
r_future  <- rast("prediction_rf_2041-2060_ssp585.tif")


r_diff <- r_future - r_current



map_currentx2041_585 <- tm_shape(r_diff, raster.downsample = FALSE) +
  tm_raster(col.scale = tm_scale(values = colors, breaks = breaks), col.legend = tm_legend(title = "Change in habitat suitability")) +
  tm_scalebar(bg.color = "white") + #tm_scale_bar() → tm_scalebar()
  tm_grid(n.x = 5, n.y = 5 , lines= FALSE, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") +  # projection → crs
  tm_layout(legend.position = c("left", "bottom"),
            legend.bg.color = "white",
            bg.color = "black",
            legend.bg.alpha = 0.8)

map_currentx2041_585
tmap_save(map_currentx2041_585, "difference_current_2041-2060_ssp585.png")



#scenarios of the same timespan to compare


r_2021_ssp245 <- rast("prediction_rf_2021-2040_ssp245.tif")
r_2021_ssp585  <- rast("prediction_rf_2021-2040_ssp585.tif")


r_diff <- r_2021_ssp245 - r_2021_ssp585


map_2021_ssp245x2021_585 <- tm_shape(r_diff, raster.downsample = FALSE) +
  tm_raster(col.scale = tm_scale(values = colors, breaks = breaks), col.legend = tm_legend(title = "Change in habitat suitability")) +
  tm_scalebar(bg.color = "white") + #tm_scale_bar() → tm_scalebar()
  tm_grid(n.x = 5, n.y = 5 , lines= FALSE, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") +  # projection → crs
  tm_layout(legend.position = c("left", "bottom"),
            legend.bg.color = "white",
            bg.color = "black",
            legend.bg.alpha = 0.8)

tmap_mode("view")
map_2021_ssp245x2021_585
tmap_save(map_2021_ssp245x2021_585, "difference_2021_ssp245_vs_ssp585_2021.png")



# next one
r_2041_ssp245 <- rast("prediction_rf_2041-2060_ssp245.tif")
r_2041_ssp585  <- rast("prediction_rf_2041-2060_ssp585.tif")


r_diff <- r_2041_ssp245 - r_2041_ssp585


map_2041_ssp245x2041_585 <- tm_shape(r_diff, raster.downsample = FALSE) +
  tm_raster(col.scale = tm_scale(values = "viridis"), col.legend = tm_legend(title = "Change in habitat suitability current vs 2040 in ssp585")) +
  tm_scalebar(bg.color = "white") + #tm_scale_bar() → tm_scalebar()
  tm_grid(n.x = 5, n.y = 5 , lines= FALSE, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") +  # projection → crs
  tm_layout(legend.position = c("left", "bottom"),
            legend.bg.color = "white",
            bg.color = "black",
            legend.bg.alpha = 0.8)

tmap_mode("view")
map_2041_ssp245x2041_585
tmap_save(map_2041_ssp245x2041_585, "difference_2021_ssp245_vs_ssp585_2021.png")


#ssp585 in both time periods


r_2021_ssp585 <- rast("prediction_rf_2021-2040_ssp585_ohne_aoa.tif")
r_2041_ssp585  <- rast("prediction_rf_2041-2060_ssp585_ohne_aoa.tif")


r_diff <- r_2021_ssp585 - r_2041_ssp585


map_2021_ssp585x2041_585 <- tm_shape(r_diff, raster.downsample = FALSE) +
  tm_raster(col.scale = tm_scale(values = colors, breaks = breaks), col.legend = tm_legend(title = "Change in habitat suitability")) +
  tm_scalebar(bg.color = "white") + #tm_scale_bar() → tm_scalebar()
  tm_grid(n.x = 5, n.y = 5 , lines= FALSE, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") +  # projection → crs
  tm_layout(legend.position = c("left", "bottom"),
            legend.bg.color = "white",
            bg.color = "black",
            legend.bg.alpha = 0.8)

tmap_mode("view")
map_2021_ssp585x2041_585
tmap_save(map_2021_ssp585x2041_585, "difference_2021_ssp585_vs_ssp585_2041.png")
