# jump-start text document clustering
# very rough initial clustering using scikit-learn

# This program goes on to demonstrate additional text
# processing capabilities of Python. Here we gather up
# text from 297 blog pages dealing with web analytics,
# creating a document corpus for analysis. 
# We note that three blogs (003, 008, and 009)
# had only one document. We drop these from this analysis,
# defining a new input directory called results_for_clustering.
#
# We rely upon scikit-learn for our analysis, employing
# a bag-of-words approach to text analytics.


# See documentation at 
# <http://scikit-learn.org/stable/auto_examples/document_clustering.html>

# let's make our program compatible with Python 3.0/1/2/3
from __future__ import division, print_function
from future_builtins import ascii, filter, hex, map, oct, zip

import os  # operating system commands
import numpy as np  # for array definition and calculations
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn import metrics  # includes cluster measures
from sklearn.cluster import KMeans  # cluster analysis
from pandas import *  # includes contingency matrix
import matplotlib.pyplot as plt
from mpltools import style
import nltk as nltk
from nltk.stem.porter import PorterStemmer
from collections import Counter

style.use('ggplot')

# Previous work provided a directory called results
# with text files from the web analytics blogs.
# identify all of the file names 
my_directory = '/Users/nbitting/Documents/CIS435/Assignment 5/000_clustering_jump_start'
file_names =  os.listdir(my_directory + '/results_for_clustering/')
nfiles = len(file_names)  # nfiles should be 295

# as we read individual documents we will asssociate the
# blog number with each document... metadata/document tag
blog = []  # initialize
documents = []  # initialize document collection
tokenized = {} #dict to store tokenized documents

#read text from documents and put them into a list
for ifile in range(len(file_names)):
    this_file_name = my_directory + '/results_for_clustering/' + file_names[ifile]
    with open(this_file_name, 'rt') as f:
        this_file_text = f.read()
        documents.append(this_file_text)
        blog.append(int(file_names[ifile][6:8]))

#Use NLTK to tokenize words in each document
i = 0
for i in range(len(documents)):
    tokenized_item = nltk.word_tokenize(documents[i])
    filtered = [w for w in tokenized_item if not w in nltk.corpus.stopwords.words('english')]
    counted = Counter(filtered)
    tokenized[blog[i]] = dict(counted)

#plot top words in each blog
tokenDF = DataFrame(tokenized.values(), index=tokenized.keys())
blog1 = DataFrame(tokenDF.ix[1,:]).dropna().sort(column=1, ascending=False).head(25).plot(kind='barh')
blog2 = DataFrame(tokenDF.ix[2,:]).dropna().sort(column=2, ascending=False).head(25).plot(kind='barh')
blog4 = DataFrame(tokenDF.ix[4,:]).dropna().sort(column=4, ascending=False).head(25).plot(kind='barh')
blog5 = DataFrame(tokenDF.ix[5,:]).dropna().sort(column=5, ascending=False).head(25).plot(kind='barh')
blog6 = DataFrame(tokenDF.ix[6,:]).dropna().sort(column=6, ascending=False).head(25).plot(kind='barh')
blog7 = DataFrame(tokenDF.ix[7,:]).dropna().sort(column=7, ascending=False).head(25).plot(kind='barh')
blog10 = DataFrame(tokenDF.ix[10,:]).dropna().sort(column=10, ascending=False).head(25).plot(kind='barh')

# define a simple TF-IDF vectorizer to measure number_of_features for each document
# the number of features per document can be modified to get different solutions
# as can other aspects of the vectorizer...
number_of_features = 30
vectorizer = TfidfVectorizer(max_df = 0.7, max_features = number_of_features, stop_words = 'english')
X = vectorizer.fit_transform(documents)

# kmeans clustering using 6 clusters
number_of_clusters = 6
km = KMeans(n_clusters = number_of_clusters, init = 'k-means++', max_iter = 500, n_init = 1)
km.fit(X) 
labels = np.array(blog)

print("Number of Clusters: %d" % number_of_clusters)
print("Homogeneity: %0.3f" % metrics.homogeneity_score(labels, km.labels_))
print("Completeness: %0.3f" % metrics.completeness_score(labels, km.labels_))
print("V-measure: %0.3f" % metrics.v_measure_score(labels, km.labels_))
print("Adjusted Rand-Index: %.3f" % metrics.adjusted_rand_score(labels, km.labels_))
print("Silhouette Coefficient: %0.3f" % metrics.silhouette_score(X, labels = km.labels_, sample_size=1000))

df = DataFrame({'Blog': np.array(blog), 'Cluster': km.labels_})
df2 = crosstab(df['Blog'], df['Cluster'])
df2.plot(kind='bar') #plot the cluster results
plt.show()
print(df2)         
print('RUN COMPLETE')                