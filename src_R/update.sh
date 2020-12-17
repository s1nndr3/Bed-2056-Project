#!/bin/bash

R -e "rmarkdown::render('./parking_vs_weather.rmd')"

mv ./parking_vs_weather.html ../

cd .. 
zip -r data.zip data
