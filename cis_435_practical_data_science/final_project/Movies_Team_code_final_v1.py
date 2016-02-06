# CIS 435, MSPA Program
# Movies Team
# Data Mining Modeling for the Final Project

import pandas as pd  # pandas for data frame operations
import pylab as pl
import numpy as np  # efficient processing of numerical arrays
from sklearn import svm
from sklearn import linear_model
from sklearn.naive_bayes import GaussianNB
from sklearn.cross_validation import train_test_split, cross_val_score
from sklearn.metrics import roc_curve, auc, confusion_matrix, accuracy_score


#read in the data
movies = pd.read_csv('movies_preprocessed_culled.csv', na_values=['N/A'])

#drop unneeded variables for analysis
movies = movies.drop(['Plot'],axis=1)
movies = movies.drop(['Title'],axis=1)
movies = movies.drop(['US_Gross'],axis=1)
movies = movies.drop(['Gross_Margin'],axis=1)

movies = movies.dropna() #remove records with missing data

# Understand total number of movies in entire data with target gross margin
movies[('y')].value_counts()
# 648 yes, 6022 no in full dataset

print movies.shape

# look at the beginning of the DataFrame
movies.head()

# ----------------------------------------------------------
# DEFINE VARIABLES FOR MODELING
# ----------------------------------------------------------

# look at the list of column names, note that y is the response
list(movies.columns.values)

#separate response variable from explanatory variables
y = movies['y']

RuntimeMinutes = movies['RuntimeMinutes']
Budget = movies['Budget']
RatedE = movies['Rated=E']
RatedG = movies['Rated=G']
RatedPG = movies['Rated=PG']
RatedPG13 = movies['Rated=PG-13']
RatedR = movies['Rated=R']
Writer = movies['A_List_Writer_Present']
Actor = movies['A_List_Actor_Present']
Director = movies['Top_10_Director']
Scifi = movies['Genre=Sci-Fi']
Comedy = movies['Genre=Comedy']
War = movies['Genre=War']
Horror = movies['Genre=Horror']
Thriller = movies['Genre=Thriller']
Drama = movies['Genre=Drama']
Action = movies['Genre=Action']
Adventure = movies['Genre=Adventure']
WordFreq = movies['WordFreq']

# ----------------------------------------------------------
# CREATE DATA STRUCTURE
# ----------------------------------------------------------

# Gather variables of interest into a numpy array.
# Include variables from original study.
# here we use .T to obtain the transpose for the structure we want
x = np.array([np.array(RuntimeMinutes), np.array(Budget), np.array(RatedE),
    np.array(RatedG), np.array(RatedPG), np.array(RatedPG13),np.array(RatedR),
    np.array(Writer), np.array(Actor), np.array(Director), np.array(Scifi),
    np.array(Comedy), np.array(War), np.array(Horror), np.array(Thriller),
    np.array(Drama), np.array(Action), np.array(Adventure), np.array(WordFreq)]).T

# ----------------------------------------------------------
# CREATE TEST AND TRAINING SETS
# ----------------------------------------------------------

# Uses sklearn.cross_validation
x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.3, random_state = 9999)

# ----------------------------------------------------------
# ANALYZE WITH LOGISTIC MODEL
# ----------------------------------------------------------
import numpy as np
from sklearn import metrics
from sklearn.metrics import accuracy_score
# Fit a logistic regression model
logreg = linear_model.LogisticRegression(class_weight={0:1,1:10})
my_model_fit = logreg.fit(x_train, y_train)
logreg.coef_

# Predicted class in test set using model fit to training set
print('\nLogistic Regression Model Classification Accuracy in Test Set\n')
y_test_pred = my_model_fit.predict(x_test)
print('Confusion Matrix for Test Set')
print(confusion_matrix(y_test, y_test_pred))
print('Classification Accuracy for Test Set:',round(accuracy_score(y_test, y_test_pred), 3))
print "precision:", metrics.precision_score(y_test, y_test_pred)
print "recall:", metrics.recall_score(y_test, y_test_pred)
print "f1_score:", metrics.f1_score(y_test, y_test_pred)

# Conduct cross-validation with 5 folds
cv_results = cross_val_score(logreg, x, y, cv=5)
print(round(cv_results.mean(),3))  

# Create AUC values
y_test_prob = my_model_fit.predict_proba(x_test)
fprlog, tprlog, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_aucLog = auc(fprlog, tprlog)
print('Area Under Curve for Test Set - Logistic:',round(roc_aucLog, 3))

