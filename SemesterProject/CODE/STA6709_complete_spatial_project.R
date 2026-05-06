# STA6709 Spatial Statistics Semester Project
# Spatial Analysis of Colorado Housing Prices Using Zillow Listing Data
# Xiaoling Sundberg 
# May 03, 2026


# Step 1: Install packages
library(readr)
library(dplyr)
library(ggplot2)
library(sf)
library(tigris)
library(leaflet)
library(scales)

options(tigris_use_cache = TRUE)


# Step 2: Folder paths
project_dir <- "/Users/xiaolingsundberg/Desktop/STA6709/SemesterProject"
data_dir <- file.path(project_dir, "DATA")
writeup_dir <- file.path(project_dir, "WRITE UP")

# Step 3: Read in data 
zillow <- read_csv(
  file.path(data_dir, "colorado_zillow.csv"),
  show_col_types = FALSE
)

head(zillow)
dim(zillow)
names(zillow)

# Step 4: Clean data and keep only latitude, longitude, price, beds, baths,
# and square footage. Also creates price per square foot and log price.

zillow_clean <- zillow %>%
  distinct(zpid, .keep_all = TRUE) %>%
  filter(
    !is.na(latitude),
    !is.na(longitude),
    !is.na(price),
    !is.na(beds),
    !is.na(baths),
    !is.na(area_sqft),
    latitude >= 36.5,
    latitude <= 41.5,
    longitude >= -109.5,
    longitude <= -101.5
  ) %>%
  mutate(
    price_per_sqft = price / area_sqft,
    log_price = log(price),
    price_category = case_when(
      price < 500000 ~ "Below $500K",
      price < 750000 ~ "$500K-$749K",
      price < 1000000 ~ "$750K-$999K",
      TRUE ~ "$1M+"
    )
  )

head(zillow_clean)
dim(zillow_clean)

# Step 5: Summary statistics overall
overall_summary <- tibble(
  Metric = c(
    "Number of listings",
    "Number of cities",
    "Number of ZIP codes",
    "Minimum price",
    "Median price",
    "Mean price",
    "Maximum price",
    "Median area square feet",
    "Median price per square foot"
  ),
  Value = c(
    nrow(zillow_clean),
    n_distinct(zillow_clean$city),
    n_distinct(zillow_clean$zipcode),
    min(zillow_clean$price),
    median(zillow_clean$price),
    mean(zillow_clean$price),
    max(zillow_clean$price),
    median(zillow_clean$area_sqft),
    median(zillow_clean$price_per_sqft)
  )
)

overall_summary

# Step 6: Summary statistics by city
city_summary <- zillow_clean %>%
  group_by(city) %>%
  summarize(
    listing_count = n(),
    median_price = median(price),
    mean_price = mean(price),
    median_price_per_sqft = median(price_per_sqft),
    .groups = "drop"
  ) %>%
  arrange(desc(listing_count), desc(median_price))

head(city_summary, 10)

# Step 7: Summary statistics by home type
home_type_summary <- zillow_clean %>%
  group_by(home_type) %>%
  summarize(
    listing_count = n(),
    median_price = median(price),
    mean_price = mean(price),
    median_area_sqft = median(area_sqft),
    .groups = "drop"
  ) %>%
  arrange(desc(listing_count))

home_type_summary

# Step 8: Get Colorado polygon data from tigris (state and county)
us_states <- states(cb = TRUE, year = 2023)

colorado_boundary <- us_states %>%
  filter(STUSPS == "CO") %>%
  st_transform(crs = 4326)

colorado_counties <- counties(state = "CO", cb = TRUE, year = 2023) %>%
  st_transform(crs = 4326)

plot(st_geometry(colorado_boundary), main = "Colorado State Boundary")
plot(st_geometry(colorado_counties), main = "Colorado County Boundaries")

# Step 9: Convert Zillow listings into spatial points (sf object) 
zillow_sf <- st_as_sf(
  zillow_clean,
  coords = c("longitude", "latitude"),
  crs = 4326,
  remove = FALSE
)

zillow_sf
plot(st_geometry(zillow_sf), main = "Zillow Listings as Spatial Points")

