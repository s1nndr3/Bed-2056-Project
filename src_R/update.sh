#!/bin/bash

dir=$(dirname "$0")
echo $dir
cd $dir

R -e "rmarkdown::render('./parking_vs_weather.rmd')"

mv ./parking_vs_weather.html ../

cd .. 
zip -r data.zip data

