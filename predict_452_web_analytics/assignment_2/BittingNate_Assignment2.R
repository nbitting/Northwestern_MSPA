###############################################################################
##                                                                           ##
##      Nate Bitting                                                         ##
##      Assignment 2 - EDA for Airlines Twitter Data                         ##
##      PREDICT 452                                                          ##
##                                                                           ##
###############################################################################

# load the needed libraries
library('ggplot2')
library('plyr')
library('xlsx')
library('reshape2')

# set the working directory
setwd('/Users/nbitting/Google Drive/PREDICT452/Assignment 2')

# read in the data
data <- read.xlsx('tweet_data.xlsx', 1)
data$created_date <- substr(data$created_at, 5, 10) #easier to use data field
data$popularity <- data$favorite_count + data$retweet_count #new popularity field

# show the number of tweets per day for each airline
tapply(data$created_date, data$airline, count)

# bar plot to see number of styles per make
t <- ggplot(data, aes(factor(airline)))
t + geom_bar() + labs(title = '# of Tweets by Airline', x = 'Airline', y = '# of Tweets') + theme(axis.text.x = element_text(angle = 45, hjust = 1))

# bar plot to see number of styles per make
s <- ggplot(data, aes(factor(created_date)))
s + geom_bar(aes(fill=airline)) + labs(title = '# of Tweets by Airline Over Time', x = 'Date', y = '# of Tweets by Airline') + theme(axis.text.x = element_text(angle = 45, hjust = 1))

# create new variable to store average popularity for tweets for each airline
popularity <- melt(tapply(data$popularity, data$airline, mean), varnames="airline", value.name="mean")

# bar plot to see average pouplarity of tweets by airline
p <- ggplot(popularity, aes(x=airline, y=mean))
p + geom_bar(position="dodge", stat="identity") + labs(title = 'Popularity by Airline', x = 'Airline', y = 'Popularity (Favorites + Retweets)') + theme(axis.text.x = element_text(angle = 45, hjust = 1))