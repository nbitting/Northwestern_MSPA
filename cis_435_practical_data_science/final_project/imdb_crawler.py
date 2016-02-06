import urllib2 #used to pull the html text
import re #regular expressions used to find the ids on imdb.com
import time

start_time = time.time()

#query url from imdb.com for all US feature films from 2005-2013
main_query = 'http://www.imdb.com/search/title?countries=us&release_date=2005,2013&title_type=feature'
sub_query = 'http://www.imdb.com/search/title?at=0&countries=us&release_date=2005,2013&sort=moviemeter,asc&title_type=feature&start='

#used to make imdb.com think we are getting this data from a browser
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
headers = { 'User-Agent' : user_agent }

req = urllib2.Request(main_query, None, headers) #request html page
response = urllib2.urlopen(req) #actually call the html request
the_page = response.read() #read the htmltext to a variable to search using re

regex = 'data-tconst="(.+?)"' #regular expression (.+?)
pattern = re.compile(regex) #compile the string into something re can use

#use re to get all of the imdb_ids for the movies on the page
#imdb_ids = re.findall(pattern,the_page) 
imdb_ids = []

#get the number of movies from the search (movies from 2005 to 2013)
title_count = '<div id="left">\n1-50 of(.+?)\ntitles.\n</div>'
title_pat = re.compile(title_count)
title_count = re.findall(title_pat,the_page)
title_count = int(str(title_count[0]).replace(",", ""))
page_count = title_count/50 + 1

#create a for loop to get all of the imdb_movie_ids
i=0
movie_count = 22101
while not(len(imdb_ids) == 186):
    
    page = sub_query + str(movie_count)
    req = urllib2.Request(page, None, headers) #request html page
    response = urllib2.urlopen(req) #actually call the html request
    the_page = response.read() #read the htmltext to a variable to search using re
    
    #use re to get all of the imdb_ids for the movies on the page
    #then append them to the main imdb_id list
    new_list = re.findall(pattern,the_page)
    imdb_ids = imdb_ids + new_list
    
    i+=1 #increment for loop counter
    movie_count= int(len(imdb_ids)) + 1 #incrment movie count to get to next page
    percentage = round((len(imdb_ids) / float(title_count)) * 100,1)
    print str(len(imdb_ids)),'of',str(title_count),"(" + str(percentage)+'%)','completed'

# store the items into a text file for later use
store = open("ids2.txt", 'w')
i=0
for i in range(len(imdb_ids)):
      store.write(str(imdb_ids[i]) + '\n')
      i+=1

end_time = time.time()
total_time = round((end_time - start_time)/60,1)
print total_time,"min"