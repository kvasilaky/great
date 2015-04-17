#Exploring Data
#Loading stuff we need.


library(plyr)

setwd("/Users/kathrynvasilaky/SkyDrive/R/NYCData")
data <- read.csv("/Users/kathrynvasilaky/SkyDrive/R/NYCData/data.csv")
path <- getwd() #"/Users/kathrynvasilaky/SkyDrive/R/NYCData"  
path <- paste(path,'/', sep='')


#Explore the data
#Look at the first 10 columns, the first 2 rows
#How many unique groups are there? ( Answer:unique(data$group), summary(data) )
#How many missing values 

#Subset the data to not missings
data <- subset(data, group!='' )
#Eliminate observations with sum = NA or sum = 0
data <- subset(data, !is.na(y1))
data <- subset(data, sum > 0.0)




#Replace missings with 0



data$x1[is.na(data$x2)] <- 0
data$y1[is.na(data$y1)] <- 0

#Normalize the data to sum to 10
for (i in 1:nrow(data)) {
    row <- data[i,]
    if (row$sum != 10.0) { 
      #normalizing the summed column
      normed <- 10/row$sum
      data[i,]$x1 <- normed * data[i,]$x1
      data[i,]$y1 <- normed * data[i,]$y1
    }
}




#Merging Files
#Now let us merge in a file on the group variable
#What type of variable is group? (A: typeof(data$group))
#Need to convert group from factor to string type to match with gps



#Merge in gps data
data$group <- as.character(data$group)
gps <- read.csv("/Users/kathrynvasilaky/SkyDrive/R/NYCData/gps.csv")

#creating variable to merge on
gps$group<- as.character(gps$group)
data_gps <- merge(x = data, y = gps, by = "group", all.y=TRUE)
#What happens if dat.x is set to "FALSE"?




#Want a table of averages by group
#Creating an indicator variable for groups that made a purchase
data_gps$Bought <- (data_gps$Buy=="Y")
#Creating an indicator variable for x1 positive
data_gps$x1 <- (data_gps$x1>0 )
#Create a new variable for the whole dataset
data_gps$total <- 'Total'



#Table 1    			
#Averages by Group							
  


output <- ddply(data_gps, .(group), function(df)c(Mean = mean(df$x1),
                                                Mean2=mean(df$y1),
                                                North_Lat = unique(df$North_Lat), 
                                                West_Long = unique(df$West_Long)))

output2 <- ddply(data_gps, .(total), function(df)c(MeanX = mean(df$x1),
                                                MeanY=mean(df$y1),
                                                North_Lat = unique(df$North_Lat), 
                                                West_Long = unique(df$West_Long)))

#Hard way to rename
names(output)[3]<-'Average Output x1'

#Easier plyr way to rename
rename(output2,c('MeanX'='Average Output x1'))
#Does the latter actually change the variable name? 


#Create a table combining the group averages and total averages
table1 <- rbind(output, output2)
#Output the data to csv
write.csv(file='groups_data.csv', x=output)



#######
#Plots
######

#Make a plot graph of x1
names(output)[3] <- 'x1'
date <- as.Date(1:6, origin="2015-01-01")
x1[3:10]

#http://www.statmethods.net/advgraphs/ggplot2.html
pdf(file=paste(path, "trial.pdf", sep=''))
#par(mfrow=c(2,2))
g <- qplot(x1, date, data=output, xlab='output', ylab='date')
g + theme_bw()
dev.off()


#Make a histogram of x1 by group
#create a group variable
output$gr[output$x1<6]

for (i in 1:nrow(output) ) {
  if(output$x1[i]<6) {print('y')} else {print('n')}
}

for (i in 1:nrow(output) ) {
  if (x1[[i]]<5) {output$gr[i] <- 1}  
  else if (x1[[i]]==10) { output$gr[i] <- 2} 
  else {output$gr[i] <- 0}
}

#Shorter if else method
#output$gr <- ifelse(output$x1<6, 1,0)

output$gr <- factor(output$gr,levels=c(0,1,2),
                      labels=c("group 0","group 1", "group 2")) 


pdf(file=paste(path, "trial_hist.pdf", sep=''))
#par(mfrow=c(2,2))
qplot(x1, data=output, geom="density", fill=output$gr,alpha=I(.5), main='fake hist', xlab='output', ylab='date')
#g + theme_bw()
dev.off()
