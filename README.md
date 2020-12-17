# Bed-2056-Project 2020  
by Sindre Sønvisen  
e-mail sso149@post.uit.no  
live/updated site at <https://aickro.net/parking>

## src_python/:  
Scraper for parking and weather in stavanger.  
Srart with: "python3 scrape.py" Note: must be called from within src_python (contains relative paths).
Stop with Ctrl-c
The data is stored in ./data
While it runs the files is created and bult in ./src_python/tenp_data 
Important!!!: if stopped in the middle of the day; this will overwrite the data in temp_data alreaddy collected for the day.

## src_R/:
Data wrangling.
Knit parking_vs_weather.rmd with RStudio or if on linux "src_R/update.sh" will knit and move the html file to main dir and copy the data to a zip file.
Code contain relative paths so call from within src_R.

## data/: 
Data collected as of 17.12.2020