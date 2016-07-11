from __future__ import print_function
import pandas as pd
import numpy as np
from sklearn import preprocessing
from sklearn.svm import SVC
from sklearn.ensemble import ExtraTreesClassifier
from sklearn.feature_selection import f_classif, RFECV, SelectKBest
from sklearn.cross_validation import StratifiedKFold



## ----------------------Split Data for Cross Validation----------------------- ##
#  This function split data randomly into k disjoint
#  subsets of numExamples/k training examples each
#  CV_or_Not: true means do cross validation, false means do not

def SplitData(k, Data, CV_or_Not):
	numExamples = len(Data)                    # number of all examples
	p = numExamples/k

	features = Data[[3,4,6,9,10,11]]         # pick up the columns of features and labels
	labels   = Data[['TIME _PERIOD']]

#   not choose to do cross-validation
	if CV_or_Not == False:
		data_test   = pd.DataFrame.as_matrix(features.ix[: p-1])      # the first numExamples/k examples form the test data
		label_test  = pd.DataFrame.as_matrix(labels.ix[: p-1])

		data_train  = pd.DataFrame.as_matrix(features.ix[p :])        # the rest forms the training data
		label_train = pd.DataFrame.as_matrix(labels.ix[p :])

		data_train  = np.ascontiguousarray(data_train, dtype=np.float64)     # transform training data and test data
		label_train = np.ascontiguousarray(label_train, dtype=np.float64)    # into C-ordered contiguous,
		data_test   = np.ascontiguousarray(data_test, dtype=np.float64)      # and double precision arrays
		label_test  = np.ascontiguousarray(label_test, dtype=np.float64)

#   choose to do cross
	if CV_or_Not == True:	

		data_test   = {}
		label_test  = {}
		data_train  = {}
		label_train = {}

		for i in range(0, k):
			data_test[i]  = pd.DataFrame.as_matrix(features.ix[i*p : (i+1)*p-1])
			label_test[i] = pd.DataFrame.as_matrix(labels.ix[i*p : (i+1)*p-1])

			index = range(0, i*p)
			index1 = range((i+1)*p, numExamples)
			index.extend(index1)                 # this is the indices of training examples

			data_train[i]  = pd.DataFrame.as_matrix(features.ix[index])
			label_train[i] = pd.DataFrame.as_matrix(labels.ix[index])

			data_train[i]  = np.ascontiguousarray(data_train[i], dtype=np.float64)
			label_train[i] = np.ascontiguousarray(label_train[i], dtype=np.float64)
			data_test[i]   = np.ascontiguousarray(data_test[i], dtype=np.float64)
			label_test[i]  = np.ascontiguousarray(label_test[i], dtype=np.float64)

	return (data_train, data_test, label_train, label_test)



## ---------------------------Preprocess Data-------------------------- ##
#  This function removes the mean value of each feature
#  then scale it by dividing non-constant features
#  by their standard deviation
def PreprocessData(features_train, features_test):
	scaler = preprocessing.StandardScaler().fit(features_train)

	data_train = scaler.transform(features_train)
	data_test  = scaler.transform(features_test)

	return (data_train, data_test)



## --------------- 1. Use Forest to Evaluate the Feature Importances -------------- ##
# obtain training data and test data
data = pd.read_csv('CrimeData_Downtown.csv', sep = ',')
data_train, data_test, label_train, label_test = SplitData(5, data, False)

# scale the features in training data and test data
data_train, data_test = PreprocessData(data_train, data_test)


clf = ExtraTreesClassifier()
clf = clf.fit(data_train, label_train)

features = data[[3,4,6,9,10,11]]         # equivalent to 'data_train', but in 'DataFrame'
FeatureImportance = {}

print(features.shape[1])

for i in range(features.shape[1]):
	Name = features.columns[i]
	FeatureImportance[Name] = clf.feature_importances_[i]    # a dictionary with score of each label

print("Importances Score Using Forest:",
	sorted(FeatureImportance.iteritems(), key=lambda d:d[1], reverse = True),
	sep="\n", end="\n\n")



## ------------ 2. Use Recursive Feature Elimination with Cross-validation -------------- ##
# http://scikit-learn.org/stable/auto_examples/feature_selection/plot_rfe_with_cross_validation.html
X = data_train[:4000]
y = np.empty((len(X)))

for i in range(len(X)):
	y[i] = label_train[i][0]

# create the RFE object and compute a cross-validated score.
svc = SVC(kernel="linear")

# the "accuracy" scoring is proportional to the number of correct
# classifications
rfecv = RFECV(estimator=svc, step=1, cv=StratifiedKFold(y, 2),
              scoring='accuracy')
rfecv.fit(X, y)

print("Optimal number of features : %d" % rfecv.n_features_)



## --------------------------- 3. Use K Highest Scores --------------------------- ##
K = rfecv.n_features_
K_Best = []

X_new = SelectKBest(f_classif, k = K).fit_transform(data_train, label_train)

for i in range(K):
	index = np.where(data_train[0, :] == X_new[0, i])     # obtain the indices of best features in data_train
	index = index[0][0]
	FeatureName = features.columns[index]
	K_Best.append(FeatureName)

print ("The", K, "Best Feartures are", K_Best, end="\n\n")