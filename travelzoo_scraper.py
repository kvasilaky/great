import urllib2 #needed making web requests
import csv #needed for reading/writing csv files
import sys #not really sure if this is needed or not
import json #needed for handling JSON although not intuitive
import datetime #this allows us to use the current date as a timestampt
import os
#import pdb;pdb.set_trace()
import time
import random
random.seed()
# import your regular expression library, used to match all product page links
import re
import urllib
from BeautifulSoup import BeautifulSoup, SoupStrainer
import glob
import pdb



os.chdir('/Users/kathrynvasilaky/Documents/TS/tzoo/travelzoo20')
path="/Users/kathrynvasilaky/Documents/TS/tzoo/travelzoo20/"
links=list()

#for one file
#infilename ='test.html'
#f = open(infilename,'r')
#html = f.read()
#f.close()
#soup = BeautifulSoup(html)


#c='tzoo-'+str(datetime.datetime.now())+'.csv'
c='tzoo.csv'
writer = csv.writer(open(c,'a'),dialect='excel')
writer.writerow(('Company','Deal_Description','Phone','Street','City','State','Zip','Deal_Value','Price', 'Website','Offer_Type', 'Category','Lead_Source','Competitor_Deal_Source', 'Previous_Daily_Deal_URL','Date_Start'))

for infile in glob.glob(os.path.join(path, '*.html')):
#txtFiles = [x for x in os.listdir(path) if x.endswith('html')]
	y=open(infile,'r')
	yhtml=y.read()
	y.close()
	print "current file is: " + infile
	soup = BeautifulSoup(yhtml)
	divdeals= soup.findAll("tr", { "class" : "top20disp-row row0"})
	str=infile
	re.split('; |, ',str)
	date=str.split('/')[6].strip('-tzoo')
	Date_Start=date.strip('.html')
	for dd in divdeals:
		try:
			Company = dd.small.contents[0]
		except:
			Company='NA'
		Company=re.sub('&amp', '', Company).encode('ascii', 'ignore')
		try:
			Deal_Description=dd.a.contents[0]
		except:
			Deal_Description-''
		Deal_Description=re.sub('&raquo;', '', Deal_Description).encode('ascii', 'ignore')
		Deal_Description=re.sub('&amp', '', Deal_Description).encode('ascii', 'ignore')

		Phone=''
		Street=''
		City=''
		State=''
		Zip=''
		Deal_Value=''

			
		d = dd.h2.contents[0]
		d1= d.strip('$')
		Price= d1.strip('&amp; up')
		Website=''
		Offer_Type='Daily Deal'
		Category='Travel - Getaway'
		Lead_Source='TS Centralized Lead Gen'
		Competitor_Deal_Source='TravelZooTop20'
		try:	
			Previous_Daily_Deal_URL = dd.find('a',  href=True)['href']
		except: 
			Previous_Daily_Deal_URL=''

		writer.writerow((Company,Deal_Description,Phone,Street,City,State,Zip,Deal_Value,Price, Website,Offer_Type, Category,Lead_Source,Competitor_Deal_Source, Previous_Daily_Deal_URL, Date_Start))

