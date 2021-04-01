library(tidyverse)
library(lubridate)

anime <- read.csv("~/R/Data/anime", comment.char="#")

anime$startDate <- as.Date(anime$startDate) 
anime$endDate <- as.Date(anime$endDate) 

anime <-anime[!is.na(anime$NumberOfEpisodes),]
anime <-anime[!is.na(anime$startDate),]
anime <-anime[!is.na(anime$endDate),]

#runtime in days: (interval,converted to seconds,divided by no. of seconds)
anime$time <- int_length(interval(start=anime$startDate,end=anime$endDate))/86400
#Movies,Special etc have time=0, converting it to 1
anime$time[anime$time==0]<-1
#movies from 1917 for some reason have an end date of 2014, removing them:
anime<-anime[anime$time<=20000,]
#some start and end dates seem to be swapped, reversing -ve times:
anime$time <- abs(anime$time)

#add column for decades
anime <- mutate(anime, decade= as.factor(as.integer(year(startDate))-as.integer(year(startDate))%%10))

#Anime production has shot up:
ggplot(anime)+geom_histogram(aes(startDate))

#ContentRating
ggplot(anime[anime$startDate>as.Date('1920-01-01'),])+geom_histogram(aes(startDate,fill=contentRating),position = 'fill')

ggplot(filter(anime,anime$NumberOfEpisodes<=100,anime$NumberOfEpisodes!=1))+geom_area(aes(x=NumberOfEpisodes),stat = "bin")
#modes at 2,12,24,50

#separate by year 2000
ggplot(filter(anime,anime$NumberOfEpisodes<=100,anime$NumberOfEpisodes!=1,anime$startDate>=as.Date("2000-01-01")))+geom_area(aes(x=NumberOfEpisodes),stat = "bin")+labs(title = "Post 2000")
ggplot(filter(anime,anime$NumberOfEpisodes<=100,anime$NumberOfEpisodes!=1,anime$startDate<as.Date("2000-01-01")))+geom_area(aes(x=NumberOfEpisodes),stat = "bin")+labs(title="Pre 2000")

ggplot(filter(anime,anime$NumberOfEpisodes<=500,anime$time<=5000))+geom_point(aes(x=`NumberOfEpisodes`, y=`time`,color=`contentRating`),alpha=0.2)







