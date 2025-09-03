## Masterarbeit 
##
##
## by Kai Nehl

#quantitative analysis of predictions
setwd("Git/Data/predictor_data")


library(terra)
library(tidyverse)
library(ggpubr)
library(readr)

#load data

raster_files <- list( current = "prediction_rf_07082025.tif",
                      ssp245_2021_2040 = "prediction_rf_2021-2040_ssp245.tif",
                      ssp585_2021_2040 = "prediction_rf_2021-2040_ssp585.tif",
                      ssp585_2041_2060 = "prediction_rf_2041-2060_ssp585.tif"
)


raster_files <- list( current = "prediction_current.tif",
                      ssp585_2041_2060 = "prediction_rf_2041-2060_ssp585.tif"
)

raster_files2 <- list( ssp245_2021_2040 = "prediction_rf_2021-2040_ssp245.tif",
                      ssp585_2021_2040 = "prediction_rf_2021-2040_ssp585.tif"
)

raster_files3 <- list( ssp585_2021_2040 = "prediction_rf_2021-2040_ssp585.tif",
                       ssp585_2041_2060 = "prediction_rf_2041-2060_ssp585.tif"
)


# get 10.000 random pixels
set.seed(123)
max_pixels <- 10000


#for current and 2041-2060 in SSP5-8.5
raster_data_sampled <- list()

for (name in names(raster_files)) {
  r <- rast(raster_files[[name]])
  
  # sample
  sampled <- spatSample(r, size = max_pixels, method = "random", as.points = TRUE, na.rm = TRUE)
  
  # Extract values
  v <- values(sampled)
  
  raster_data_sampled[[name]] <- v[,1]  
}

# put do dataframe long
df_long <- raster_data_sampled %>%
  enframe(name = "Scenario", value = "suitability") %>%  # list-column
  unnest(cols = c(suitability)) %>%
  rename(Eignung = suitability)

# stats
summary_stats <- df_long %>%
  mutate(suitability = as.numeric(suitability)) %>%  
  group_by(Scenario) %>%
  summarise(
    Mittelwert = mean(suitability, na.rm = TRUE),
    Median     = median(suitability, na.rm = TRUE),
    SD         = sd(suitability, na.rm = TRUE),
    Q1         = quantile(suitability, 0.25, na.rm = TRUE, type = 7),
    Q3         = quantile(suitability, 0.75, na.rm = TRUE, type = 7),
    n          = sum(!is.na(suitability))
  )

print(summary_stats)


write_csv(summary_stats, "summary_stats_current_vs_2031-2060_SSP5-8.5.csv")



#for 2021-2040 in both scenarios
raster_data_sampled <- list()

for (name in names(raster_files2)) {
  r <- rast(raster_files2[[name]])
  
  # sample
  sampled <- spatSample(r, size = max_pixels, method = "random", as.points = TRUE, na.rm = TRUE)
  
  # Extract values
  v <- values(sampled)
  
  raster_data_sampled[[name]] <- v[,1]  
}

# put do dataframe long
df_long <- raster_data_sampled %>%
  enframe(name = "Scenario", value = "suitability") %>%  # list-column
  unnest(cols = c(suitability)) %>%
  rename(Eignung = suitability)

# stats
summary_stats <- df_long %>%
  mutate(suitability = as.numeric(suitability)) %>%  
  group_by(Scenario) %>%
  summarise(
    Mittelwert = mean(suitability, na.rm = TRUE),
    Median     = median(suitability, na.rm = TRUE),
    SD         = sd(suitability, na.rm = TRUE),
    Q1         = quantile(suitability, 0.25, na.rm = TRUE, type = 7),
    Q3         = quantile(suitability, 0.75, na.rm = TRUE, type = 7),
    n          = sum(!is.na(suitability))
  )

print(summary_stats)


write_csv(summary_stats, "summary_stats_2021-2040_both_scenarios.csv")



#for 2021-2040 and 2041-2060 in SSP5-8.5
raster_data_sampled <- list()

for (name in names(raster_files3)) {
  r <- rast(raster_files3[[name]])
  
  # sample
  sampled <- spatSample(r, size = max_pixels, method = "random", as.points = TRUE, na.rm = TRUE)
  
  # Extract values
  v <- values(sampled)
  
  raster_data_sampled[[name]] <- v[,1]  
}

# put do dataframe long
df_long <- raster_data_sampled %>%
  enframe(name = "Scenario", value = "suitability") %>%  # list-column
  unnest(cols = c(suitability)) %>%
  rename(Eignung = suitability)

# stats
summary_stats <- df_long %>%
  mutate(suitability = as.numeric(suitability)) %>%  
  group_by(Scenario) %>%
  summarise(
    Mittelwert = mean(suitability, na.rm = TRUE),
    Median     = median(suitability, na.rm = TRUE),
    SD         = sd(suitability, na.rm = TRUE),
    Q1         = quantile(suitability, 0.25, na.rm = TRUE, type = 7),
    Q3         = quantile(suitability, 0.75, na.rm = TRUE, type = 7),
    n          = sum(!is.na(suitability))
  )

print(summary_stats)


write_csv(summary_stats, "summary_stats_2021-2040_vs_2041-2060_SSP5-8.5.csv")





# paired Wilcoxon-Tests to test for significant differences


# extract scenario names
szenarien <- names(raster_data_sampled)

# all possible combinations (no repitition, pairwise)
kombis <- combn(szenarien, 2, simplify = FALSE)

# result list
ergebnisse <- list()

# test all combinations
for (kombi in kombis) {
  s1 <- kombi[1]
  s2 <- kombi[2]
  
  # cut to same lenght
  len_min <- min(length(raster_data_sampled[[s1]]), length(raster_data_sampled[[s2]]))
  v1 <- raster_data_sampled[[s1]][1:len_min]
  v2 <- raster_data_sampled[[s2]][1:len_min]
  
  # calculate differences
  diffs <- v2 - v1
  n <- sum(!is.na(diffs))
  

  
  # Wilcoxon-Test (paired)
  test_result <- wilcox.test(v1, v2, paired = TRUE)
  
  # calculate effect r , only if p > 0 and n > 0
  if (n > 0) {
    p_adj <- max(test_result$p.value, 1e-16)
    z <- qnorm(1 - p_adj / 2)
    r <- z / sqrt(n)
    r <- min(r, 1)  
  } else {
    r <- NA
  }
  
  # Interpretation with cohen, only if R valid
  if (!is.na(r)) {
    interpretation <- cut(
      r,
      breaks = c(-Inf, 0.1, 0.3, 0.5, Inf),
      labels = c("negligible", "small", "mediocre", "great")
    )
    interpretation <- as.character(interpretation)
  } else {
    interpretation <- NA
  }
  
  # safe result
  result[[paste(s1, s2, sep = "_vs_")]] <- list(
    scenario1 = s1,
    scenario2 = s2,
    p_value = test_result$p.value,
    statistic = test_result$statistic,
    effect_size_r = r,
    interpretation = interpretation
  )
}

# as data frame
df_results <- do.call(rbind, lapply(result, as.data.frame))
rownames(df_result) <- NULL


print(df_result)

write_csv(df_result, "wilcox_results.csv")
