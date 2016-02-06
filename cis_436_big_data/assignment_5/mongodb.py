#import the necessary libraries
from pymongo import MongoClient
import pandas as pd

# create the mongodb client
client = MongoClient()

# assign the database we will use
db = client.test

# check to see if the food inspections collection exists, if not, create it
if "food_inspections" in db.collection_names():
    collection = db.food_inspections
else:
    db.create_collection("food_inspections")
    collection = db.food_inspections

# get the food_inspection data into JSON format and import it
# into the food_inspections collection
foodDF = pd.read_csv('/users/nbitting/Documents/CIS436/food_inspections.txt', sep="\t")

# take first 20 records from the foodDF
foodDF = foodDF[0:20]

# convert the 20 recrods in foodDF to a dict using the "records" orient option
foodDict = foodDF.to_dict('records')

# insert the 20 recrods into the food_inspections collection
collection.insert(foodDict)
