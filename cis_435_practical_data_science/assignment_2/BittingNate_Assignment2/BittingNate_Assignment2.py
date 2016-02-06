##########################################################################
########   Author: Nate Bitting                                   ########
########   Individual Assignment # 2                              ########
########   Wisconsin Dells Survey Data                            ########
########   Date: April 27, 2014                                   ########
##########################################################################

#import libraries needed for this application
from __future__ import division, print_function
from future_builtins import ascii, filter, hex, map, oct, zip
import numpy as np  # array operations
import pandas as pd  # pandas for data frame operations
import matplotlib.pyplot as plt
from mlia import apriori # import the apriroi algorithm for assosciation analysis

# set paramteters for apriori algorithm
alpha = 0.2  # required level of support for apriori item sets
beta = 0.4  # required level of confidence for apriori rules
max_other_items =  2  # maximum other items in reported rule set
# frozen set is an immutable set
#item_of_interest = frozenset(['waterpark'])  # character string of item of interest

# -------------------------------------------------
# Generate list of lists from Wisconsin Dells data
# -------------------------------------------------
# read in the Wisconsin Dells data
wi_dells = pd.read_csv('wisconsin_dells.csv')
print(wi_dells.shape)  # check the structure of the data frame

# list of activities for study
activity = ['shopping',	'antiquing', 'scenery',	'eatfine',
    'eatcasual', 'eatfamstyle',	'eatfastfood',	'museums',
    'indoorpool', 'outdoorpool', 'hiking', 'gambling',
    'boatswim',	'fishing', 'golfing', 'boattours', 'rideducks',
    'amusepark', 'minigolf', 'gocarting', 'waterpark', 
    'circusworld', 'tbskishow', 'helicopter', 'horseride',
    'standrock', 'outattract', 'nearbyattract', 'movietheater',	
    'concerttheater', 'barpubdance', 'shopbroadway', 'bungeejumping']
    
# work with a subset of the data columns corresponding to the activities
df = pd.DataFrame(wi_dells, columns = activity)
df2 = pd.DataFrame(wi_dells, columns = activity)

#create mappings for apriori and frequency datasets
for index in range(len(activity)):
    activity_to_name = {'NO' : np.nan, 'YES' : activity[index]}
    activity_to_num = {'NO' : 0, 'YES' : 1}
    df[activity[index]] = df[activity[index]].map(activity_to_name)
    df2[activity[index]] = df2[activity[index]].map(activity_to_num)

# my_data is the list of lists structure that is needed 
# for input to the apriori algorithm
my_data = list()  # initialize list structure for list of lists

# loop through the rows of the data frame by index ix 
# creating the list of lists structure one activity basket at a time
# we use dropna() to omit missing data as coded nan from numpy

# generate the activity basket for this visitor
# and convert it to a list for each of the df.shape[0] visitors
for index in range(df.shape[0]):
    basket = list(df.ix[index].dropna())  # this list for one visitor
    my_data.append(basket)  # add this list to list of lists
    
# -------------------------------------------------
# Create the frequency plots
# -------------------------------------------------    

freqIndex = list()
freqList = list()
total = float(len(df2))

for index in range(len(activity)):
    freq = df2[activity[index]].sum() / total
    freqIndex.append(activity[index])
    freqList.append(freq)
    
# plot the frequencies in a horizontal bar chart and print the activity rankings    
freqDF = pd.DataFrame(freqList, index=freqIndex, columns=['frequency'])
freqDF.sort(['frequency']).plot(kind='barh') #plot the frequency of each activity
plt.show()
print('Activity Frequency Ranking\n')
print(freqDF.rank(ascending=False).sort(['frequency'])) #print the activity frequency rank 


# -------------------------------------------------
# Apply the apriori algorithm to the list of lists
# -------------------------------------------------
L, suppData = apriori.apriori(my_data)

print('Identified rules with support = ', alpha, 'and confidence = ', beta)
rules = apriori.generateRules(L, suppData, minConf = beta)

# search across the rule set starting with smaller sets
# and moving to larger and larger sets until no rules
# exist that satisfy the requirement of including item_of_interest

for index in range(len(activity)):
    
    # set item of interest
    item_of_interest = frozenset([activity[index]])
    print('\n------------------------------------------------------')
    print('\nItem of interest:', str(activity[index]))
    
    n_other_items = 1  # initialize reporting at one other item
    while n_other_items <= max_other_items:
        print('\nRules with ', n_other_items, ' other item(s)')
        for item in L[n_other_items]:        
            if item.intersection(item_of_interest): print(item)
        n_other_items += 1   