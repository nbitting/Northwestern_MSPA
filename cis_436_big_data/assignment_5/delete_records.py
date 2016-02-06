# import the necessary libraries
from pymongo import MongoClient

# create the mongodb client
client = MongoClient()

# assign the database we will use
db = client.test

# assign the food_inspections collection to a variable
inspections = db.food_inspections

# delete 5 records from the collection
count = 1
for item in inspections.find():
    if count < 6:
        inspections.remove(item)
        count += 1
    else:
        break

# verify the 5 records were removed
print inspections.count()
