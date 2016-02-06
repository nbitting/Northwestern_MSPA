##################################################################################
##											     			       ##
##	Nate Bitting												  ##
##  Assignment 2 - Twitter API - Southwest Airlines						  ##
##  PREDICT 452													  ##
##															  ##
##################################################################################

# import necessary libraries used for this assignment
import twitter
import pandas as pd

windows_system = False  # set to True if this is a Windows computer
if windows_system:
    line_termination = '\r\n' # Windows line termination
if (windows_system == False):
    line_termination = '\n' # Unix/Linus/Mac line termination 

def oauth_login():

    # authentication information for Twitter API
    CONSUMER_KEY = 'LZgAo7gtG70sSjyXq4Dd9R5Qp'
    CONSUMER_SECRET = '29Mb7LwtQVWsdHbkawhmDgDLFrwNTsOafCTca7Ui1gMiDMg58l'
    OAUTH_TOKEN = '17460249-lLkzCKkth0r5tBCk2xlQKOdsBJgBflZL6xfFhuls0'
    OAUTH_TOKEN_SECRET = 'QDQFuuo6NuPYkk8M7cDyZFRSXnCTheBEvO9SmWWs9vGF1'
    
    auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
                               CONSUMER_KEY, CONSUMER_SECRET)
    
    twitter_api = twitter.Twitter(auth=auth)
    return twitter_api
    
def twitter_search(twitter_api, q, max_results=200, **kw):
    # See https://dev.twitter.com/docs/api/1.1/get/search/tweets and 
    # https://dev.twitter.com/docs/using-search for details on advanced 
    # search criteria that may be useful for keyword arguments
    
    # See https://dev.twitter.com/docs/api/1.1/get/search/tweets    
    search_results = twitter_api.search.tweets(q=q, count=100, **kw)
    
    statuses = search_results['statuses']
    
    # Iterate through batches of results by following the cursor until we
    # reach the desired number of results, keeping in mind that OAuth users
    # can "only" make 180 search queries per 15-minute interval. See
    # https://dev.twitter.com/docs/rate-limiting/1.1/limits
    # for details. A reasonable number of results is ~1000, although
    # that number of results may not exist for all queries.
    
    # Enforce a reasonable limit
    max_results = min(1000, max_results)
    
    for _ in range(10): # 10*100 = 1000
        try:
            next_results = search_results['search_metadata']['next_results']
        except KeyError, e: # No more results when next_results doesn't exist
            break
            
        # Create a dictionary from next_results, which has the following form:
        # ?max_id=313519052523986943&q=NCAA&include_entities=1
        kwargs = dict([ kv.split('=') 
                        for kv in next_results[1:].split("&") ])
        
        search_results = twitter_api.search.tweets(**kwargs)
        statuses += search_results['statuses']
        
        if len(statuses) > max_results: 
            break
            
    return statuses
    
# -------------------------------------
# use the predefined functions from Russell to conduct the search
# this is the Ford Is Quality Job One example

twitter_api = oauth_login()   
print(twitter_api)  # verify the connection

# twitter handles for top US Airlines
handles = ['@AmericanAir', '@USAirways', '@SouthwestAir', '@AlaskaAir', '@DeltaAssist', '@FlyFrontier', '@JetBlue', '@United', '@VirginAmerica']
data = []

for acct in handles:
    
    q = str(acct) + ' flight delay'  # one of many possible search strings
    results = twitter_search(twitter_api, q, max_results = 200)  # limit to 200 tweets
    temp_dict = {'name':'', 'tweet_count':0, 'results':[]}
    
    # examping the results object... should be list of dictionary objects
    print acct[1:]    
    print('\nnumber of results:', len(results))
    
    for item in results:
        item_data =[acct[1:], item['created_at'], item['favorite_count'], item['retweet_count'], item['user']['name'], item['user']['location'], item['text']]
        data.append(item_data)
 
#save the data to a dataframe
df = pd.DataFrame(data, columns=['airline', 'created_at', 'favorite_count', 'retweet_count', 'user_name', 'user_location', 'tweet_text'])

# export the data to an excel file that can be used on R
df.to_excel('tweet_data.xlsx', index=False)