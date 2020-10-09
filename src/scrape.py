""" 
	- Web scraper v. 0.0.1 
	- made by: Sindre Sønvise (sso149@post.uit.no)
	- Created: 04.10.20
"""

from datetime import date, datetime, timedelta
from scedule import Schedule
from string_part import str_partition
import requests
import sys

"""
	- Web scraper
	- Only for use with json respince
	- Requierd fealds:
		- url: The url to take a get request from
		- fields: tupe of the fealds in each json entry
		- time: tupe of the scedule, (Year, Month, Day, Hour, Minute, Second)
			- example1: (None, None, None, 5, None) will run do every 5 minute
	- Start with: self.schedule.start()
"""
class Web_scraper():
	def __init__(self, url, fields, time, data_dir = ".", file_name = "data"):
		self.url = url 					#url to scrape
		self.data_dir = data_dir		#directory to store data
		self.file_name = file_name		#neme of storage files
		self.fields = fields			#Fealds to expect in responce json
		self.fp = None					#File pinter to file
		self.new_file()					#Set file self.fp
		self.schedule = Schedule(self.do, *time)	#Make a new scedule, start with self.schedule.start()

	def do(self):

		resp = self.request()

		if not resp: 
			# Didn't get anython from the request, nothing to do
			return

		try:
			for parking in resp:
				try:
					self.input_data(parking)
				except:
					print("exceptin in do loop:\n", sys.exc_info()[0])
		except TypeError as e:
			print("Response was not json !!!\n", e)

	#Request function
	def request(self):
		try:
			resp = requests.get(url=self.url, timeout=10)
		except requests.exceptions.Timeout:
			print("Timeout !!!")
			return None
		except requests.exceptions.RequestException as e:
			print("exception in request:\n", e)
			return None

		return resp.json()
	
	#Input data in to the csv file
	#Note:  raw must be dict with same field count and names
	#Note2: This function does not catch exceptions, must be done by caller
	def input_data(self, raw):
		for field in self.fields:
			if field == self.fields[0]:
				self.fp.write(raw[field])
			else:
				self.fp.write(f",{raw[field]}")
		self.fp.write("\n")

	def close_file(self):
		#Close file pointer
		self.fp.close()

	def new_file(self):
		#Open new file pointer
		self.fp = open(f"{self.data_dir}/{self.file_name}-{datetime.now().date()}.csv", "w+")

		#Insert header fealds
		for field in self.fields:
			if field == self.fields[0]:
				self.fp.write(field)
			else:
				self.fp.write(f",{field}")

		self.fp.write("\n")

	def new_day(self):
		self.close_file()
		self.new_file()

	
def main():
	url = "https://opencom.no/dataset/36ceda99-bbc3-4909-bc52-b05a6d634b3f/resource/d1bdc6eb-9b49-4f24-89c2-ab9f5ce2acce/download/parking.json"
	scedule = (None, None, None, None, 4, None)
	fields = ("Dato", "Klokkeslett", "Sted", "Latitude", "Longitude", "Antall_ledige_plasser")
	data_dir = "./temp_data"
	scraper = Web_scraper(url, fields, scedule, data_dir)
	scraper.do()

if __name__ == "__main__":
	main()