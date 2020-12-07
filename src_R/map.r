library("maps")
library(plotly)

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
