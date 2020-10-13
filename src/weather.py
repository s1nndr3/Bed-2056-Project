"""
	- Web scraper for weather data v. 0.0.1 
	- made by: Sindre Sønvise (sso149@post.uit.no)
	- Created: 13.10.2020
"""

import requests
from datetime import date, datetime, timedelta
from scedule import Schedule
import sys

#Suppress warning for not verifying ssl in request
requests.packages.urllib3.disable_warnings() 

"""
	- A weather scraper using a sceduler
"""
class Weather_scraper():
	def __init__(self, time, file_name = "weather", data_dir = "."):
		#Make a new scedule, start with self.schedule.start()
		self.schedule = Schedule(self.weather_store, *time)

		#The fields we are interested in
		self.observations_fields = ('elementId', 'value', 'unit')

		#Source/name of weather staton and coresponding fealds we want from them
		self.source_stavanger_by = "SN44640"
		self.stavanger_by_elemebts = "air_temperature,sum(precipitation_amount%20PT1H)"
		self.source_sola = "SN44560"
		self.sola_elements = "wind_from_direction,wind_speed"

		#csv file pointer
		self.file_name = file_name
		self.data_dir = data_dir

	"""
		- Parse the right url based on weather staton and elements wanted
	"""
	def weather_url(self, now, source, elements):

		prev = now - timedelta(days=1)
		
		url_base = "https://rim.met.no/api/v1/observations"
		url_source = f"?sources={source}"
		url_time = f"&referenceTime={prev.year}-{prev.month}-{prev.day}T00:00:00Z/{now.year}-{now.month}-{now.day}T00:00:00Z"
		url_elements = f"&elements={elements}&timeResolution=hours"

		return f"{url_base}{url_source}{url_time}{url_elements}"

	"""
		- Get/request the data
		- Return as json
	"""
	def weather_get(self, datetime, source, elements):
		url = self.weather_url(datetime, source, elements)
		#print(url)
		try:
			resp = requests.get(url=url, timeout=10, verify=False)
		except requests.exceptions.Timeout:
			print("Timeout (weather)!!!")
			return None
		except requests.exceptions.RequestException as e:
			print("exception in request:\n", e)
			return None

		return resp.json()

	"""
		- Get the todays date
	"""
	def weather_time(self):
		return datetime.now().date()

	"""
		- Open a new file pointer
	"""
	def weather_new_csv(self):
		fp = open(f"{self.data_dir}/{self.file_name}-{datetime.now().date()-timedelta(days=1)}.csv", "w+")
		fp.write("sourceId,referenceTime,elementId,value,unit\n")
		return fp

	"""
		- Close file pointer
	"""
	def weather_close_file(self):
		self.fp.close()

	"""
		- Acctually write to file
	"""
	def weather_store_observations(self, h):
		for o in h["observations"]:
			self.fp.write(h["sourceId"])
			referenceTime = h["referenceTime"]
			self.fp.write(f",{referenceTime}")
			for of in self.observations_fields:
				v = o[of]
				self.fp.write(f",{v}")
			self.fp.write("\n")

	"""
		- Function to call when an update is desiered
		- note: ment to to not be called more then once a day (will overwrite file)
		- create a new file - do request - insert with feald filter
	"""
	def weather_store(self):
		#New file every day
		self.fp = self.weather_new_csv()

		time = self.weather_time()
		#print(time)
		raw_by = self.weather_get(time, self.source_stavanger_by, self.stavanger_by_elemebts)
		raw_sola = self.weather_get(time, self.source_sola, self.sola_elements)

		#Loop over all hours
		try:
			for i in range(0,23):
				h_by = raw_by["data"][i]
				h_sola = raw_sola["data"][i]

				self.weather_store_observations(h_by)
				self.weather_store_observations(h_sola)
		except:
			print("exception in weather_store:\n", sys.exc_info()[0])

		self.weather_close_file()
		print(f"Weather request and insertion. done: {datetime.now()}, next time: {self.schedule.next_time()}")

def unit_test():
	scedule = (None, None, None, None, None, None)
	w = Weather_scraper(scedule, "weather_unit-test")
	w.weather_store()


if __name__ == "__main__":
	unit_test()