from urllib2 import Request, urlopen
import json
import pandas as pd
import imdb
import time
import numpy as np
from thready import threaded

#record time at beginning of script
start_time = time.time()

#read the ids from the imdb_id csv file
imdb_ids = pd.read_csv('ids_left.csv')
id_list = imdb_ids.values.flatten()

#function that will be used by each thread
def movie_data_query(ids):  
                
    #used to make omdbapi.com think we are getting this data from a browser
    user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
    headers = { 'User-Agent' : user_agent }
    
    #Open Movie Database Query url for IMDb IDs
    url = 'http://www.omdbapi.com/?tomatoes=true&i='
        
    if len(str(ids))<7:
        ids = '0' + str(ids)
    else:
        ids = str(ids)
    
    req = Request(url + 'tt' + str(ids), None, headers) #request page
    response = urlopen(req) #actually call the html request
    the_page = response.read() #read the json from the omdbapi query
    movie_json = json.loads(the_page) #convert the json to a dict
        
    #get the gross revenue and budget from IMDbPy
    data = imdb.IMDb()
    movie_id = int(ids)

    try:
        data = data.get_movie_business(movie_id)
        data = data['data']
        data = data['business']
        
        #get the gross and budget $ amount out of the gross IMDbPy string
        try:
            #get the budget $ amount out of the gross IMDbPy string
            budget = data['budget']
            budget = budget[0]
            budget = budget.replace('$', '')
            budget = budget.replace(',', '')
            budget = budget.split(' ')
            budget = str(budget[0])
            
            #get the gross $ amount out of the gross IMDbPy string
            gross = data['gross']
            gross = gross[0]
            gross = gross.replace('$', '')
            gross = gross.replace(',', '')
            gross = gross.split(' ')
            gross = str(gross[0])
        except:
            None
            
        #add gross to the movies dict 
        try:
            movie_json[u'imdbpy_gross'] = gross
        except:
            movie_json[u'imdbpy_gross'] = 0
        
        #add budget to the movies dict    
        try:
            movie_json[u'imdbpy_budget'] = budget
        except:
            movie_json[u'imdbpy_budget'] = 0
        
        #create new dataframe that can be merged to movies DF    
        tempDF = pd.DataFrame.from_dict(movie_json, orient='index')
        tempDF = tempDF.T
        
        #save to file
        tempDF.to_csv('movies/movie_' + str(ids) + '.csv')
    except:
        print str(ids)


#main function to run the script and create the threads
def main():
    threaded(id_list, movie_data_query, num_threads=20)    
    end_time = time.time()
    time_took = end_time - start_time
    print time_took
 
#call the main function   
if __name__ == "__main__":
    main()