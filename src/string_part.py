""" 
	- Sting partition
	- made by: Sindre Sønvise (sso149@post.uit.no)
	- Created: 04.10.20
"""

def str_partition(str, start = None, end = None):
	ret = str

	if (start != None):
		try:
			ret = ret.split(start,1)[1]
		except IndexError:
			return None

	if (end != None):
		try:
			rc = ret.split(end,1)
			if len(rc) <= 1 and start == None:
				return None
			else:
				ret = rc[0]
		except IndexError:
			return None
	return ret