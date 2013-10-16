#Creates cohort plots and analysis on digitalgreen.org data

library (plyr)
library (RMySQL)
library (ggplot2)
library (reshape)

###Define Functioons
#count the number of adoptions by person, don't use a date var here
fn.adoptions <- function(data){length(unique(data$adoption_id))}
fn.totaladopt<-function(data){sum(data$user_total_adoptions)}
####################


###Fetch DG Data#######
drv <- dbDriver("MySQL")
con = dbConnect(drv, user="root", dbname="dg")
rs <- dbSendQuery(con, statement = paste(
  "SELECT p.ID as person_id, p.AGE as age,p.DATE_OF_JOINING as join_date, pa.DATE_OF_ADOPTION as adoption_date, pa.ID as adoption_id",
  "FROM PERSON_ADOPT_PRACTICE pa, PERSON p",
  "WHERE p.ID = pa.PERSON_ID "))
data <- fetch(rs, n = -1)   # extract all rows
data <- data[!duplicated(data), ]
#################################

###Format All Dates
data$join_date <- as.Date (data$join_date, "%Y-%m-%d", tz = "EST")
data$adoption_date <- as.Date (data$adoption_date, "%Y-%m-%d", tz = "EST")

y <- format(data$join_date, format = "%Y")
m <- format(data$join_date, format = "%m")
data$user_cohort <- paste (y, m, sep = "-")

####


# calculates total adoptions by user
t <- ddply(data, .(person_id), fn.adoptions)
names (t)[2] <- "user_total_adoptions"
data <- merge (data, t, by = "person_id", all.x = TRUE, all.y = FALSE)
#data$join_date<-0
#data <- data[!duplicated(data), ]
rm(t)

####################
#Create each cohort column
days<-as.integer(Sys.Date()-min(as.Date(data$join_date), na.rm=TRUE))
months<-round((days/30), digits = 0)
days<-months*30
#Mark the month the action=adoption occurred in
data$days_since_signup <- as.integer(data$adoption_date-data$join_date) # Purchase made x number days since signup

y=0
N=1020
while (y < N) { 
  t <- ddply (subset (data, data$days_since_signup >= y & data$days_since_signup < y+30), .(person_id), fn.adoptions)
  names (t)[2] <- paste ("user_revenue_month_", 1 + (y/30), sep='')
  data <- merge (data, t, by = "person_id", all.x = TRUE)
  col <- ncol (data)
  data [,col][is.na (data [,col])] <- 0
  rm (t)
  print ( y <- y+30) 
}

data.bak <- data
data <- data [!duplicated (data$person_id), ]


# THIS CREATES A TABLE OF TOTAL ADOPTIONS BY COHORT (WHERE COHORT IS MONTH JOINED)
start <- which (names(data) == 'user_revenue_month_1')
fn.totaladopt <- function (data) {sum(data[,start])}
#rev by cohort collapse by cohort and gets the averages by month
adopt_by_cohort <- ddply(data, .(user_cohort), fn.totaladopt)
names (adopt_by_cohort)[2] <- "1"



for (i in seq (1, days, by = 1)) {
  fn.totaladopt.i <- function (data){sum(data [,start+i])}
  adopt_by_cohort <- merge (adopt_by_cohort, ddply (data, .(user_cohort), fn.totaladopt.i ), by = "user_cohort", all.x = TRUE)
  names (adopt_by_cohort)[i+2] <- i+1
  rm (fn.totaladopt.i)
}


#Melt
###Reshape long
tpcm <- melt (adopt_by_cohort, variable_name = "month")
#tpcm$value[tpcm$value == 0] <- NA

# Total purchases per month, same problem as above
png (file = paste ("/Users/kathrynvasilaky/Documents/Kentaro/graphs/", format (Sys.time (), "%Y-%m-%d"), "_Total_Adoptions.png", sep = ""), width = 1200, height = 700, res = 100)
ggplot (tpcm, aes (x = month, y = value, group=user_cohort)) + geom_line (aes (color = user_cohort)) + labs (x = "Months Since Joining DG", y = "Total Adoptions Per Month") 
#+ geom_text (aes (label = round (total_adoptions, digits = 2), x = month+.5, y = value))
dev.off()

tpcm$year <- as.Date (tpcm$user_cohort, "%Y", tz = "EST")
#y <- format(tpcm$user_cohort, format = "%Y")
#tpcm$year <- paste (y)


t <- subset(tpcm, tpcm$year == "2009-09-19")
# Total purchases per month, same problem as above
png (file = paste ("/Users/kathrynvasilaky/Documents/Kentaro/graphs/", format (Sys.time (), "%Y-%m-%d"), "_Total_Adoptions09.png", sep = ""), width = 1200, height = 700, res = 100)
ggplot (t, aes (x = month, y = value, group=user_cohort)) + geom_line (aes (color = user_cohort)) + labs (x = "Months Since Joining DG", y = "Total Adoptions Per Month") 
#+ geom_text (aes (label = round (total_adoptions, digits = 2), x = month+.5, y = value))
dev.off()

t <- subset(tpcm, tpcm$year == "2010-09-19")
# Total purchases per month, same problem as above
png (file = paste ("/Users/kathrynvasilaky/Documents/Kentaro/graphs/", format (Sys.time (), "%Y-%m-%d"), "_Total_Adoptions10.png", sep = ""), width = 1200, height = 700, res = 100)
ggplot (t, aes (x = month, y = value, group=user_cohort)) + geom_line (aes (color = user_cohort)) + labs (x = "Months Since Joining DG", y = "Total Adoptions Per Month") 
#+ geom_text (aes (label = round (total_adoptions, digits = 2), x = month+.5, y = value))
dev.off()

t <- subset(tpcm, tpcm$year == "2011-09-19")
# Total purchases per month, same problem as above
png (file = paste ("/Users/kathrynvasilaky/Documents/Kentaro/graphs/", format (Sys.time (), "%Y-%m-%d"), "_Total_Adoptions11.png", sep = ""), width = 1200, height = 700, res = 100)
ggplot (t, aes (x = month, y = value, group=user_cohort)) + geom_line (aes (color = user_cohort)) + labs (x = "Months Since Joining DG", y = "Total Adoptions Per Month") 
#+ geom_text (aes (label = round (total_adoptions, digits = 2), x = month+.5, y = value))
dev.off()

t <- subset(tpcm, tpcm$year == "2012-09-19")
# Total purchases per month, same problem as above
png (file = paste ("/Users/kathrynvasilaky/Documents/Kentaro/graphs/", format (Sys.time (), "%Y-%m-%d"), "_Total_Adoptions12.png", sep = ""), width = 1200, height = 700, res = 100)
ggplot (t, aes (x = month, y = value, group=user_cohort)) + geom_line (aes (color = user_cohort)) + labs (x = "Months Since Joining DG", y = "Total Adoptions Per Month") 
#+ geom_text (aes (label = round (total_adoptions, digits = 2), x = month+.5, y = value))
dev.off()
