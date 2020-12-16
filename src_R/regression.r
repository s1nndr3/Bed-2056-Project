library(tidyverse)
library(lubridate)
library(plotly)
library(dplyr)

make_regression <- function(data, name){
  Air_temp_fig <- na.omit(data) %>%  mutate(X = get(name)) %>%
    plot_ly(x = ~X) %>% 
    add_markers(y = ~Siddis, name = "Siddis", type = "scatter") %>% 
    add_trace(y = ~fitted(lm(Siddis ~ X)), name = "Siddis Trace", type = "scatter", mode = "line") %>% 
    add_markers(y = ~Forum, name = "Forum", visible = F) %>%
    add_trace(y = ~fitted(lm(Forum ~ X)), name = "Forum Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~Jernbanen, name = "Jernbanen", visible = F) %>%
    add_trace(y = ~fitted(lm(Jernbanen ~ X)), name = "Jernbanen Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~Jorenholmen, name = "Jorenholmen", visible = F) %>%
    add_trace(y = ~fitted(lm(Jorenholmen ~ X)), name = "Jorenholmen Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~Kyrre, name = "Kyrre", visible = F) %>%
    add_trace(y = ~fitted(lm(Kyrre ~ X)), name = "Kyrre Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~Parketten, name = "Parketten", visible = F) %>%
    add_trace(y = ~fitted(lm(Parketten ~ X)), name = "Parketten Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~Posten, name = "Posten", visible = F) %>%
    add_trace(y = ~fitted(lm(Posten ~ X)), name = "Posten Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~`St Olav`, name = "St Olav", visible = F) %>%
    add_trace(y = ~fitted(lm(`St Olav` ~ X)), name = "St Olav Trace", type = "scatter", mode = "line", visible = F) %>% 
    add_markers(y = ~Valberget, name = "Valberget", visible = F) %>%
    add_trace(y = ~fitted(lm(Valberget ~ X)), name = "Valberget Trace", type = "scatter", mode = "line", visible = F) %>%
    layout(
      title = (list(text = paste("Parking vs", name), x = 0.1)),
      xaxis = list(title = name),
      yaxis = list(title = "Available parking spaces"),
      updatemenus = list(
        list(
          y = 1,
          x = 0,
          buttons = list(
            list(method = "restyle",
                 args = list("visible", list(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Siddis"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Forum"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Jernbanen"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Jorenholmen"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Kyrre"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Parketten"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE)),
                 label = "Posten"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE)),
                 label = "St Olav"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE)),
                 label = "Valberget"),
            
            list(method = "restyle",
                 args = list("visible", list(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)),
                 label = "Only scatter points"),
            
            list(method = "restyle",
                 args = list("visible", list(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE)),
                 label = "Only regression lines"),
            
            list(method = "restyle",
                 args = list("visible", list(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)),
                 label = "All")
          )
        )
      )
    )
  return(Air_temp_fig)
}
