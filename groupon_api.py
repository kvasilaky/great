import urllib2 #needed making web requests
import csv #needed for reading/writing csv files
import sys #not really sure if this is needed or not
import json #needed for handling JSON although not intuitive
import datetime #this allows us to use the current date as a timestampt
import os
import time
import random
random.seed()



cities= list()
f = open('divisionsfull.csv','rU')
try:
    toaster = csv.reader(f)
    for row in toaster:
        cities.append(row)
finally:
    f.close()



for city in cities:
        c= str(city).strip('[\']')
        print "Processing Groupon Data for --" + c
        url='https://api.groupon.com/v2/deals.json?division_id=' + c + '&client_id=bd19a7454e6c582bd8283ba74e5871faa7d8435e'
        response = urllib2.urlopen(url)
        html = response.read()
        data = json.loads(html)
        deals = data["deals"]


        #here writing the json output to a text file without formatting
        pathdump = "./groupondump/"
        fname='groupondump-'+c+'-'+str(datetime.datetime.now())+'.txt'
        f=open(pathdump+fname,'w')
        f.write(str(data))
        f.close()
       

                       

        g = ("./grouponall.csv")
        b = ("./grouponrecent.csv")
        #c = ("groupontest.csv")
        writer = csv.writer(open(g,'a'),dialect='excel')
        writer1 = csv.writer(open(b,'a'),dialect='excel')
        
        for deal in deals:  #some variables weren't quite named correctly
                
                try:
                    Company=str(deal["merchant"]["name"])
                except:
                    Company="NA"
                try:
                    Deal_Description=str(deal["announcementTitle"].encode('ascii', 'ignore'))
                except:
                    Deal_Description='NA'

                try:
                    Phone1=str(deal["options"][0]["redemptionLocations"][0]["phoneNumber"])
                except:
                    Phone1="NA"
                
                try:
                    Phone2=str(deal["options"][0]["redemptionLocations"][1]["phoneNumber"])
                except:
                    Phone2="NA"
                
                Phone=Phone1 +' ' + Phone2

                try:
                    Street=str(deal["options"][0]["redemptionLocations"][0]["streetAddress1"])
                except: 
                    Street="NA"
                
                try:
                    City1=str(deal["options"][0]["redemptionLocations"][0]["city"]) 
                except:
                    City1="NA"

                try:
                    City2=str(deal["options"][0]["redemptionLocations"][1]["city"])  
                except:
                    City2="NA"
                
                try:
                    City3=merchant_city3=str(deal["options"][0]["redemptionLocations"][2]["city"])
                except:
                    City3="NA"

                City=City1 + ' ' + City2 + ' ' + City3

                try:
                    State1=str(deal["options"][0]["redemptionLocations"][0]["state"]) 
                except:
                    State1="NA"
                
                try:
                    State2=str(deal["options"][0]["redemptionLocations"][1]["state"]) 
                except:
                    State2="NA"

                State=State1+ ' '+State2


                try:
                    Zip1=str(deal["options"][0]["redemptionLocations"][0]["postalCode"])
                except:
                    Zip1="NA"

                try:
                    Zip2=str(deal["options"][0]["redemptionLocations"][1]["postalCode"])
                except:
                    Zip2="NA"

                Zip=Zip1+ ' '+Zip2

                try:
                    Value=str(deal["options"][0]["value"]["formattedAmount"])
                except:
                    Value="NA"
                Deal_Value=str(Value).strip('[$]')
                Deal_Value=str(Deal_Value).strip('[C]')
                try: 
                    price=str(deal["options"][0]["price"]["formattedAmount"])
                except:
                    price="NA"

                Price=str(price).strip('[$]')
                Price=str(Price).strip('[C]')

                try:
                    Website=str(deal["merchant"]["websiteUrl"]) 
                except:
                    Website="NA"
                try:
                    Operating_City=str(deal["division"]["name"])
                except:
                    Operating_City="NA"

                try:
                    areas=str(deal["areas"]["id"])
                except:
                    areas="NA"


                Offer_Type='Daily Deal'

                try:
                    C1=str(deal["dealTypes"][0]["id"])
                except:
                    C1="NA"
                try:
                    C2=str(deal["dealTypes"][1]["id"])
                except:
                    C2="NA"

                Category=C1 +' '+C2
                Lead_Source='TS Centralized Lead Gen'
                Competitor_Deal_Source='Groupon'

                try:
                    Previous_Daily_Deal_URL=str(deal["options"][0]["buyUrl"].encode('ascii', 'ignore'))
                except:
                    Previous_Daily_Deal_URL="NA"

                try:
                    Deal_Restrictions= str(deal["finePrint"])
                except:
                    Deal_Restrictions="NA"
                try:
                    id=str(deal["merchant"]["id"])
                except:
                    id="NA"
                try:
                    discount = str(deal["options"][0]["discount"]["formattedAmount"])
                except:
                    discount="NA"
                
                try:
                    date_add=str(deal["startAt"].encode('ascii', 'ignore'))
                except:
                    date_add="NA"
                
                try:
                    date_end=str(deal["endAt"])
                except:
                    date_end="NA"


                try:
                    sold=str(deal["soldQuantity"])
                except:
                    sold="NA"
                                
                try:
                    soldmessage=str(deal["options"][0]["soldQuantity"])                                     
                except NameError:
                    soldmessage='NA'
                try:
                    istipped=str(deal["isTipped"])                               
                except:
                    istipped="NA"

                try:
                    soldout=str(deal["isSoldOut"])
                except:
                    soldout="NA"

                try:
                    tippingpoint=str(deal["tippingPoint"])
                except:
                    tippingpoint="NA"
                try:
                        tippedat=str(deal["tippedAt"].encode('ascii', 'ignore'))                                      
                except:
                        tippedat="NA"
                try:
                    active=str(deal["status"])
                except:
                    active="NA"          
                try:
                    grouponRating = str(deal["grouponRating"])
                except:
                    grouponRating="NA"
                

                   

                writer.writerow((Company,Deal_Description,Phone,Street,City,State,Zip,Deal_Value,Price, Website,Operating_City,Offer_Type, Category,Lead_Source,Competitor_Deal_Source, Previous_Daily_Deal_URL, Deal_Restrictions,id, discount, date_add,date_end, sold, soldmessage,soldout,istipped,tippingpoint,tippedat,grouponRating, areas))
                writer1.writerow((Company,Deal_Description,Phone,Street,City,State,Zip,Deal_Value,Price, Website,Operating_City,Offer_Type, Category,Lead_Source,Competitor_Deal_Source, Previous_Daily_Deal_URL, Deal_Restrictions,id, discount, date_add,date_end, sold, soldmessage,soldout,istipped,tippingpoint,tippedat,grouponRating, areas))
                wait = random.choice(range(1,3))
                time.sleep(wait)
                





