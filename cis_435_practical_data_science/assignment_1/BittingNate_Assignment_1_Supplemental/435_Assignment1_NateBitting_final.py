##########################################################################
########   Author: Nate Bitting                                   ########
########   Individual Assignment # 1                              ########
########   Wisconsin Dells Survey Data                            ########
##########################################################################

# these modules should prove especially useful in this first assignment
import pandas as pd  # pandas for data frame operations
import numpy as np  # arrays an math functions
import sklearn as sk  # machine learning tools
import matplotlib.pyplot as plt  # 2D plotting
from sklearn import tree #decision tree
from sklearn.cross_validation import cross_val_score #cross validation
from sklearn.cross_validation import train_test_split
from sklearn.externals.six import StringIO
from sklearn.cross_validation import train_test_split
from sklearn import metrics

# Read in the data from the csv file provided by the Dells Survey
wi_dells_data = pd.read_csv("wisconsin_dells_original.csv")

# create a main dataframe object to hold the data
df = pd.DataFrame(wi_dells_data)
df = df.drop(['id'], axis=1)
df = df.dropna() # remove any NaN values

#create ordinal mappings
remap_nnights = {'0':0, '1': 1, '2':2, '3':3, '4+':4}
remap_nadults = {'1':1, '2': 2, '3':3, '4':4, '5+':5}
remap_nchildren = {'1':1, '2': 2, '3':3, '4':4, '5+':5}
remap_planning = {'This Week':1, 'This Month': 2, 'One Month or More Ago':3}
remap_sex = {'Female':0, 'Male':1}
remap_age = {'LT 25':1, '25-34':2, '35-44':3, '45-54':4, '55-64':5, '65+':6} #has NaN
remap_education = {'HS Grad or Less':1, 'Some College':2, 'College Grad':3, 'Post Grad':4} #has NaN
remap_income = {'Lower Income':1, 'Middle Income':2, 'Upper Income':3} #has NaN
remap_region = {'Chicago':1, 'Minneapolis/StPaul':2, 'Madison':3, 'Milwaukee':4, 'Other Wisconsin':5, 'Other':6} #has NaN
remap_target = {'YES' : 1, 'NO' : 0}

#create array of ordinal mappings
mappings = [remap_nnights, remap_nadults, remap_nchildren, remap_planning, remap_sex, 
    remap_age, remap_education, remap_income, remap_region, remap_target]

# for loop to create decision trees and calculate accuracy of each model
count = 9
for i in np.arange(32):
    
    #create data to use for each decision tree
    col = df.ix[:,count].name
    dtdf = df.ix[:,['nnights','nadults','nchildren','planning','sex','age',
    'education','income','region', col]] #create dataset
    
    #for loop to map ordinal values and create x for decision tree
    count2 = 0
    dt_array = np.ndarray((int(len(dtdf)), 10))
    for mapping in mappings:
        dt_array[:,count2] = dtdf.ix[:,count2].map(mapping).T
        count2+=1
    
    dt_array = pd.DataFrame(dt_array, columns=['nnights','nadults','nchildren','planning','sex','age',
    'education','income','region', col]).dropna() # remove all NaN values
    dt_target = dt_array.ix[:,9] #set the y-target variable set
    dt_data = dt_array.ix[:,:8] #set the x-input variable set
    
    #create your training and test data sets
    x_train, x_test, y_train, y_test = train_test_split(dt_data, dt_target, test_size=0.30, random_state=9999)
    
    #create your decision tree
    model = tree.DecisionTreeClassifier(random_state = 9999, criterion='entropy', max_depth=6, min_samples_leaf=5)
    my_tree = model.fit(x_train, y_train)
    
    #calculate the accuracy of the model using metrics
    y_prediction = my_tree.predict(x_test)
    
    #perform 10 fold cross validation
    cv_results_array = {} # create a dict to store all of the results
    cv_results = cross_val_score(my_tree, x_train, y_train, cv=10) #multi-fold cross-validation
    cv_results_array.update({'%s' % col : cv_results.mean()}) #put each CV result into a dict
    
    #print CV Result and Accuracy
    print '%s CV Result: ' % col + str(round(cv_results.mean(),3)) 
    print "%s Accuracy:{0:.3f}".format(metrics.accuracy_score(y_test, y_prediction)) % col, "\n"
    
    #save the decision tree models to .dot files in a specific directory
    with open('./trees/%s.dot' % col, 'w') as f:
        f = tree.export_graphviz(my_tree, out_file=f)
    
    count+=1
    
    
