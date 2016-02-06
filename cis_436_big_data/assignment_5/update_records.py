# import the necessary libraries
from pymongo import MongoClient

# create the mongodb client
client = MongoClient()

# assign the database we will use
db = client.test

# assign the food_inspections collection to a variable
inspections = db.food_inspections

# update 10 records with a new field
count = 1
for item in inspections.find():
    if count < 11:
        item['author'] = 'Nate Bitting'
        print item
        count += 1
    else:
        break
