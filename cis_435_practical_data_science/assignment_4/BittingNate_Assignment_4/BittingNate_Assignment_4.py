##########################################################################
########   Author: Nate Bitting                                   ########
########   Individual Assignment # 4                              ########
########   Bank Direct Marketing                                  ########
########   Date: May 18, 2014                                     ########
##########################################################################

from sklearn import linear_model # logistic regression
from sklearn import svm #support vector machines
from sklearn.naive_bayes import GaussianNB #Naive Bayes
from sklearn import tree #decision tree
from sklearn.metrics import confusion_matrix  # evaluating predictive accuracy
from sklearn.metrics import accuracy_score  # proportion correctly predicted
from sklearn.metrics import roc_curve # import ROC curve
from sklearn.metrics import auc # import AUC
from sklearn.cross_validation import cross_val_score  # cross-validation
from sklearn.cross_validation import train_test_split #used for creating training/test sets
import numpy as np #used for arrays
import matplotlib.pyplot as plt # matplotlib
import pandas as pd  # pandas for data frame operations
from sklearn.externals.six import StringIO 

# initial work with the smaller data set
bank = pd.read_csv('bank-full.csv', sep = ';')  # start with smaller data set

#variables to store FPR and TPR of each model
fpr_master = []
tpr_master = []
model = []
aucs = []

# map binary values to binary variables
convert_to_binary = {'no' : 0, 'yes' : 1}
default = bank['default'].map(convert_to_binary)
housing = bank['housing'].map(convert_to_binary)
loan = bank['loan'].map(convert_to_binary)

# create variabels for numeric attributes
balance = bank['balance']
duration = bank['duration']
age = bank['age']
day = bank['day']
previous = bank['previous']
pdays = bank['pdays']

#create dummy variables for categorical attributes
values_to_dummies = ['month', 'education', 'marital', 'job', 'contact', 'poutcome']
for val in values_to_dummies:
    dummies = pd.get_dummies(bank[val], prefix = val)
    bank = bank.join(dummies)

# arbitrary definition of three classes of jobs where known
job_white_collar = bank['job_admin.'] + bank['job_management'] + bank['job_entrepreneur'] + bank['job_self-employed']
job_blue_collar = bank['job_blue-collar'] + bank['job_services'] + bank['job_technician'] + bank['job_housemaid']
job_other = bank['job_student'] + bank['job_retired'] + bank['job_unemployed']

#create the x and y datasets
y_data = bank['y'].map(convert_to_binary)
x_data = np.array([np.array(default), np.array(housing), np.array(loan),
    np.array(balance), np.array(duration), np.array(age), np.array(day),
    np.array(previous), np.array(pdays), np.array(job_white_collar),
    np.array(job_blue_collar), np.array(job_other), np.array(bank['month_jan']),
    np.array(bank['month_feb']), np.array(bank['month_mar']), np.array(bank['month_apr']),
    np.array(bank['month_may']), np.array(bank['month_jun']), np.array(bank['month_jul']),
    np.array(bank['month_aug']), np.array(bank['month_sep']), np.array(bank['month_oct']),
    np.array(bank['month_nov']), np.array(bank['month_dec']), np.array(bank['marital_married']), np.array(bank['marital_single']),
    np.array(bank['marital_divorced']), np.array(bank['education_unknown']), np.array(bank['education_primary']),
    np.array(bank['education_secondary']), np.array(bank['education_tertiary']), np.array(bank['contact_telephone']),np.array(bank['contact_cellular']),
    np.array(bank['contact_unknown']),np.array(bank['poutcome_success']),np.array(bank['poutcome_failure']),
    np.array(bank['poutcome_other']), np.array(bank['poutcome_unknown'])]).T
    
# create names array so you can refer to it later when analyzing the coefficients
names = ['default', 'housing', 'loan', 'balance', 'duration', 'age', 'day', 'previous', 'pdays', 
        'job_white_collar', 'job_blue_collar', 'job_other', 'month_jan', 'month_feb', 'month_mar', 
        'month_apr', 'month_may', 'month_jun', 'month_jul', 'month_aug', 'month_sep', 'month_oct', 
        'month_nov', 'month_dec', 'marital_married', 'marital_single', 'marital_divorced', 
        'education_unknown', 'education_primary', 'education_secondary', 'education_tertiary', 
        'contact_telephone', 'contact_cellular', 'contact_unknown', 'poutcome_success', 
        'poutcome_failure', 'poutcome_other', 'poutcome_unknown']
    
