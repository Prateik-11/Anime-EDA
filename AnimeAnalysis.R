library(tidyverse)
library(lubridate)

anime <- read.csv("~/R/Data/anime", comment.char="#")

ggplot(filter(anime,anime$NumberOfEpisodes<=100))+geom_point(aes(x=startDate,y=NumberOfEpisodes),alpha=0.1)

anime <-anime[!is.na(anime$NumberOfEpisodes),]
anime <-anime[!is.na(anime$startDate),]
anime <-anime[!is.na(anime$endDate),]

#time in days: (interval,converted to seconds,divided by no. of seconds)
anime$time <- int_length(interval(start=anime$startDate,end=anime$endDate))/86400

#movies from 1917 for some reason have an end date of 2014, removing them:
anime<-anime[anime$time<=20000,]
#some start and end dates seem to be swapped, reversing -ve times:
anime$time <- abs(anime$time)

ggplot(anime)+geom_point(aes(x=`NumberOfEpisodes`, y=`time`))
#above graph is too vague, zooming in:
ggplot(filter(anime,anime$NumberOfEpisodes<=500,anime$time<=5000))+geom_point(aes(x=`NumberOfEpisodes`, y=`time`,color=`contentRating`),alpha=0.2)

#check if other factors affect time




