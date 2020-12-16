
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