#create your training and test data sets
x_train, x_test, y_train, y_test = train_test_split(x_data, y_data, test_size=0.30, random_state=9999)
    
# -------------------------------------------------------------------
# Create the Linear SVC Model
# ------------------------------------------------------------------- 

#fit the linear svc model
svc = svm.LinearSVC()
svc_model_fit = svc.fit(x_train, y_train)

# predicted class in training data only
y_pred = svc_model_fit.predict(x_test)
print '\nLinear SVC Results:'
print 'Confusion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for Linear SVC
y_test_prob = svc_model_fit.decision_function(x_test)
fpr, tpr, thresholds = roc_curve(y_test, y_test_prob)
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('SVM')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_svc = cross_val_score(svc, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_svc.mean(),3),'\n'  # cross-validation average accuracy

# -------------------------------------------------------------------
# Create the Logistic Regression Model
# ------------------------------------------------------------------- 
# fit a logistic regression model 
logreg = linear_model.LogisticRegression(C=1e5, class_weight = 'auto')
log_model_fit = logreg.fit(x_train, y_train)

# predicted class in training data only
y_pred = log_model_fit.predict(x_test)
print 'Logistic Regression Results:'
print'Confusion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for Logistic Regression
y_test_prob = log_model_fit.predict_proba(x_test)
fpr, tpr, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('LR')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_log = cross_val_score(logreg, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_log.mean(),3),'\n'  # cross-validation average accuracy

# -------------------------------------------------------------------
# Create the Naive Bayes Model
# ------------------------------------------------------------------- 

#fit the linear svc model
gnb = GaussianNB()
gnb_model_fit = gnb.fit(x_train, y_train)

# predicted class in training data only
y_pred = gnb_model_fit.predict(x_test)
print 'Gaussian Naive Bayes Results:'
print 'Confusion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for NB
y_test_prob = gnb_model_fit.predict_proba(x_test)
fpr, tpr, thresholds = roc_curve(y_test, y_test_prob[:, 1])
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
myTree = tree.DecisionTreeClassifier(random_state = 9999, criterion='entropy', max_depth=6, min_samples_leaf=5)
tree_model_fit = myTree.fit(x_train, y_train)

# predicted class in training data only
y_pred = tree_model_fit.predict(x_test)
print '\nDecision Tree Results:'
print 'Confusion Matrix:\n',confusion_matrix(y_test, y_pred)
print 'Accuracy Score:',round(accuracy_score(y_test, y_pred), 3)

#calculate the TPR/FPR for NB
y_test_prob = tree_model_fit.predict_proba(x_test)
fpr, tpr, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_auc = auc(fpr, tpr)
print "AUC : %f" % roc_auc
fpr_master.append(fpr)
tpr_master.append(tpr)
model.append('DT')
aucs.append(roc_auc)

# how about multi-fold cross-validation with 5 folds
cv_results_tree = cross_val_score(myTree, x_train, y_train, cv=5)
print 'CV Results:',round(cv_results_tree.mean(),3)  # cross-validation average accuracy

#save the decision tree models to .dot files in a specific directory
with open('./tree/dt.dot', 'w') as f:
    f = tree.export_graphviz(tree_model_fit, out_file=f)

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
# Analyze most important coefficients of Logistic Regression Model
# ------------------------------------------------------------------- 

coefDF = pd.DataFrame(log_model_fit.coef_[0].T, index=names)
coefDF.plot(figsize=(15,10), kind='barh', legend=False, sort_columns=False)
plt.title('Logistic Regression Coefficients')
plt.savefig('coef_chart/logreg_coef', dpi=100)

# -------------------------------------------------------------------
# Analyze most important features of the Decision Tree Model
# ------------------------------------------------------------------- 

coefDF = pd.DataFrame(tree_model_fit.feature_importances_.T, index=names)
coefDF.plot(figsize=(15,10), kind='barh', legend=False, sort_columns=False)
plt.title('Decision Tree Important Features')
plt.savefig('coef_chart/tree_important_features', dpi=100)