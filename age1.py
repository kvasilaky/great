import datetime as dt
import sys


if __name__ == '__main__':
    # do some things

	print 'Number of arguments:', len(sys.argv), 'arguments.'
	num_days = int(sys.argv[1])
	now = dt.datetime.now()
	print(now + dt.timedelta(days=num_days))
	print("I was called from the command-line!")