# Step 10: Map house locations inside Colorado state polygon
map_house_locations <- ggplot() +
  geom_sf(data = colorado_boundary, fill = "gray95", 
          color = "black", linewidth = 0.8) +
  geom_sf(data = zillow_sf, aes(color = price), 
          size = 2.6, alpha = 0.80) +
  scale_color_viridis_c(labels = comma) +
  labs(
    title = "Colorado Zillow House Locations",
    subtitle = "Zillow listings shown inside the Colorado state boundary",
    color = "Listing Price"
  ) +
  theme_minimal()

map_house_locations

# Step 11: Map house locations with county boundaries 
map_house_locations_counties <- ggplot() +
  geom_sf(data = colorado_counties, fill = "gray96", 
          color = "white", linewidth = 0.35) +
  geom_sf(data = colorado_boundary, fill = NA, 
          color = "black", linewidth = 0.8) +
  geom_sf(data = zillow_sf, aes(color = price), size = 2.5, alpha = 0.80) +
          scale_color_viridis_c(labels = comma) +
  labs(title = "Colorado Zillow Listings with County Boundaries",
       subtitle = "County polygons provide geographic context for house locations",
       color = "Listing Price") +
  theme_minimal()

map_house_locations_counties

# Step 12: Map houses by home type 
map_home_type <- ggplot() +
  geom_sf(data = colorado_counties, fill = "gray96", 
          color = "white", linewidth = 0.35) +
  geom_sf(data = colorado_boundary, fill = NA, 
          color = "black", linewidth = 0.8) +
  geom_sf(data = zillow_sf, aes(color = home_type), 
          size = 2.5, alpha = 0.85) +
  labs(title = "Colorado Zillow Listings by Home Type",
       subtitle = "Listings are mapped as spatial points over Colorado county polygons",
       color = "Home Type") +
  theme_minimal()

map_home_type

# Step 13: Histogram for house price 
price_histogram <- ggplot(zillow_clean, aes(x = price)) +
  geom_histogram(bins = 25, fill = "#4c78a8", color = "white") +
  scale_x_continuous(labels = comma) +
  labs(
    title = "Distribution of Colorado Zillow Listing Prices",
    x = "Listing Price",
    y = "Number of Listings"
  ) +
  theme_minimal()

price_histogram
# price is highly right skewed - need log transformation for analysis

# Step 14: Scatter plot for price and square feet.
price_by_area <- ggplot(zillow_clean, aes(x = area_sqft, y = price)) +
  geom_point(alpha = 0.75, color = "#f58518") +
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Listing Price by Home Size",
    x = "Area Square Feet",
    y = "Listing Price"
  ) +
  theme_minimal()

price_by_area

# Step 15: Fit a regression model 
price_model <- lm(
  log_price ~ beds + baths + area_sqft + home_type + days_on_zillow +
    latitude + longitude,
  data = zillow_clean
)

summary(price_model)

# Step 16: Show regression coefficients as a table 
regression_coefficients <- as.data.frame(summary(price_model)$coefficients)
regression_coefficients$Variable <- rownames(regression_coefficients)

regression_coefficients <- regression_coefficients %>%
  select(
    Variable,
    Estimate,
    `Std. Error`,
    `t value`,
    `Pr(>|t|)`
  )

regression_coefficients

# Step 17: Add predicted prices and residuals 
# Residual = actual price - predicted price.
# Positive residual means the house price is higher than predicted.
# Negative residual means the house price is lower than predicted.
zillow_model_results <- zillow_clean %>%
  mutate(
    predicted_log_price = predict(price_model, newdata = zillow_clean),
    predicted_price = exp(predicted_log_price),
    residual = price - predicted_price,
    absolute_residual = abs(residual)
  )

zillow_model_results %>%
  select(address, city, price, predicted_price, residual) %>%
  head(10)

# Step 18: Map regression residuals to see location of over/under-priced houses
zillow_model_sf <- st_as_sf(
  zillow_model_results,
  coords = c("longitude", "latitude"),
  crs = 4326,
  remove = FALSE
)

