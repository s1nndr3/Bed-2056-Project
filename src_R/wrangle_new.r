library(tidyverse)
library(lubridate)
library(plotly)
library(gridExtra)
library(grid)

#File location
weather_data_loc = "../data/weather" #Relative address
parking_data_loc = "../data/parking" #Relative address


#Find file names (with path)
weather_files = list.files(path=weather_data_loc, pattern="", full.names=TRUE)
parking_files = list.files(path=parking_data_loc, pattern="", full.names=TRUE)


#Some errors in the data files may exist, Seams like "Antall_ledige_plasser" sometime is value "0,0" (nothing to do about that). 
func <- function(file){
  df <- read_csv(file, col_types = cols(.default = "c")) 
  return(df)
}
df_parking <- map_dfr(parking_files, func) %>% .[, c("Dato", "Klokkeslett", "Sted", "Antall_ledige_plasser", "Latitude", "Longitude")]
df_weather <- map_dfr(weather_files, func) %>% .[, c("referenceTime", "elementId", "value", "unit")]

#Rename
names(df_parking) <- c("Date", "Time", "Place", "Free_spaces", "Lat", "Lon")
names(df_weather) <- c("DateTime", "Element", "Value", "unit")

# Set Lat and Lon to numeric
df_parking <- df_parking %>% mutate(Lat = as.numeric(Lat)) %>% mutate(Lon = as.numeric(Lon))

#List of all places
places <- unique(df_parking$Place) 
n_places <- length(places)
loc_parking <- df_parking[1:n_places, c("Place", "Lat", "Lon")]

#Set datetime
df_parking <- df_parking %>% 
  mutate(DateTime = as.POSIXct(paste(Date, Time, sep = " "), format="%d.%m.%Y %H:%M")) %>%
  .[, c("DateTime", "Place", "Free_spaces")]

df_weather <- df_weather %>% 
  mutate(DateTime = as.POSIXct(DateTime, format="%Y-%m-%dT%H:%M:%S"))


#Modify "Antall_ledige_plasser"
df_parking <- df_parking %>%
  mutate(Free_spaces = ifelse(Free_spaces == "0", NA,  #Where there where 0,0 as value
                              ifelse(Free_spaces == "Fullt", "0", Free_spaces)
                              )
        ) %>%
  mutate(Free_spaces = as.numeric(Free_spaces))

#Modify "Element"
df_weather <- df_weather %>%
  mutate(Element = ifelse(Element == "air_temperature", "Air_temp", 
                          ifelse(Element == "sum(precipitation_amount PT1H)", "Precipitation",
                                 ifelse(Element == "wind_from_direction", "wind_direction",
                                        Element)))) %>%
  mutate(Value = as.numeric(Value))

#Remove duplicate rows
df_parking <- unique(df_parking)

#Calculate average of each hour
df_parking <- df_parking %>%
  mutate(DateTime = floor_date(DateTime, "hour")) %>% 
  group_by(DateTime, Place) %>% 
  summarise(Free_spaces = mean(Free_spaces)) %>% 
  mutate(Free_spaces = round(Free_spaces))

#Combine element and unit in to one column
df_weather <- df_weather %>% 
  mutate(Element = paste(Element, unit, sep = " ")) %>%
  select(., -unit)

#Combine/reshape elements in to one row
#Combine the data frames
df_main <- left_join(spread(df_parking, "Place", "Free_spaces"), spread(df_weather, "Element", "Value"))

