library("maps")
library(plotly)
library("ggmap")

map <- map_data("world")

ggplotly(
ggplot() + geom_polygon(data = map, aes(x=long, y = lat, group = group)) + 
  coord_fixed(1.3)
)



ggplot() + geom_polygon(data = map, aes(x=long, y = lat, group = group)) + 
  #annotation_scale(location = "bl", width_hint = 0.5) +
  #annotation_north_arrow(location = "bl", which_north = "true", 
  #                       pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
  #                       style = north_arrow_fancy_orienteering) +
  #geom_sf() +
  #coord_sf(xlim = c(-102.15, -74.12), ylim = c(7.65, 33.97), expand = FALSE)
  coord_fixed(1.3, xlim = c(4, 11.9100), ylim = c(49, 59.1852), expand = FALSE)


get_googlemap("stavanger norway", zoom = 12, maptype = "satellite") %>% ggmap()

library(leaflet)
map3 <- leaflet() %>%
addTiles() #%>%  # Add default OpenStreetMap map tiles
for(n in 1:n_places){
  temp <- loc_parking[n,]
  map3 <- map3 %>% addMarkers(lat=temp$Lat, lng=temp$Lon, popup=temp$Place)
}


# map3$setView(c(59.914, 10.72), zoom = 13) # Longitude and Latitude of Oslo center - 59.9140100;10.7246670
# map3$marker(c(59.9140100,10.7246670), bindPopup = "<p> Hi. I am a popup </p>")
# map3$marker(c(59.9085200,10.7645700), bindPopup = "<p> Hello Oslo! </p>")
# map3$save('Oslo.html', 'inline', cdn=TRUE)
# cat('<iframe src="Oslo.html" width=100%, height=600></iframe>')