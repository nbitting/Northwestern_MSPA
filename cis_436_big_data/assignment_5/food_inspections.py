# import the necessary libraries
from pymongo import MongoClient

# create the mongodb client
client = MongoClient()

# assign the database we will use
db = client.test

# assign the food_inspections collection to a variable
inspections = db.food_inspections

# print out how may recrods were inserted
print "\n# of records in the food_inspections collection: " + str(inspections.count())

# show the first recrod in the collection
print "\nFirst inspection record:"
print inspections.find_one()

# show the inspections for restaurants
print "\nList of Restaurant Inspections:"
for item in inspections.find({"Facility Type":"Restaurant"}):
    print item['AKA Name']

# show the inspections that failed
print "\nList of Failed Inspections:"
for item in inspections.find({"Results":"Fail"}):
    print item['AKA Name']
