##################################################################################
##											     	           ##
##  Nate Bitting    										     ##
##  Assignment 3 - Enron Email Network Analysis					     ##
##  PREDICT 452											     ##
##													     ##
##################################################################################

# load package into the namespace for this program
from pymongo import MongoClient  # work with MongoDB 
import pandas as pd  # DataFrame object work
from datetime import datetime  # text/date manipulation
import networkx as nx
import matplotlib.pyplot as plt  # 2D plotting

# prompt for user's NetID and password
my_netid = raw_input('Enter your NetID: ')
my_password = raw_input('Enter your password: ')

try:    
    client = MongoClient("129.105.208.225")
    client.enron.authenticate(my_netid, my_password,\
        source='$external', mechanism='PLAIN') 
    print('\nConnected to MongoDB enron database\n')    
    success = True    
except:
    print('\nUnable to connect to the enron database')

# if connection is successful, work with the database

print('\nCollections in the enron database:')
cols = client.enron.collection_names()
for col in cols:
    print(col)	
	
# work with documents in the messages collection 
workdocs = client.enron.messages

# inquire about the documents in messages collection
print('\nNumber of documents: ', workdocs.count())
print('\nOne such document:\n', workdocs.find_one())
one_dict = workdocs.find_one() # create dictionary
print('\nType of object workdocs: ', type(one_dict))  

# how many documents contain 'Silverpeak' in text field
print('How many documents contain the string <Silverpeak>?')
print(workdocs.find({'$text':{'$search':'Silverpeak'}}).count())

# store documents in a list of dictionary objects
selectdocs =\
    list(workdocs.find({'$text':{'$search':'Silverpeak'}}))

# flatten the nested dictionaries in selectdocs
# and remove _id field 
list_of_emails_dict_data = []
for message in selectdocs:
    tmp_message_flattened_parent_dict = message
    tmp_message_flattened_child_dict = message['headers']
    del tmp_message_flattened_parent_dict['headers']
    del tmp_message_flattened_parent_dict['_id']
    tmp_message_flattened_parent_dict.\
        update(tmp_message_flattened_child_dict)
    list_of_emails_dict_data.\
        append(tmp_message_flattened_parent_dict.copy())

print('\nNumber of items in list_of_emails_dict_data: ',\
    len(list_of_emails_dict_data))  

# we can use Python pandas to explore and analyze these data
# create pandas DataFrame object to begin analysis
enron_email_df = pd.DataFrame(list_of_emails_dict_data)

# set missing data fields
enron_email_df.fillna("", inplace=True)

# user-defined function to create simple date object (no time)
def convert_date_string (date_string):
    try:    
        return(datetime.strptime(str(date_string)[:16].\
            lstrip().rstrip(), '%a, %d %b %Y'))
    except:
        return(None)
        
# apply function to convert string Date to date object
enron_email_df['Date'] = \
    enron_email_df['Date'].apply(lambda d: convert_date_string(d))
    
edges = []
for index, row in enron_email_df.iterrows():
    edge = str(row['From'][:-10]) + "," + str(row['To'][:-10])
    edges.append(edge)
    
# read in network edge list
g = nx.read_edgelist(edges, create_using = nx.DiGraph(), delimiter = ',', nodetype = str)

# print graph attributes
print('This is a directed network/graph (True or False): ', g.is_directed())
print('Number of nodes: ', nx.number_of_nodes(g))
print('Number of edges: ', nx.number_of_edges(g))
print('Network density: ', round(nx.density(g), 4))

# plot the degree distribution 
fig = plt.figure()
plt.hist(nx.degree(g).values())
plt.axis([0, 8, 0, 8])
plt.xlabel('Node Degree')
plt.ylabel('Frequency')
plt.show()
    
# examine alternative layouts for plotting the network 
# plot the network/graph with default layout 
fig = plt.figure()
nx.draw_networkx(g, node_size = 0, node_color = 'yellow')
plt.show()

# spring layout
fig = plt.figure()
nx.draw_networkx(g, node_size = 0, node_color = 'yellow',\
    pos = nx.spring_layout(g))
plt.show()

# circlular layout
fig = plt.figure()
nx.draw_networkx(g, node_size = 0, node_color = 'yellow',\
    pos = nx.circular_layout(g))
plt.show()

# shell/concentric circles layout
fig = plt.figure()
nx.draw_networkx(g, node_size = 0, node_color = 'yellow',\
    pos = nx.shell_layout(g))
plt.show()

# pick the visualization that you prefer and route that to external pdf file
fig = plt.figure()
nx.draw_networkx(g, node_size = 0, node_color = 'yellow',\
    pos = nx.spring_layout(g))
plt.savefig('BittingNate_Plot.pdf', bbox_inches = 'tight', dpi = None,
    facecolor = 'w', edgecolor = 'b', orientation = 'portrait', 
    papertype = None, format = None, pad_inches = 0.25, frameon = None)