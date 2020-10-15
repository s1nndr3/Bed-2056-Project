""" 
	- Web scraper starter v. 0.0.1 
	- made by: Sindre Sønvise (sso149@post.uit.no)
	- Created: 13.10.20
"""

from weather import Weather_scraper
from parking import Parking_scraper
import threading


def start():
	#Dir to store data
	data_dir = "./temp_data"

	url = "https://opencom.no/dataset/36ceda99-bbc3-4909-bc52-b05a6d634b3f/resource/d1bdc6eb-9b49-4f24-89c2-ab9f5ce2acce/download/parking.json"
	parking_scedule = (None, None, None, None, 4, None)
	fields = ("Dato", "Klokkeslett", "Sted", "Latitude", "Longitude", "Antall_ledige_plasser")
	parking_scr = Parking_scraper(url, fields, parking_scedule, data_dir)

	Weather_scedule = (None, None, 1, (5,), None, None)
	Weather_scr = Weather_scraper(Weather_scedule, data_dir=data_dir)

	print("Starting weather scraper")
	Weather_thread = threading.Thread(target=Weather_scr.schedule.start, args=())
	Weather_thread.daemon = True
	Weather_thread.start()

	print("Starting parking scraper")
	parking_scr.schedule.start()

	print("Shutdown")
	Weather_thread.join()

	return

if __name__ == "__main__":
	start()