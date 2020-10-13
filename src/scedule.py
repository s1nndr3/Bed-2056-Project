""" Task scheduler v. 0.0.1
	- By: Sindre Sønvisen, sindre_s98@hotmail.com
	- Created: 09.10.20
"""

from datetime import date, datetime, timedelta
import time

class Schedule():
	def __init__(self, func, year = None, month = None, day = None, hour = None, minut = None, second = None):
		self.start_date = date.today().strftime("%d-%m-%Y") 	#date when started
		self.func = func

		self.second = second if second else 60				# condition for the secound
		self.minut = minut if minut else 60 if hour or day or month or year else -1	# condition for the minut
		self.hour = hour if hour else 24 if day or month or year else -1		# condition for the hour
		
		self.day = day if day else 32 if month or year else -1		# List of days to execute (if None every day)
		self.month = month if month else 13 if year else -1
		self.year = year if year else -1

	def time_sleep(self):
		t = datetime(*self.next_time())
		return (t - datetime.now()).total_seconds()

	def next_time(self):
		t = datetime(*self.last_time())
		if self.second > 0 and self.second < 60:
			t += timedelta(seconds=self.second)
		if self.minut > 0 and self.minut < 60:
			t += timedelta(minutes=self.minut)
		if self.hour > 0 and self.hour < 24:
			t += timedelta(hours=self.hour)
		if self.day > 0 and self.day < 32:
			t += timedelta(days=self.day)
		if self.month > 0 and self.month < 13:
			t += timedelta(month=self.month)
		if self.year > 0:
			t += timedelta(year=self.year)
			
		return (t.year, t.month, t.day, t.hour, t.minute, t.second)

	def last_time(self):
		t = datetime.now()
		return (t.year - (t.year % self.year), t.month - (t.month % self.month), t.day - (t.day % self.day), t.hour - (t.hour % self.hour), t.minute - (t.minute % self.minut), t.second - (t.second % self.second))

	def start(self):
		if (not self.second and not self.minut and not self.hour):
			raise AssertionError("Execution schedule not set!!!")

		print(f"Starting schedule every ..., first is {self.next_time()}")

		self.loop()

	def stop(self):
		pass

	def schedule(self):
		time.sleep(self.time_sleep())
		self.func()
		return True

	def loop(self):
		while(self.schedule()):
			pass

def unit_test():
	pass

if __name__ == "__main__":
	unit_test()