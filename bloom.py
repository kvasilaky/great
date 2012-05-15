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


#pdb.set_trace()
os.chdir('/Users/kathrynvasilaky/Documents/TS/bloom/batch1')
path="/Users/kathrynvasilaky/Documents/TS/bloom/batch1"

#UnicodeEncodeError: 'ascii' codec can't encode character u'\u2022' in position 24: ordinal not in range(128)

c='bloom-'+str(datetime.datetime.now())+'.csv'
c = "bloom.csv"
writer = csv.writer(open(c,'w'),dialect='excel')
#writer.writerow(('title','merchant','price_discount','original_price','purchased', 'discount',  'street', 'phone', 'city', 'directions','link', 'details'))
writer.writerow(('Company','Deal_Description','Location','Google_Maps', 'Deal_Value','Price1','Offer_Type','Lead_Source','Competitor_Deal_Source', 'Previous_Daily_Deal_URL', 'date','Operating_City','infile'))


for infile in glob.glob(os.path.join(path, '*.html')):
#txtFiles = [x for x in os.listdir(path) if x.endswith('html')]
        y=open(infile,'r')
        #y=open('copy.html','r')
        
        yhtml=y.read()
        y.close()
        print "current file is: " + infile
        soup = BeautifulSoup(yhtml)
#        divdeals= soup.findAll("table", { "style" : "margin-bottom: 42px;"})
        divdeals= soup.findAll("div", { "id" : "photosContainer"})

        for dd in divdeals:


            try:
                link = dd.find('a',  href=True)['href'].encode('ascii', 'ignore')
            except:
                link='NA'

            #l= str(link).strip('[\']')
            #linked=link['href']
            #links.append(l)
            web_cnx = urllib.urlopen(link) 
            html = web_cnx.read()
            soup = BeautifulSoup(html)

#Now walk into each deal
            try:
                Location=soup.findAll("td", {"style": "color: #c39e0b; letter-spacing: 1px; padding-bottom: 3px; font: bold italic 14px Georgia, serif;"})[0].contents[0].encode('ascii', 'ignore')
            except:
                Location="NA"

            try:
                Company=soup.findAll("a", {"style": "text-decoration: none; color: #fff; font: bold 18px Helvetica, Arial, sans-serif; text-transform: uppercase; letter-spacing: 1px;"})[0].contents[0].strip('\r\n').encode('ascii', 'ignore')
            except:
                Company='NA'
            try:
                Deal_Description=soup.findAll("meta", {"property": "og:title"})[0]['content'].encode('ascii', 'ignore')
            except:
                Deal_Description='NA'

            #Pull just the href link 
            try:
                Google_Maps=soup.findAll('a', href=re.compile('^http://maps.google.com/maps\?q='))[0]['href'].encode('ascii', 'ignore')
            except:
                Google_Maps='NA'
            

                #Address=Google_Maps.split(',')[0].split(' ')[1:3]
                #City=Google_Maps.split(',')[1].encode('ascii', 'ignore')
                #State=Google_Maps.split(',')[2].split(' ')[1].encode('ascii', 'ignore')
                #Zip=Google_Maps.split(',')[2].split(' ')[2].encode('ascii', 'ignore')

            #try: 
            #Website=soup.findAll("a", {"target": "blank"})[0]['href']
            #except:
            #Website='NA'


            #Address=soup.findAll("div", {"class": "deal_location_address"})[0].contents[0]
            #cstate=soup.findAll("div", {"class": "deal_location_address"})[0].contents[0].contents[1]
            #City=cstate.split(', |  ')[0].strip('\r\n')
            #State=cstate.split(' ')[1]
            #Zip=cstate.split(' ')[2]
            #Phone=soup.findAll("div", {"class": "deal_location_address"})[0].contents[0].contents[3]
            #Website=soup.findAll("div", {"class": "deal_location_address"})[0].contents[8].contents[0]
            try:
                p1=Deal_Description.split('$')[1].encode('ascii', 'ignore')
            except:
                p1='NA'
            try:
                Price1=p1.split(' ')[0].encode('ascii', 'ignore')
            except:
                Price1='NA'
            try:
                Deal_Value=Deal_Description.split('$')[2].split(' ')[0].encode('ascii', 'ignore')
            except:
                Deal_Value='NA'
            try: 
                p2=Deal_Description.split('$')[3].encode('ascii', 'ignore')
            except:
                p2='NA'
            try:
                Price2=p2.split(' ')[0].encode('ascii', 'ignore')
            except:
                Price2='NA'
            try:    
                Value2=Deal_Description.split('$')[4].encode('ascii', 'ignore')
            except:
                Value2='NA'

            Previous_Daily_Deal_URL=link
            Offer_Type='Daily Deal'

            Category='NA'
            Lead_Source='Data Import'
            Competitor_Deal_Source='Bloomspot'
            date='NA'
            Operating_City=link.split('/')[3].encode('ascii', 'ignore')


            data=[Company,Deal_Description,Location, Google_Maps, Deal_Value,Price1,Offer_Type,Lead_Source,Competitor_Deal_Source, Previous_Daily_Deal_URL, date,Operating_City,infile]
            writer.writerow(data)             
            print Company,Deal_Description,Location, Google_Maps,Deal_Value,Price1, Value2, Price2,Offer_Type, infile, date,Operating_City,Lead_Source,Competitor_Deal_Source, Previous_Daily_Deal_URL, link
             
        
        

 #UnicodeEncodeError: 'ascii' codec can't encode character u'\u2022' in position 24: ordinal not in range(128)
 #.encode('ascii', 'ignore'))


