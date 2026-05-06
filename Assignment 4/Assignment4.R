library(sf)
library(dplyr)
library(leaflet)
library(htmlwidgets)

tracts <- st_read("DATA/tl_2025_12_tract/tl_2025_12_tract.shp")

tracts

st_geometry_type(tracts)

names(tracts)

head(tracts)

tracts <- tracts %>%
  mutate(
    land_area_sq_mile = ALAND / 2589988.11,
    area_group = case_when(
      land_area_sq_mile < 2 ~ "Small tract area",
      land_area_sq_mile < 10 ~ "Medium tract area",
      TRUE ~ "Large tract area"
    )
  )


tracts <- tracts %>%
  mutate(
    popup_text = paste0(
      "<b>County FIPS:</b> ", COUNTYFP, "<br>",
      "<b>Tract Name:</b> ", NAMELSAD, "<br>",
      "<b>Land Area:</b> ", round(land_area_sq_mile, 2), " sq miles<br>",
      "<b>Area Group:</b> ", area_group
    )
  )


area_pal <- colorFactor(
  palette = c("lightblue", "orange", "red"),
  domain = tracts$area_group
)

tract_map <- leaflet(tracts, width = "100%", height = 600) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = -82.5, lat = 28.2, zoom = 6) %>%
  
  addPolygons(
    fillColor = ~area_pal(area_group),
    fillOpacity = 0.6,
    color = "white",
    weight = 0.5,
    popup = ~popup_text
  ) %>%
  
  addLegend(
    position = "bottomright",
    pal = area_pal,
    values = ~area_group,
    title = "Census Tract Land Area"
  )

tract_map




tract_map <- leaflet(tracts, width = "100%", height = 600) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  setView(lng = -82.5, lat = 28.2, zoom = 6) %>%
  
  addPolygons(
    data = tracts %>% filter(area_group == "Small tract area"),
    fillColor = ~area_pal(area_group),
    fillOpacity = 0.6,
    color = "white",
    weight = 0.5,
    popup = ~popup_text,
    group = "Small tract area"
  ) %>%
  
  addPolygons(
    data = tracts %>% filter(area_group == "Medium tract area"),
    fillColor = ~area_pal(area_group),
    fillOpacity = 0.6,
    color = "white",
    weight = 0.5,
    popup = ~popup_text,
    group = "Medium tract area"
  ) %>%
  
  addPolygons(
    data = tracts %>% filter(area_group == "Large tract area"),
    fillColor = ~area_pal(area_group),
    fillOpacity = 0.6,
    color = "white",
    weight = 0.5,
    popup = ~popup_text,
    group = "Large tract area"
  ) %>%
  
  addLegend(
    position = "bottomright",
    pal = area_pal,
    values = ~area_group,
    title = "Census Tract Land Area"
  ) %>%
  
  addLayersControl(
    overlayGroups = c(
      "Small tract area",
      "Medium tract area",
      "Large tract area"
    ),
    options = layersControlOptions(collapsed = FALSE)
  )

tract_map


saveWidget(
  tract_map,
  "WRITE UP/florida_census_tract_area_map.html",
  selfcontained = TRUE
)
