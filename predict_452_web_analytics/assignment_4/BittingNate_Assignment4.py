##################################################################################
##											     	           ##
##  Nate Bitting    										     ##
##  Assignment 4 - Sentiment Analysis					                ##
##  PREDICT 452											     ##
##													     ##
##################################################################################

# let's make our program compatible with Python 3.0/1/2/3
from __future__ import division, print_function

from numpy import *
from nltk.corpus import PlaintextCorpusReader
import pandas as pd
import string
import math

# create lists of positive and negative words using Hu and Liu (2004) lists
my_directory = 'C:\\Users\\Nate Bitting\\Google Drive\\PREDICT452\\Assignment 4'
positive_list = PlaintextCorpusReader(my_directory, 'Hu_Liu_positive_word_list.txt')
negative_list = PlaintextCorpusReader(my_directory, 'Hu_Liu_negative_word_list.txt')
positive_words = positive_list.words()
negative_words = negative_list.words()

# define bag-of-words dictionaries 
def bag_of_words(words, value):
    return dict([(word, value) for word in words])
positive_scoring = bag_of_words(positive_words, 1)
negative_scoring = bag_of_words(negative_words, -1)
scoring_dictionary = dict(positive_scoring.items() + negative_scoring.items())

# import twitter data from airline assignment
tweets = pd.read_excel('tweet_data.xlsx')
tweet_list = []

# score each word in each tweet against the scoring_dictionary
for index, row in tweets.iterrows():
    score = []    
    for word in row['tweet_text'].split():
        if word.translate(string.punctuation) in scoring_dictionary:
            score.append(scoring_dictionary[word])
    score = mean(score)
    if (score <= 0.5) & (score >= 0):
        tweet_list.append([row['airline'], row['tweet_text'], 'neutral', score])
    elif score > 0.5:
        tweet_list.append([row['airline'], row['tweet_text'], 'positive', score])
    elif math.isnan(score):
        tweet_list.append([row['airline'], row['tweet_text'], 'neutral', 0])
    else:
        tweet_list.append([row['airline'], row['tweet_text'], 'negative', score])

# store the scored tweets into a pandas dataframe    
scored_tweets = pd.DataFrame(tweet_list, columns=['airline', 'tweet_text', 'sentiment', 'score'])

# report the norm sentiment score for the words in the corpus
print('Corpus Average Sentiment Score:')
print(round(scored_tweets['score'].sum() / (len(scored_tweets['score'])), 3))        

# plot the mean score for each airline
scored_tweets.groupby('airline')['score'].mean().round(3).plot(kind='bar')

# plot the frequency for each category of sentiment: positive, negative, or neutral
scored_tweets.pivot_table(values='score', rows=['airline'], cols = ['sentiment'], aggfunc = len).plot(kind='bar')           