residual_map <- ggplot() +
  geom_sf(data = colorado_counties, fill = "gray96", color = "white", linewidth = 0.35) +
  geom_sf(data = colorado_boundary, fill = NA, color = "black", linewidth = 0.8) +
  geom_sf(data = zillow_model_sf, aes(color = residual), size = 2.7, alpha = 0.85) +
  scale_color_gradient2(
    low = "#2b6cb0",
    mid = "white",
    high = "#c53030",
    midpoint = 0,
    labels = comma
  ) +
  labs(
    title = "Regression Residuals by House Location",
    subtitle = "Red = actual price above prediction; blue = actual price below prediction",
    color = "Residual"
  ) +
  theme_minimal()

residual_map

# Step 19: Nearest-neighbor spatial analysis 
# A nearest-neighbor index below 1 suggests clustering.
haversine_km <- function(lat1, lon1, lat2, lon2) {
  radius_km <- 6371.0088
  lat1 <- lat1 * pi / 180
  lon1 <- lon1 * pi / 180
  lat2 <- lat2 * pi / 180
  lon2 <- lon2 * pi / 180
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1
  a <- sin(dlat / 2)^2 + cos(lat1) * cos(lat2) * sin(dlon / 2)^2
  2 * radius_km * asin(sqrt(a))
}

lonlat_to_xy_km <- function(data, lon_col = "longitude", lat_col = "latitude") {
  lat0 <- mean(data[[lat_col]], na.rm = TRUE) * pi / 180
  x <- data[[lon_col]] * 111.320 * cos(lat0)
  y <- data[[lat_col]] * 110.574
  cbind(x, y)
}

coords <- zillow_clean %>% select(latitude, longitude)
n_points <- nrow(coords)
distance_matrix <- matrix(Inf, nrow = n_points, ncol = n_points)

for (i in seq_len(n_points)) {
  distance_matrix[i, ] <- haversine_km(
    coords$latitude[i],
    coords$longitude[i],
    coords$latitude,
    coords$longitude
  )
  distance_matrix[i, i] <- Inf
}

nearest_neighbor_distances <- apply(distance_matrix, 1, min)

xy_points <- lonlat_to_xy_km(zillow_clean)
hull_index <- chull(xy_points[, 1], xy_points[, 2])
hull_points <- xy_points[c(hull_index, hull_index[1]), ]

study_area_km2 <- abs(sum(
  hull_points[-1, 1] * hull_points[-nrow(hull_points), 2] -
    hull_points[-nrow(hull_points), 1] * hull_points[-1, 2]
) / 2)

listing_intensity <- n_points / study_area_km2
observed_mean_nn <- mean(nearest_neighbor_distances)
expected_mean_nn <- 1 / (2 * sqrt(listing_intensity))
nearest_neighbor_index <- observed_mean_nn / expected_mean_nn

point_pattern_interpretation <- case_when(
  nearest_neighbor_index < 0.9 ~ "clustered",
  nearest_neighbor_index > 1.1 ~ "more dispersed than random",
  TRUE ~ "approximately random"
)

nearest_neighbor_summary <- tibble(
  Metric = c(
    "Number of listings",
    "Study area convex hull square km",
    "Listing intensity per square km",
    "Observed mean nearest-neighbor distance km",
    "Expected mean nearest-neighbor distance km under CSR",
    "Nearest-neighbor index",
    "Point pattern interpretation"
  ),
  Value = c(
    n_points,
    round(study_area_km2, 3),
    round(listing_intensity, 6),
    round(observed_mean_nn, 3),
    round(expected_mean_nn, 3),
    round(nearest_neighbor_index, 3),
    point_pattern_interpretation
  )
)

nearest_neighbor_summary

# Step 20: Histogram of nearest-neighbor distances 
nearest_neighbor_histogram <- ggplot(
  tibble(nearest_neighbor_distance_km = nearest_neighbor_distances),
  aes(x = nearest_neighbor_distance_km)
) +
  geom_histogram(bins = 20, fill = "#54a24b", color = "white") +
  geom_vline(xintercept = observed_mean_nn, linetype = "dashed") +
  labs(
    title = "Nearest-Neighbor Distances Between Zillow Listings",
    x = "Nearest-Neighbor Distance (km)",
    y = "Number of Listings"
  ) +
  theme_minimal()

nearest_neighbor_histogram