# Plot ROC curve
pl.clf()
pl.plot(fprlog, tprlog, label='ROC curve (AUC = %0.2f)' % roc_aucLog)
pl.plot([0, 1], [0, 1], 'k--')
pl.xlim([0.0, 1.0])
pl.ylim([0.0, 1.0])
pl.xlabel('False Positive Rate')
pl.ylabel('True Positive Rate')
pl.title('Receiver Operating Characteristic - Logistic Regression')
pl.legend(loc="lower right")
pl.show()
pl.savefig('Predict-435-Movies-Logistic.pdf')


# ----------------------------------------------------------
# ANALYZE WITH NAIVE-BAYES
# ----------------------------------------------------------
import numpy as np
from sklearn import metrics
from sklearn.metrics import accuracy_score
# Fit model
gnb = GaussianNB() # cannot use weighting with GaussianNB
NB_model_fit = gnb.fit(x_train, y_train)

# Predicted class in test set using model fit to training set
print('\nNaive Bayes Model Classification Accuracy in Test Set\n')
y_test_pred = NB_model_fit.predict(x_test)
print('Confusion Matrix for Test Set')
print(confusion_matrix(y_test, y_test_pred))
print('Classification Accuracy for Test Set:',round(accuracy_score(y_test, y_test_pred), 3))
print "precision:", metrics.precision_score(y_test, y_test_pred)
print "recall:", metrics.recall_score(y_test, y_test_pred)
print "f1_score:", metrics.f1_score(y_test, y_test_pred)

# Conduct cross-validation with 5 folds
cv_results = cross_val_score(gnb, x, y, cv=5)
print(round(cv_results.mean(),3)) 

# Create AUC values
y_test_prob = NB_model_fit.predict_proba(x_test)
fprNB, tprNB, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_aucNB = auc(fprNB, tprNB)
print('Area Under Curve for Test Set - NB:',round(roc_aucNB, 3))


# Plot ROC curve
pl.clf()
pl.plot(fprNB, tprNB, label='ROC curve (AUC = %0.2f)' % roc_aucNB)
pl.plot([0, 1], [0, 1], 'k--')
pl.xlim([0.0, 1.0])
pl.ylim([0.0, 1.0])
pl.xlabel('False Positive Rate')
pl.ylabel('True Positive Rate')
pl.title('Receiver Operating Characteristic - Naive Bayes')
pl.legend(loc="lower right")
pl.show()
pl.savefig('Predict-435-Movies-NB.pdf')


# ----------------------------------------------------------
# ANALYZE WITH SVM
# ----------------------------------------------------------

# Fit model
SVM = svm.SVC(probability=True)
SVM_model_fit = SVM.fit(x_train, y_train)


# Predicted class in test set using model fit to training set
print('\nSupport Vector Machines Model Classification Accuracy in Test Set\n')
y_test_pred = SVM_model_fit.predict(x_test)
print('Confusion Matrix for Test Set')
print(confusion_matrix(y_test, y_test_pred))
print('Classification Accuracy for Test Set:',round(accuracy_score(y_test, y_test_pred), 3))
print "precision:", metrics.precision_score(y_test, y_test_pred)
print "recall:", metrics.recall_score(y_test, y_test_pred)
print "f1_score:", metrics.f1_score(y_test, y_test_pred)

# Conduct cross-validation with 5 folds
cv_results = cross_val_score(SVM, x, y, cv=5)
print(round(cv_results.mean(),3))  

# Create AUC values
y_test_prob = SVM_model_fit.predict_proba(x_test)
fprsvm, tprsvm, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_aucSVM = auc(fprsvm, tprsvm)
print('Area Under Curve for Test Set - SVM:',round(roc_aucSVM, 3)) 

# Plot ROC curve
pl.clf()
pl.plot(fprsvm, tprsvm, label='ROC curve (AUC = %0.2f)' % roc_aucSVM)
pl.plot([0, 1], [0, 1], 'k--')
pl.xlim([0.0, 1.0])
pl.ylim([0.0, 1.0])
pl.xlabel('False Positive Rate')
pl.ylabel('True Positive Rate')
pl.title('Receiver Operating Characteristic - Support Vector Machines')
pl.legend(loc="lower right")
pl.show()
pl.savefig('Predict-435-Movies-SVM.pdf')

# ----------------------------------------------------------
# ANALYZE WITH TREES
# ----------------------------------------------------------


# define modeling method with random number seed for reproducibility
from sklearn import metrics
from sklearn.metrics import accuracy_score
from sklearn import tree
clf = tree.DecisionTreeClassifier(random_state = 9999)
dt = clf.fit(x, y)  # defines tree classifier object

