##########################################################################
########   Author: Nate Bitting                                   ########
########   Individual Assignment # 3                              ########
########   Bank Direct Marketing                                  ########
########   Date: May 11, 2014                                     ########
##########################################################################

from sklearn import linear_model
from sklearn import svm
from sklearn.naive_bayes import GaussianNB
from sklearn import tree #decision tree
from sklearn.metrics import confusion_matrix  # evaluating predictive accuracy
from sklearn.metrics import accuracy_score  # proportion correctly predicted
from sklearn.metrics import roc_curve # import ROC curve
from sklearn.metrics import auc # import AUC
from sklearn.cross_validation import cross_val_score  # cross-validation
from sklearn.cross_validation import train_test_split
import matplotlib.pyplot as plt
import pandas as pd  # pandas for data frame operations
import gc

# use the full data set after development is complete with the smaller data set
# bank = pd.read_csv('bank-full.csv', sep = ';')  # start with smaller data set

# initial work with the smaller data set
bank = pd.read_csv('bank-full.csv', sep = ';')  # start with smaller data set
bank_data = pd.read_csv('bank-full.csv', sep = ';')

#store the name of the attributes
attributes = bank.columns.values[0:16]

#variable for top coefficient resutls
top_coef = []

#variables to store FPR and TPR of each model
fpr_master = []
tpr_master = []
model = []
aucs = []

# map string values to numerical values
convert_to_binary = {'no' : 0, 'yes' : 1}
month_map = {'jan':1, 'feb':2, 'mar':3, 'apr':4, 'may':5, 'jun':6, 'jul':7, 'aug':8, 'sep':9, 'oct':10, 'nov':11, 'dec':12}
edu = {'unknown':21, 'primary':1, 'secondary':2, 'tertiary':3}
marital = {'single':0, 'married':1, 'divorced':2}
job = {'admin.':0, 'blue-collar':1, 'entrepreneur':2, 'housemaid':3, 'management':4,
       'retired':5, 'self-employed':6, 'services':7, 'student':8, 'technician':9,
       'unemployed':10, 'unknown':21}
contact = {'cellular':0, 'telephone':1, 'unknown':21} 
poutcome = {'failure':0, 'other':2, 'success':1, 'unknown':21}     
values_to_map = ['default', 'housing', 'loan', 'y']
for item in values_to_map:
        bank[item] = bank[item].map(convert_to_binary)
bank['month'] = bank['month'].map(month_map)
bank['education'] = bank['education'].map(edu)
bank['marital'] = bank['marital'].map(marital)
bank['job'] = bank['job'].map(job)
bank['contact'] = bank['contact'].map(contact)
bank['poutcome'] = bank['poutcome'].map(poutcome)

#create the x and y datasets
x_data = bank.ix[:,0:16]
y_data = bank.ix[:,16]

#create your training and test data sets
x_train, x_test, y_train, y_test = train_test_split(x_data, y_data, test_size=0.30, random_state=9999)

# -------------------------------------------------------------------
# Create a function to plot the different coefficients of each model
# -------------------------------------------------------------------    

def plotGraph(coef, title):
    #global top_coef
    
    #get the column names of the input variables
    xIndex = list()
    for index in x_data.columns.values:
        xIndex.append(index)
        
    # plot the Model's Coefficients  
    coefDF = pd.DataFrame(coef, index=xIndex, columns=['coef'])
    coefDF.sort(['coef']).plot(kind='barh') #plot the frequency of each activity
    plt.title(title)
    plt.savefig('coef_charts/' + title + '_coef', dpi=100)
    plt.clf()
    del coefDF, xIndex
    gc.collect()
    
# -------------------------------------------------------------------
# Create the Linear SVC Model
# ------------------------------------------------------------------- 

#fit the linear svc model
svc = svm.LinearSVC()
svc_model_fit = svc.fit(x_train, y_train)

# predicted class in training data only
y_pred = svc_model_fit.predict(x_test)
print '\nLinear SVC Results:'
print 'Confustion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for Linear SVC
fpr, tpr, thresholds = roc_curve(y_test, y_pred)
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('SVM')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_svc = cross_val_score(svc, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_svc.mean(),3),'\n'  # cross-validation average accuracy

#plot the coefficients
plotGraph(svc_model_fit.coef_[0], 'Linear SVC Coefficients')

# -------------------------------------------------------------------
# Create the Logistic Regression Model
# ------------------------------------------------------------------- 
# fit a logistic regression model 
logreg = linear_model.LogisticRegression(C=1e5, class_weight = 'auto')
log_model_fit = logreg.fit(x_train, y_train)

# predicted class in training data only
y_pred = log_model_fit.predict(x_test)
print 'Logistic Regression Results:'
print'Confustion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for Logistic Regression
fpr, tpr, thresholds = roc_curve(y_test, y_pred)
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('LR')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_log = cross_val_score(logreg, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_log.mean(),3),'\n'  # cross-validation average accuracy

#plot the coefficients
plotGraph(log_model_fit.coef_[0], 'Logistic Regression Coefficients')

# -------------------------------------------------------------------
# Create the Naive Bayes Model
# ------------------------------------------------------------------- 

#fit the linear svc model
gnb = GaussianNB()
gnb_model_fit = gnb.fit(x_train, y_train)

# predicted class in training data only
y_pred = gnb_model_fit.predict(x_test)
print 'Gaussian Naive Bayes Results:'
print 'Confustion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for NB
fpr, tpr, thresholds = roc_curve(y_test, y_pred)
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('NB')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_gnb = cross_val_score(gnb, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_gnb.mean(),3)  # cross-validation average accuracy

# -------------------------------------------------------------------
# Create the Decision Tree Model
# ------------------------------------------------------------------- 

#fit the linear svc model
tree = tree.DecisionTreeClassifier(random_state = 9999, criterion='entropy', max_depth=6, min_samples_leaf=5)
tree_model_fit = tree.fit(x_train, y_train)

# predicted class in training data only
y_pred = tree_model_fit.predict(x_test)
print '\nDecision Tree Results:'
print 'Confustion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for NB
fpr, tpr, thresholds = roc_curve(y_test, y_pred)
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('DT')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_tree = cross_val_score(tree, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_tree.mean(),3)  # cross-validation average accuracy

# -------------------------------------------------------------------
# Plot the ROC curves
# ------------------------------------------------------------------- 

plt.clf()
i=0
for i in range(4):
    plt.plot(fpr_master[i], tpr_master[i], label='%s' % model[i])
    
#plt.plot(fpr_master, tpr_master)
plt.title('ROC Curves')
plt.legend(loc='lower right')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.savefig('roc_chart/roc_curve', dpi=100)

# -------------------------------------------------------------------
# Analyze most important coefficients
# ------------------------------------------------------------------- 

for val in attributes:
    if val in ['duration']:
        pass
    else:
        plt.clf()
        tempDF = pd.crosstab(bank_data[val], bank_data['y'])
        temp = ((tempDF['yes']) / (tempDF['yes'] + tempDF['no']))*100
        temp = temp.round(decimals=1)
        temp.plot(kind='barh')
        plt.title(val + " Response Rate")
        plt.savefig('response_charts/' + val + '_response_rate', dpi=100)
        del tempDF, temp
        gc.collect()