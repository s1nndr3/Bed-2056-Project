""" 
	- Web scraper starter v. 0.0.1 
	- made by: Sindre Sønvise (sso149@post.uit.no)
	- Created: 13.10.20
"""

from weather import Weather_scraper
from parking import Parking_scraper
import threading 
from scedule import Schedule

## Start function
def start():
	#Dir to store data
	temp_data_dir = "./temp_data"
	perm_data_parking_dir = "../data/parking"
	perm_data_weather_dir = "../data/weather"

	url = "https://opencom.no/dataset/36ceda99-bbc3-4909-bc52-b05a6d634b3f/resource/d1bdc6eb-9b49-4f24-89c2-ab9f5ce2acce/download/parking.json"
	parking_scedule_time = (None, None, None, None, 4, None)
	fields = ("Dato", "Klokkeslett", "Sted", "Latitude", "Longitude", "Antall_ledige_plasser")
	parking_scr = Parking_scraper(url, fields, temp_dir=temp_data_dir, perm_dir=perm_data_parking_dir)
	parking_schedule = Schedule(parking_scr.do, *parking_scedule_time)

	weather_scedule_time = (None, None, 1, (5,), None, None)
	weather_scr = Weather_scraper(data_dir=perm_data_weather_dir)
	weather_schedule = Schedule(weather_scr.weather_store, *weather_scedule_time)

	print("Starting weather scraper")
	weather_thread = threading.Thread(target=weather_schedule.start, args=())
	weather_thread.daemon = True
	weather_thread.start()

	print("Starting parking scraper")
	parking_schedule.start()

	print("Shutdown")
	weather_thread.join()

	return

if __name__ == "__main__":
	start()