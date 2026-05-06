library(dplyr)
library(magrittr)
library(ggplot2)
library(maps)

# longtitude is by x-axis, latitude is by y-axis
fl_counties <- map_data(
  map = "county",
  region ="florida"
) %>%
  dplyr::select(
    lon = long, lat, group, id = subregion
  )

# each of the lon-lat coordinate is a point on the x-y plan in a county
head(fl_counties)

# group by each of the counties, replace the longitude with the average of 
# longitude and the average of the latitude for the county.
fl_counties[,c("id","lon","lat")] %>%
  dplyr::group_by(id) %>%
  dplyr::summarise(
    lon = mean(lon),
    lat = mean(lat)
  )
# results: counties are ordered by alphabetic order 

# the dataset has four variables:
# 1 & 2. lat and long specify the latitude and longitude of a vertex 
# (i.e. a corner of the ploygon)
# 3. id specifies the name of a region,
# 4. group provides a unique identifier for contiguous/touching areas 
# within a region, which corresponds to county. 

# map of florida counties fl_counties
ggplot(fl_counties) + 
  aes(lon, lat) +
  geom_point(
    size = .25,
    show.legend = FALSE
  ) + 
  coord_quickmap() # makes sure right ratio. By default, ggplot tries to fill 
# the entire region possible even if it distorts the ratio of it. 

# now connecting the dots in the same group using geom_ploygon 
ggplot(fl_counties) + 
  aes(lon, lat, group = group) +
  geom_polygon(
    fill = "forestgreen",# area colour
    colour = "pink" # line colour
  ) + 
  coord_quickmap()

#
