## Masterarbeit 
##
##
## by Kai Nehl


library(CAST)
library(terra)      
library(sf)

setwd("Git/Data/predictor_data")

r_selected <-stack("prediction_current.grd")
model <- get(load("ffsmodel.RData"))


AOA_current <- aoa(r_selected,model)
AOA_current #threshold is 0.179
plot(AOA_current$AOA)

aoa_raster <- AOA_current$AOA

# create Mask: TRUE, where AOA == 0 
mask_layer <- aoa_raster == 0

# convert to RasterLayer
mask_raster <- raster(mask_layer)
mask_raster_resampled <- raster::resample(mask_raster, suit_raster, method = "ngb")

# Mask Suitability-Raster,outside of AOA = NA
suit_raster_masked <- raster::mask(suit_raster, mask_raster_resampled, maskvalue=1)

#plot
map <- tm_shape(suit_raster_masked, raster.downsample = FALSE) +
  tm_raster(col.scale = tm_scale(values = "viridis"), col.legend = tm_legend(title = "Eignung als Habitat")) +
  tm_scalebar(bg.color = "white") + #tm_scale_bar() → tm_scalebar()
  tm_grid(n.x = 5, n.y = 5 , lines= FALSE, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") +  # projection → crs
  tm_layout(legend.position = c("left", "bottom"),
            legend.bg.color = "white",
            bg.color = "black",
            legend.bg.alpha = 0.8) +
  tm_add_legend(type = "polygons",  # type = "fill" → type = "polygons"
                fill = "black",  # col → fill
                labels = "Outside AOA")


tmap_mode("view")

map

writeRaster(suit_raster_masked, "prediction_current_with_AOA.tif", overwrite = TRUE)