print('\nTree Model Classification Accuracy in Test Set\n')
y_test_pred = dt.predict(x_test)
print('Confusion Matrix for Test Set')
print(confusion_matrix(y_test, y_test_pred))
print('Classification Accuracy for Test Set:',round(accuracy_score(y_test, y_test_pred), 3))
print "precision:", metrics.precision_score(y_test, y_test_pred)
print "recall:", metrics.recall_score(y_test, y_test_pred)
print "f1_score:", metrics.f1_score(y_test, y_test_pred)

# Conduct cross-validation with 5 folds
cv_results = cross_val_score(clf, x, y, cv=5)
print(round(cv_results.mean(),3))  

# Create AUC values
y_test_prob = dt.predict_proba(x_test)
fprdt, tprdt, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_aucdt = auc(fprdt, tprdt)
print('Area Under Curve for Test Set - DT:',round(roc_aucdt, 3))


# Plot ROC curve
pl.clf()
pl.plot(fprdt, tprdt, label='ROC curve (AUC = %0.2f)' % roc_aucdt)
pl.plot([0, 1], [0, 1], 'k--')
pl.xlim([0.0, 1.0])
pl.ylim([0.0, 1.0])
pl.xlabel('False Positive Rate')
pl.ylabel('True Positive Rate')
pl.title('Receiver Operating Characteristic - Decision Tree')
pl.legend(loc="lower right")
pl.show()
pl.savefig('Predict-435-Movies-.pdf')


# ----------------------------------------------------------
# ANALYZE WITH Random Forests
# ----------------------------------------------------------


from sklearn.ensemble import RandomForestClassifier
clf = RandomForestClassifier(n_estimators=10)
rf = clf.fit(x_train, y_train)

print('\nRandom Forest Model Classification Accuracy in Test Set\n')
y_test_pred = rf.predict(x_test)
print('Confusion Matrix for Test Set')
print(confusion_matrix(y_test, y_test_pred))
print('Classification Accuracy for Test Set:',round(accuracy_score(y_test, y_test_pred), 3))
print "precision:", metrics.precision_score(y_test, y_test_pred)
print "recall:", metrics.recall_score(y_test, y_test_pred)
print "f1_score:", metrics.f1_score(y_test, y_test_pred)

# Conduct cross-validation with 5 folds
cv_results = cross_val_score(clf, x, y, cv=5)
print(round(cv_results.mean(),3))  

# Create AUC values
y_test_prob = rf.predict_proba(x_test)
fprrf, tprrf, thresholds = roc_curve(y_test, y_test_prob[:, 1])
roc_aucrf = auc(fprrf, tprrf)
print('Area Under Curve for Test Set - RF:',round(roc_aucrf, 3))

# Plot ROC curve
pl.clf()
pl.plot(fprrf, tprrf, label='ROC curve (AUC = %0.2f)' % roc_aucrf)
pl.plot([0, 1], [0, 1], 'k--')
pl.xlim([0.0, 1.0])
pl.ylim([0.0, 1.0])
pl.xlabel('False Positive Rate')
pl.ylabel('True Positive Rate')
pl.title('Receiver Operating Characteristic - Random Forest')
pl.legend(loc="lower right")
pl.show()
pl.savefig('Predict-435-Movies-.pdf')


# ----------------------------------------------------------
# PLOT ALL CURVES
# ----------------------------------------------------------

# Plot ROC curves
pl.clf()
pl.plot(fprlog, tprlog, label='ROC curve for Logistic(area = %0.2f)' % roc_aucLog)
pl.plot(fprNB, tprNB, label='ROC curve for Naive Bayes(area = %0.2f)' % roc_aucNB)
pl.plot(fprsvm, tprsvm, label='ROC curve for SVM(area = %0.2f)' % roc_aucSVM)
pl.plot(fprdt, tprdt, label='ROC curve for DT(area = %0.2f)' % roc_aucdt)
pl.plot(fprrf, tprrf, label='ROC curve for RF(area = %0.2f)' % roc_aucrf)

pl.plot([0, 1], [0, 1], 'k--')
pl.xlim([0.0, 1.0])
pl.ylim([0.0, 1.0])
pl.xlabel('False Positive Rate')
pl.ylabel('True Positive Rate')
pl.title('Receiver operating characteristic example')
pl.legend(loc="lower right")
pl.show()
pl.savefig('Predict-435-Movies-AllCurves.pdf')
