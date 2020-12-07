""" 
	- Parking scraper v. 0.0.2
	- made by: Sindre Sønvise (sso149@post.uit.no)
	- Created: 04.10.20
"""

from datetime import date, datetime, timedelta
import requests
import sys
import os

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
class Parking_scraper():
	def __init__(self, url, fields, temp_dir = ".", perm_dir = ".", prefix = "parking"):
		self.url = url 					#url to scrape
		self.temp_dir = temp_dir		#directory to temporarly store data
		self.perm_dir = perm_dir		#directory to permanantly store data 
		self.prefix = prefix			#neme of storage files
		self.fields = fields			#Fealds to expect in responce json
		self.fp = None					#File pinter to file
		self.new_file()					#Set file self.fp
		self.day = datetime.now().day

	def do(self):
		#Test if it is a new day
		if (self.day != datetime.now().day):
			self.new_day()

		#Do Request
		resp = self.request()

		if not resp: 
			# Didn't get anython from the request, nothing to do
			return

		try:
			for parking in resp:
				try:
					self.store_data(parking)
				except:
					print("exceptin in do loop:\n", sys.exc_info()[0])
		except TypeError as e:
			print("Response was not json !!!\n", e)
			return

	#Request function
	def request(self):
		try:
			resp = requests.get(url=self.url, timeout=10)
		except requests.exceptions.Timeout:
			print("Timeout (parking)!!!")
			return None
		except requests.exceptions.RequestException as e:
			print("exception in request:\n", e)
			return None

		return resp.json()
	
	#Input data in to the csv file
	#Note:  raw must be dict with same field count and names
	#Note2: This function does not catch exceptions, must be done by caller
	def store_data(self, raw):
		for field in self.fields:
			if field == self.fields[0]:
				self.fp.write(raw[field])
			else:
				self.fp.write(f",{raw[field]}")
		self.fp.write("\n")

	#Close file and make link to perm dir
	def close_file(self):
		#Close file pointer
		self.fp.close()
		name = self.fp.name.split("/")[-1]
		try:
			os.link(f"{self.fp.name}", f"{self.perm_dir}/{name}")
			print(f"Successfully made hard link to file {name}")
		except FileExistsError as e:
			print(f"Unable to make link to file {name}", e)

	#Open new file and add header
	def new_file(self):
		#Open new file pointer
		self.fp = open(f"{self.temp_dir}/{self.prefix}-{datetime.now().date()}.csv", "w+")

		#Insert header fealds
		for field in self.fields:
			if field == self.fields[0]:
				self.fp.write(field)
			else:
				self.fp.write(f",{field}")

		self.fp.write("\n")

	def new_day(self):
		print("New day starting -", datetime.now())
		self.close_file()
		self.new_file()
		self.day = datetime.now().day