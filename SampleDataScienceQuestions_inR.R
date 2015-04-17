'''
Proper header: Some Fun DS Questions
Purpose: This file lists out some practice questions now that you know R!!
Data set it calls: Simulated data within script
Variables that I created: outliers, tweets, chains, regressions
Timestamp: April 17, 2015
GitHub: kathrynthegreat 

Questions
1) Given a list of numbers, can you return the outliers?

2) Given a list of tweets, determine the top 10 most used
hashtags.

3) Code up the Ruben Gelman Statistic function 

4) Write a pairwise bootstrap in R
'''
getwd()

setwd("/Users/kathrynvasilaky/SkyDrive/R/NYCData")
data <- read.csv("/Users/kathrynvasilaky/SkyDrive/R/NYCData/data.csv")
path <- getwd() #"/Users/kathrynvasilaky/SkyDrive/R/NYCData"  
path <- paste(path,'/', sep='')


######################################################
#Given a list of numbers, can you return the outliers?
######################################################

#data<-read.csv()

#generate a list of numbers
list<-c(rnorm(20,5,20))
data<-as.data.frame(list)
names(data)
#rename first column
names(data)[1]<-'X'
#double check the mean
mean <- mean(data$X)
sd <- sd(data$X)
#3ds of the list is: 3*sd
#we want to subset the data such that any observation is within 3sd
data2<-subset(data, data$X < mean+2*sd )

##################################################################
#Given a list of tweets, determine the top 10 most used hashtags.
##################################################################

tweets<-c('yolo#peanuts', 'wow#ballet', 'ballgame#peanuts', 'ouch#data', 'rooneydoesitall#peanuts')

strsplit(tweets, "#")
hashtag<-strsplit(tweets, "#")
typeof(hashtag)
hashtag[[1]][2]
newhashlists=NULL

for (i in 1:length(tweets) ){
    print(hashtag[[i]][2])
    newhashlists[i]<-hashtag[[i]][2]
}

newhashlists
library(plyr)
newhashlists<-as.data.frame(newhashlists)
typeof(newhashlists)
names(newhashlists)[1]<-'hashes'

grouped_hashlists <- as.data.frame(count(newhashlists, c('hashes')) )
#ddply(newhashlists, .(hashes), function(df)c(Count = length(newhashlists$hashes))
#grouped_hashlists <- ddply(newhashlists, .(hashes), c(count))
#now i want the top ten
grouped_hashlists$n <- 1:nrow(grouped_hashlists)

topten <- subset(grouped_hashlists, n<11)
topten


#Simple if/else statement 
for (i in 1:10) {
  if (i<6) {
    print('katya') 
  } 
  else {
    print('bob')
  }
}



#sample from a list of 100 elements
data<- rnorm(100,5,100)
sample(data, 2)




############################################
#Code up the Ruben Gelman Statistic function
############################################

# Within chain variance
## Create data of 3 chains, 10 long

#arguments (n, k)
#amount of data
n<-10
#number of chains
k<-3

#data setup, i'll pretend the data exist
c<-as.data.frame(c(1:n))
names(c)[1]<-'one'
c$two<-seq(0, 90, 10)
c$three<-seq(5, 50, 5)
  
var1<-(sd(c$one))^2
var2<-(sd(c$two))^2
var3<-(sd(c$three))^2

#within variance is the average variance for these 3 chains over this period
W<-sum(var1, var2, var3)/k #this is stupid

#between variance
 
#i will loop this later
 mean1<-mean(c$one)
 mean2<-mean(c$two)
 mean3<-mean(c$three)

#between variance is the variance across those 3 means
B<-sum(mean1, mean2, mean3)/k

#Ruben Gelman Stat is weighted sum of 
RG<-(1-(1/n))*W + (1/n)*W
RG

#i'll loop this now
for (i in names(c)) {
  #print( c[[i]] ) 
  print var$i 
  #( (sd(c[[i]]))^2 )
}


#now let's start the function 
function.name <- function(arguments) {
  purpose of function 
  i.e. computations involving the arguments
}






#n observations, k chains
var = NULL
mean = NULL
#arguments (n, k)
#amount of data
n<-10
#number of chains
k<-3

#data setup, i'll pretend the data exist
c<-as.data.frame(c(1:n))
names(c)[1]<-'one'
c$two<-seq(0, 90, 10)
c$three<-seq(5, 50, 5)

data <- c
RG<- function(n,k){
  
  for (i in 1:n) {
    var[i] <- sd(data[[i]])^2 
    print(var[i])
    top <- top + var[i]
  }  
  W <-top/k
  
  for (i in 1:n) {
    mean[i] <- mean(data[[i]]) 
    print(mean[i])
    mean <- mean + var[i]
  }  
  B <-mean/k
  
  #compute the ruben gelman statistic
  RG<-(1-(1/n))*W + (1/n)*W
}


################################
#Write a pairwise bootstrap in R
################################

X <- rnorm(100,5,5)
Beta <- 2
epsilon <- rnorm(10,0,1)
Y <- Beta*X + epsilon

fit <- lm(Y ~ X)
summary(fit)
coefficients(fit) # model coefficients
confint(fit, level=0.95) # CIs for model parameters 
fitted(fit) # predicted values
residuals(fit) # residuals
anova(fit) # anova table 
vcov(fit) # covariance matrix for model parameters 
influence(fit) # regression diagnostics

#Bootstrap 
sim <- 1000
Xprime <- NULL
Yprime <- NULL
fitprime <- NULL
betaprime <- NULL

for (i in 1:sim) {
  Xprime <- sample(X , 50)
  Yprime <- sample(Y , 50)  
  fitprime <- lm(Yprime ~ Xprime)
  betaprime[i] <- fitprime[[1]][1]
}

hist(betaprime)

#fitprime <- lm(Yprime ~ Xprime)
#summary(fitprime)
#coefficients(fitprime)











