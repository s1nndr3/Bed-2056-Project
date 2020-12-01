library(tidyverse)
library(lubridate)

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

#Rename
names(df_parking) <- c("Date", "Time", "Place", "Free_spaces")

#Set datetime
df_parking <- df_parking %>% 
  mutate(DateTime = as.POSIXct(paste(Date, Time, sep = " "), format="%d.%m.%Y %H:%M")) %>%
  .[, c("DateTime", "Place", "Free_spaces")]

#Modify "Antall_ledige_plasser"
df_parking <- df_parking %>%
  mutate(Free_spaces = ifelse(Free_spaces == "Fullt", "0", Free_spaces)) %>%
  mutate(Free_spaces = as.numeric(Free_spaces))

#Remove duplicate rows
df_parking <- unique(df_parking)
table(df_parking$DateTime)


#CAlculate average of each hour
df_parking <- df_parking %>%
  mutate(DateTime = floor_date(DateTime, "hour")) %>% 
  group_by(DateTime, Place) %>% 
  summarise(avg = mean(Free_spaces)) %>% 
  mutate(avg = round(avg))

#print(df_parking, n=207)

