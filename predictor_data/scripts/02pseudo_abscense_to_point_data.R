## Masterarbeit 
##
##
## by Kai Nehl


library(sf)
library(dplyr)


setwd("Git/Data/predictor_data")

#thank you @ Hanna Meyer for creating and sharing distribution data
# load train data
pointdata <- st_read("s.coleoptrata_ger.shp")
pointdata$status <- 1  # mark true (presence) data

# loading extent for random points
extent <- st_read("study_area.gpkg")

# create Pseudo-abscenses
pseudo_abscense <- st_sample(extent, size = 416, type = "random")
pseudo_abscense_sf <- st_as_sf(pseudo_absenz, crs = st_crs(pointdata))

# add column "status" 
pseudo_abscense_df <- data.frame(
  longitude = st_coordinates(pseudo_abscense_sf)[,1],
  latitude = st_coordinates(pseudo_abscense_sf)[,2],
  status = 0
)
pseudo_abscense_sf <- st_as_sf(pseudo_abscense_df, coords = c("longitude", "latitude"), crs = st_crs(pointdata))

# add missing columns
missing_cols <- setdiff(names(pointdata), names(pseudo_abscense_sf))
pseudo_abscense_sf[missing_cols] <- NA

# merge and save
all_data <- rbind(pointdata, pseudo_abscense_sf)
st_write(all_data, "train_data.shp", overwrite = TRUE)
