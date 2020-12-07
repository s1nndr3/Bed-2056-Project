""" Task scheduler v. 0.0.1
	- By: Sindre Sønvisen, sindre_s98@hotmail.com
	- Created: 09.10.20
"""

from datetime import date, datetime, timedelta
import time
import sys

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

		self.all = ((self.second, "second", 60), (self.minut, "minute", 60), (self.hour, "hour", 24), (self.day, "day", 32), (self.month, "month", 13), (self.year, "year", 5000))

	def time_sleep(self):
		t = datetime(*self.next_time())
		return (t - datetime.now()).total_seconds()

	def next_in_tuple(self, time_tuple, t):
		now = getattr(datetime.now(), t)
		for x in time_tuple:
			if (x > now):
				#print(x)
				return x, True
		#else return first next sucle
		return time_tuple[0], False

	def next_time(self):
		t = datetime(*self.last_time())

		for entry in self.all:
			if isinstance(entry[0], tuple):
				n, con = self.next_in_tuple(entry[0], entry[1])
				t = t.replace(**{entry[1]: n})
				if con:
					break
			elif entry[0] > 0 and entry[0] < entry[2]:
				if (entry[1] != "year" and entry[1] != "month"):
					param_name = f"{entry[1]}s"
					t += timedelta(**{param_name: entry[0]})
				elif (entry[1] == "month"):
					t = t.replace(month=(t.month + self.month))
				elif (entry[1] == "year"):
					t = t.replace(year=(t.year + self.year))

		return (t.year, t.month, t.day, t.hour, t.minute, t.second)

	def last_time(self):
		t = datetime.now()
		return (t.year if isinstance(self.year, tuple) else t.year - (t.year % self.year), 
		t.month if isinstance(self.month, tuple) else (t.month - (t.month % self.month) if (t.month - (t.month % self.month) != 0) else 1), 
		t.day if isinstance(self.day, tuple) else (t.day - (t.day % self.day) if  (t.day - (t.day % self.day) != 0) else 1), 
		t.hour if isinstance(self.hour, tuple) else t.hour - (t.hour % self.hour), 
		t.minute if isinstance(self.minut, tuple) else t.minute - (t.minute % self.minut), 
		t.second if isinstance(self.second, tuple) else t.second - (t.second % self.second))

	def start(self):
		if (not self.second and not self.minut and not self.hour):
			raise AssertionError("Execution schedule not set!!!")

		print(f"Starting schedule every ..., first is {self.next_time()}")

		self.loop()

	def stop(self):
		pass

	def schedule(self):
		time.sleep(self.time_sleep())
		try:
			self.func()
		except:
			print("Except in provided function not handled...\nError:", sys.exc_info()[0])
			
		return True

	def loop(self):
		while(self.schedule()):
			print(f"Function \"{self.func.__name__}\" done: {datetime.now()}, next time: {self.next_time()}")

class unit_test():
	def __init__(self):
		scedule = (None, None, None, None, (3,6,9,13,16,19,22,28,36,40,44,52,59), (3,8,20, 34, 42, 59))
		self.s_test = Schedule(self.test, *scedule)
		self.s_test.start()

	def test(self):
		print(f"test: {datetime.now()}, next time = {self.s_test.next_time()}")
		return


if __name__ == "__main__":
	unit_test()