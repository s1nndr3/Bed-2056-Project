#!/bin/bash

R -e "rmarkdown::render('./parking_vs_weather.rmd')"

zip -r ../data.zip ../data/

wget --post-data "" https://aickro.net/update-parking
