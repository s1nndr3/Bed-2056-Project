library(tidyverse)
library(lubridate)
library(plotly)
library(gridExtra)
library(grid)

#File location
weather_data_loc = "../../data/weather" #Relative address
parking_data_loc = "../../data/parking" #Relative address


#Find file names (with path)
weather_files = list.files(path=weather_data_loc, pattern="", full.names=TRUE)
parking_files = list.files(path=parking_data_loc, pattern="", full.names=TRUE)


#Some errors in the data files may exist, Seams like "Antall_ledige_plasser" sometime is value "0,0" (nothing to do about that). 
func <- function(file){
  df <- read_csv(file, col_types = cols(.default = "c")) 
  return(df)
}
df_parking <- map_dfr(parking_files, func) %>% .[, c("Dato", "Klokkeslett", "Sted", "Antall_ledige_plasser")]
df_weather <- map_dfr(weather_files, func) %>% .[, c("referenceTime", "elementId", "value", "unit")]


#Rename
names(df_parking) <- c("Date", "Time", "Place", "Free_spaces")
names(df_weather) <- c("DateTime", "Element", "Value", "unit")


#Set datetime
df_parking <- df_parking %>% 
  mutate(DateTime = as.POSIXct(paste(Date, Time, sep = " "), format="%d.%m.%Y %H:%M")) %>%
  .[, c("DateTime", "Place", "Free_spaces")]

df_weather <- df_weather %>% 
  mutate(DateTime = as.POSIXct(DateTime, format="%Y-%m-%dT%H:%M:%S"))


#Modify "Antall_ledige_plasser"
df_parking <- df_parking %>%
  mutate(Free_spaces = ifelse(Free_spaces == "Fullt", "0", Free_spaces)) %>%
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
#table(df_parking$DateTime)


#Calculate average of each hour
df_parking <- df_parking %>%
  mutate(DateTime = floor_date(DateTime, "hour")) %>% 
  group_by(DateTime, Place) %>% 
  summarise(Free_spaces = mean(Free_spaces)) %>% 
  mutate(Free_spaces = round(Free_spaces))

#COmbine element and unit in to one column
df_weather <- df_weather %>% 
  mutate(Element = paste(Element, unit, sep = " ")) %>%
  select(., -unit)

#Combine/reshape elements in to one row
#df_weather <- spread(df_weather, "Element", "Value")
#df_parking <- spread(df_parking, "Place", "Free_spaces")

#Combine the data frames
df_main <- left_join(spread(df_parking, "Place", "Free_spaces"), spread(df_weather, "Element", "Value"))




# round(mean(, na.rm=TRUE)))


# df_parking %>% spread(., "Place", "Free_spaces") %>% .[,-(2:3)] %>%
#   mutate_at(-1, ~ . / 100)# round(mean(, na.rm=TRUE)))
# 
# 
# avg = mean(df_main$Jorenholmen) %>% round(.)
# 
# df_main[,c("Jorenholmen", "Air_temp degC")] %>% 
#   mutate(devi = Jorenholmen - avg) #%>%
#   #mutate(pro = Jorenholmen / avg) %>%
#   ggplot(., aes(x=`Air_temp degC`, y = devi)) +
#   geom_point()

# grid.table(
#   cor(
#     spread(df_parking, "Place", "Free_spaces") %>%
#       filter(hour(DateTime) >= 8) %>%
#       filter(hour(DateTime) <= 18) %>% .[-1],
#     spread(df_weather, "Element", "Value") %>%
#       filter(hour(DateTime) >= 8) %>%
#       filter(hour(DateTime) <= 18) %>% .[-1],
#     use = "complete.obs",
#     method = c("pearson")
#   )     # "kendall", "spearman"))
# )

# plot_ly(df_main, x = ~DateTime) %>%
#   add_lines(y = ~Free_spaces, name = "Free_spaces")
# 
# 
# fig <- fig %>% add_lines(y = ~`Air_temp degC`, name = "Air_temp degC", visible = F)
# fig <- fig %>% layout(
#   updatemenus = list(
#     list(
#       y = 0.8,
#       buttons = list(
#         
#         list(method = "restyle",
#              args = list("line.color", "blue"),
#              label = "Blue"),
#         
#         list(method = "restyle",
#              args = list("line.color", "red"),
#              label = "Red"))
#     )
#   )
# )
# 
# 

