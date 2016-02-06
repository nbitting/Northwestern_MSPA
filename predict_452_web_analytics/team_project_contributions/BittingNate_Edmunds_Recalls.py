##################################################################################
##										     			      ##
##  Nate Bitting												##
##  Team Project - Edmunds API Data Acquisition						##
##  PREDICT 452												##
##														##
##################################################################################

# import necessary python libraries
from urllib2 import Request, build_opener
import simplejson
import pandas as pd
import json

# edmunds.com API Key
key = 'sc3svg35bkwdr2nr8qg46prf'
fmt_api_key = 'fmt=json&api_key=' + key

#used to make omdbapi.com think we are getting this data from a browser
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
headers = { 'User-Agent' : user_agent }

#scope of the api calls
parent_companies = ['honda', 'ford', 'toyota', 'fiat chrysler', 'general motors']
makes = ['acura','buick','cadillac','chevrolet','chrysler','dodge','fiat','ford','gmc','honda','jeep','lexus','lincoln','maserati','ram','scion','toyota']
years = ['2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016']

# base url for Edmunds API
base_api_url = 'https://api.edmunds.com/api/vehicle/v2/'

list_json = []

for make in makes:
    for year in years:
        try:        
            url = base_api_url + make + '/models?year=' + year + '&' + fmt_api_key
            req = Request(url, None, headers) #api request
            opener = build_opener() #submit the api request
            the_page = opener.open(req) #read the json from the api query
            json = simplejson.load(the_page) #convert the json to a dict
            json['make'] = make           
            list_json.append(json)
        except:
            continue

# store models json into a new dictionary object
data = {'items':list_json}

# initiate a new list to store the model year IDs
model_list = []

# loop through each object in the data dictionary to store the make, model, year ID, and year
for item in data['items']:
    for model in item['models']:
        for year in model['years']:
            item_data = [item['make'], model['niceName'], str(year['id']), year['year']]
            model_list.append(item_data)
            
# store the model list into a dataframe
model_years_df = pd.DataFrame(model_list, columns=['make', 'model', 'year_id', 'year'])

# initialize a list to store the recall information
recalls = []

# API call for recalls using model year IDs
for index, row in model_years_df.iterrows():
    try:    
        year_id = row['year_id']
        url = 'https://api.edmunds.com/v1/api/maintenance/recallrepository/findbymodelyearid?modelyearid=' + year_id + '&' + fmt_api_key
        req = Request(url, None, headers) #api request
        opener = build_opener() #submit the api request
        the_page = opener.open(req) #read the json from the api query
        json = simplejson.load(the_page) #convert the json to a dict
        json['make'] = row['make']
        json['model'] = row['model']
        json['year_id'] = row['year_id']
        json['year'] = row['year']
        recalls.append(json)
    except:
        continue

# initialize another recall list to store details in tabular format
recall_list = []    
    
for item in recalls:
    for recall in item['recallHolder']:
        data = [item['make'], item['model'], str(item['year']), item['year_id'], recall['componentDescription'], recall['defectConsequence'], 
                recall['defectCorrectiveAction'], recall['defectDescription'], recall['numberOfVehiclesAffected'], recall['influencedBy'],
                recall['recallNumber']]
        recall_list.append(data)
        
# save the list of recalls to a dataframe
recall_df = pd.DataFrame(recall_list, columns=['make', 'model', 'year', 'year_id', 'componentDescription', 'defectConsequence',
                                               'defectCorrectiveAction', 'defectDescription', 'numberOfVehiclesAffected',
                                               'influencedBy', 'recallNumber'])

# save the recall data to an excel file
recall_df.to_excel('recalls.xlsx', encoding='utf-8', index=False)

##############################################################
##
##  Edmunds Editorial API - Articles
##
##############################################################

# read recall data in from Excel
makes = pd.read_excel('recalls.xlsx')

# editorial_url base
editorial_url = 'https://api.edmunds.com/api/editorial/v2/'

articles = []

# loop through and get all articles related to each make/model/year
for index, row in makes.iterrows():
    try:    
        make = row['make']
        model = row['model']
        year = str(row['year'])
        url = editorial_url + make + '/' + model + '/' + year + '?view=basic&' + fmt_api_key
        req = Request(url, None, headers) #api request
        opener = build_opener() #submit the api request
        the_page = opener.open(req) #read the json from the api query
        json = simplejson.load(the_page) #convert the json to a dict
        articles.append(json)
    except:
        continue
    
# flattened json list
art_list = []

# loop through articles and add them into a list
for article in articles:
    
    try:    
        cons = article['cons'][0]
    except:
        cons = ''
    
    try:
        edmundsSays = article['edmundsSays']
    except:
        edmundsSays = ''        

    try:
        make = article['make']['niceName']
    except:       
        make = ''  
        
    try:
        model = article['model']['niceName']
    except:
        model = ''

    try:
        pros = article['pros'][0]
    except:
        pros = ''
        
    try:        
        title = article['title']
    except:
        title = ''        
        
    try:
        whatsNew = article['whatsNew']
    except:
        whatsNew = ''        
        
    try:
        year = article['year']['year']
    except:
        year = ''        
        
    try:
        body = article['body']
    except:
        body = ''       
        
    try:
        intro = article['introduction']
    except:
        intro = ''       
        
    try:
        driving = article['driving']
    except:
        driving = ''
        
    try:
        interior = article['interior']
    except:
        interior = ''    
        
    try:
        powertrain = article['powertrain']
    except:
        powertrain = ''   

    try:
        safety = article['safety']
    except:
        safety = ''
    
    art = [make, model, year, pros, cons, title, body, intro, edmundsSays, whatsNew, driving, interior, powertrain, safety]
    art_list.append(art)

# save articles to a dataframe    
articles_df = pd.DataFrame(art_list, columns=['make', 'model', 'year', 'pros', 'cons', 'title', 'body', 'intro', 'edmundsSays', 
                                              'whatsNew', 'driving', 'interior', 'powertrain', 'safety'])

# save articles to Excel
articles_df.to_excel('articles.xlsx', index=False, encoding='utf-8')