# Step 21: Simple spatial clusters 
set.seed(42)
cluster_fit <- kmeans(xy_points, centers = 4, nstart = 20)

zillow_clustered <- zillow_model_results %>%
  mutate(spatial_cluster = cluster_fit$cluster)

cluster_summary <- zillow_clustered %>%
  group_by(spatial_cluster) %>%
  summarize(
    listing_count = n(),
    median_price = median(price),
    mean_price = mean(price),
    median_area_sqft = median(area_sqft),
    latitude = mean(latitude),
    longitude = mean(longitude),
    .groups = "drop"
  ) %>%
  arrange(spatial_cluster)

cluster_summary

# Step 22: Map spatial clusters 
zillow_clustered_sf <- st_as_sf(
  zillow_clustered,
  coords = c("longitude", "latitude"),
  crs = 4326,
  remove = FALSE
)

cluster_map <- ggplot() +
  geom_sf(data = colorado_counties, fill = "gray96", 
          color = "white", linewidth = 0.35) +
  geom_sf(data = colorado_boundary, fill = NA, 
          color = "black", linewidth = 0.8) +
  geom_sf(data = zillow_clustered_sf, aes(color = factor(spatial_cluster)), 
          size = 2.7, alpha = 0.85) +
  labs(
    title = "Spatial Clusters of Colorado Zillow Listings",
    subtitle = "Clusters are based on latitude and longitude",
    color = "Spatial Cluster"
  ) +
  theme_minimal()

cluster_map

# Step 23: Interactive Leaflet map 
zillow_clustered <- zillow_clustered %>%
  mutate(
    popup_text = paste0(
      "<b>Address:</b> ", address, "<br>",
      "<b>City:</b> ", city, "<br>",
      "<b>Actual Price:</b> $", comma(price), "<br>",
      "<b>Predicted Price:</b> $", comma(round(predicted_price, 0)), "<br>",
      "<b>Residual:</b> $", comma(round(residual, 0)), "<br>",
      "<b>Home Type:</b> ", home_type, "<br>",
      "<b>Beds/Baths:</b> ", beds, "/", baths, "<br>",
      "<b>Area:</b> ", comma(area_sqft), " sq ft<br>",
      "<b>Spatial Cluster:</b> ", spatial_cluster
    )
  )

price_palette <- colorNumeric(
  palette = "viridis",
  domain = zillow_clustered$price
)

interactive_map <- leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(
    data = colorado_counties,
    fillColor = "transparent",
    color = "gray60",
    weight = 0.6,
    opacity = 0.8,
    group = "Colorado counties"
  ) %>%
  addPolygons(
    data = colorado_boundary,
    fillColor = "transparent",
    color = "black",
    weight = 1.4,
    opacity = 1,
    group = "Colorado boundary"
  ) %>%
  addCircleMarkers(
    data = zillow_clustered,
    lng = ~longitude,
    lat = ~latitude,
    radius = ~pmax(4, pmin(18, sqrt(price) / 80)),
    color = ~price_palette(price),
    stroke = TRUE,
    weight = 1,
    fillOpacity = 0.75,
    popup = ~popup_text,
    group = "Zillow listings"
  ) %>%
  addLegend(
    position = "bottomright",
    pal = price_palette,
    values = zillow_clustered$price,
    title = "Listing Price"
  ) %>%
  addLayersControl(
    overlayGroups = c(
      "Colorado counties",
      "Colorado boundary",
      "Zillow listings"
    ),
    options = layersControlOptions(collapsed = FALSE)
  )

interactive_map

# Step 24: Final results
cat("\nMain project results:\n")
cat("- Cleaned Zillow listings:", nrow(zillow_clean), "\n")
cat("- Median listing price: $", comma(round(median(zillow_clean$price), 0)), "\n", sep = "")
cat("- Mean listing price: $", comma(round(mean(zillow_clean$price), 0)), "\n", sep = "")
cat("- Nearest-neighbor index:", round(nearest_neighbor_index, 3), "\n")
cat("- Point-pattern interpretation:", point_pattern_interpretation, "\n")
cat("- Regression model uses log price as the response variable.\n")
cat("- Interactive map object is named: interactive_map\n")
