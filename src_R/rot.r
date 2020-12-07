

#Average air temperature each day
df_weather[, c("DateTime", "Air_temp degC")] %>%
  mutate(DateTime = floor_date(DateTime, "day")) %>% 
  group_by(DateTime) %>% 
  summarise(`Air_temp degC` = mean(`Air_temp degC`)) %>%
  
  ggplot(., aes(x=DateTime, y=`Air_temp degC`)) +
  geom_point() +
  geom_line() +
  #scale_color_manual(values=Colors) +
  ggtitle("Air temp") +
  ylab("Temp") + xlab("DateTime")

#Sum of downfall each day
df_weather[, c("DateTime", "Precipitation mm")] %>%
  replace(., is.na(.), 0) %>% #Replace if na (none) value
  mutate(DateTime = floor_date(DateTime, "day")) %>% 
  group_by(DateTime) %>% 
  summarise(`Precipitation mm` = sum(`Precipitation mm`)) %>%
  #print(., n=59)
  ggplot(., aes(x=DateTime, y=`Precipitation mm`)) +
  geom_point() +
  geom_line() +
  #scale_color_manual(values=Colors) +
  ggtitle("Precipitation") +
  ylab("Precipitation") + xlab("DateTime")

#Wind speed
df_weather[, c("DateTime", "wind_speed m/s")] %>%
  #replace(., is.na(.), 0) %>% #Replace if na (none) value
  mutate(DateTime = floor_date(DateTime, "day")) %>% 
  group_by(DateTime) %>% 
  summarise(`wind_speed m/s` = mean(`wind_speed m/s`)) %>%
  #print(., n=59)
  ggplot(., aes(x=DateTime, y=`wind_speed m/s`)) +
  geom_point() +
  geom_line() +
  #scale_color_manual(values=Colors) +
  ggtitle("wind_speed m/s") +
  ylab("wind_speed m/s") + xlab("DateTime")

#Free parking
ggplotly( df_parking %>% 
            #filter(., Place=="Forum") %>%
            ggplot(., aes(x=DateTime, y=avg, color=Place)) +
            #geom_point() +
            geom_line() +
            #scale_color_manual(values=Colors) +
            ggtitle("Free parking spaces") +
            ylab("Spaces") + xlab("DateTime") 
)


df_main %>%
  filter(hour(DateTime) >= 8) %>%
  filter(hour(DateTime) <= 18) %>%
  filter(Forum < 500) %>%
  ggplot(., aes(x=`Air_temp degC`, y=Forum)) +
  geom_point() +
  geom_smooth(method='lm', formula= y~x) +
  #ylim(0, 550) +
  ggtitle("test") +
  ylab("Free_spaces") + xlab("Temp")

df_main %>%
  filter(hour(DateTime) >= 8) %>%
  filter(hour(DateTime) <= 18) %>%
  
  ggplot(., aes(x=`Precipitation mm`, y=Jorenholmen)) +
  geom_point() +
  geom_smooth(method='lm', formula= y~x) +
  #ylim(0, 550) +
  ggtitle("test") +
  ylab("Free_spaces") + xlab("Precipitation")

df_main %>%
  filter(hour(DateTime) >= 8) %>%
  filter(hour(DateTime) <= 18) %>%
  
  ggplot(., aes(x=`wind_speed m/s`, y=Jorenholmen)) +
  geom_point() +
  geom_smooth(method='lm', formula= y~x) +
  #ylim(0, 550) +
  ggtitle("test") +
  ylab("Free_spaces") + xlab("wind_speed")









ggplotly( 
  df_main %>%
    #filter(., Place=="Jorenholmen") %>%
    ggplot(., aes(x=DateTime, color=Place)) +
    geom_line( aes(y=Free_spaces)) + 
    #geom_line( aes(y=`Air_temp degC` * 10)) +
    geom_line( aes(y=`Precipitation mm` * 10)) +
    #geom_line( aes(y=`wind_speed m/s` * 10)) +
    
    ylim(0, 550) +
    ggtitle("test") +
    ylab("Free_spaces") + xlab("temp")
)


plot_ly(df_main, x = ~DateTime) %>%
  add_lines(y = ~Free_spaces, name = "Free_spaces")
fig <- fig %>% add_lines(y = ~`Air_temp degC`, name = "Air_temp degC", visible = F)
fig <- fig %>% layout(
  updatemenus = list(
    list(
      y = 0.8,
      buttons = list(
        
        list(method = "restyle",
             args = list("line.color", "blue"),
             label = "Blue"),
        
        list(method = "restyle",
             args = list("line.color", "red"),
             label = "Red"))
    )
  )
)
