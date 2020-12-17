#!/bin/bash

R -e "rmarkdown::render('./parking_vs_weather.rmd')"

zip -r ../data.zip ../data/

mv ./parking_vs_weather.html ../

wget --post-data "" https://aickro.net/update-parking
