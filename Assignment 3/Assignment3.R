library(readr)
library(dplyr)
library(leaflet)
library(htmlwidgets)

zillow_co <- read_csv("DATA/colorado_zillow.csv")


zillow_co <- zillow_co %>%
  mutate(price_size = scales::rescale(sqrt(price), to = c(4, 20)))

zillow_co <- zillow_co %>%
  mutate(
    popup_text = paste0(
      "<b>Address:</b> ", address, "<br>",
      "<b>City:</b> ", city, "<br>",
      "<b>Price:</b> $", format(price, big.mark = ","), "<br>",
      "<b>Home Type:</b> ", home_type, "<br>",
      "<b>Beds:</b> ", beds, "<br>",
      "<b>Baths:</b> ", baths, "<br>",
      "<b>Area:</b> ", area_sqft, " sq ft"
    )
  )


home_pal <- colorFactor(
  palette = c("blue", "orange", "green"),
  domain = zillow_co$home_type
)

map_home_type <- leaflet(zillow_co, width = "100%", height = 500) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = -105.0, lat = 39.5, zoom = 7) %>%
  
  addCircleMarkers(
    data = zillow_co %>% filter(home_type == "SINGLE_FAMILY"),
    lng = ~longitude,
    lat = ~latitude,
    color = ~home_pal(home_type),
    radius = ~price_size,
    stroke = FALSE,
    fillOpacity = 0.7,
    popup = ~popup_text,
    group = "Single-family homes"
  ) %>%
  
  addCircleMarkers(
    data = zillow_co %>% filter(home_type == "TOWNHOUSE"),
    lng = ~longitude,
    lat = ~latitude,
    color = ~home_pal(home_type),
    radius = ~price_size,
    stroke = FALSE,
    fillOpacity = 0.7,
    popup = ~popup_text,
    group = "Townhouses"
  ) %>%
  
  addCircleMarkers(
    data = zillow_co %>% filter(home_type == "CONDO"),
    lng = ~longitude,
    lat = ~latitude,
    color = ~home_pal(home_type),
    radius = ~price_size,
    stroke = FALSE,
    fillOpacity = 0.7,
    popup = ~popup_text,
    group = "Condos"
  ) %>%
  
  addLegend(
    position = "bottomright",
    pal = home_pal,
    values = ~home_type,
    title = "Home Type"
  ) %>%
  
  addLayersControl(
    overlayGroups = c("Single-family homes", "Townhouses", "Condos"),
    options = layersControlOptions(collapsed = FALSE)
  )

map_home_type


saveWidget(
  map_home_type,
  "WRITE UP/colorado_zillow_home_type_map.html",
  selfcontained = TRUE
)
