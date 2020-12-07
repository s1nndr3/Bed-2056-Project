#!/bin/bash

export RSTUDIO_PANDOC=/usr/lib/rstudio/bin/pandoc 
R -e "rmarkdown::render('./parking_vs_weather.rmd')"
