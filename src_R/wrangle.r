# 
library(tidyverse)

import_data <- function(loc, prefix, felds){
  df <- data.frame(matrix(ncol=length(felds), nrow = 0))
  names(df) <- felds
  
  files = list.files(path=loc, pattern=prefix, full.names=TRUE)
  for (file in files){
    new <- read.csv(file)
    df <- rbind(df, new)
  }
  return(df)
}

weather_prefix <- "weather"
weather_felds <- c("sourceId", "referenceTime", "elementId", "value", "unit")

parking_prefix <- "parking"
parking_felds <- c("date", "time", "place", "latitude", "longitude", "available_parking_spaces")

loc <- "~/Documents/UIT/Computer science Master/Bed-2056/Bed-2056-Project/data"
typeof(loc)

weather_df <- import_data(loc, weather_prefix, weather_felds)
parking_df <- import_data(loc, parking_prefix, parking_felds)

test <- split(parking_df, parking_df$Sted)
head(test)

helper_plot <- function(data){
  
  Colors = c(RColorBrewer::brewer.pal(name="Dark2", n = 8), RColorBrewer::brewer.pal(name="Paired", n = 8))
  
  #For loop over the list provided
  for (i in 1:length(data)){
    
    df <- data[[i]] %>% dplyr::mutate(., Klokkeslett = as.POSIXct(.$Klokkeslett,format="%H:%M"), 
                                      Antall_ledige_plasser = as.numeric(.$Antall_ledige_plasser))  %>%
      dplyr::mutate(., hour = as.numeric(format(.$Klokkeslett, "%H")))
    #print((head(df)))

    
    t <- aggregate(x = df$Antall_ledige_plasser,                # Specify data column
              by = list(df$hour),              # Specify group indicator
              FUN = mean) 
    
    
    print((head(t)))
    
    #Create plot
    plot <- df %>% 
      ggplot(.,aes(x=hour , y=Antall_ledige_plasser, color=Dato)) + 
      geom_point() +
      geom_line() +
      scale_color_manual(values=Colors) +
      ggtitle("Title") +
      ylab("Antall_ledige_plasser") + xlab("Time")
    #Show plot
    print(plot)
  }
}

helper_plot(test)
