import pandas as pd
import numpy as np
from sklearn import svm
from sklearn import preprocessing
from sklearn.metrics import accuracy_score
from sklearn.neighbors import KNeighborsClassifier

'''## -----------------Read and Re-list Data----------------- ##
def ReadData(Data):
	csvfile = open(Data)
	csvread = csv.reader(csvfile, delimiter = ',', quotechar = '\n')
	data = list(csvread)
	first_row = data[0]
	data.remove(first_row)

	return data'''



## ----------------------Split Data for Cross Validation----------------------- ##
#  This function split data randomly into k disjoint
#  subsets of numExamples/k training examples each
#  CV_or_Not: true means do cross validation, false means do not

def SplitData(k, Data, CV_or_Not):
	numExamples = len(Data)                    # number of all examples
	p = numExamples/k

	#features = Data[[3,4,5,6,9,10,11,12]]     # pick up the columns of features and labels
	features = Data[[6,10,11,12]]
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



## ---------------Calculate the number of each label--------------- ##
# This function calculates how many times each label occurs
# Labels is a matrix containing many arrays
def Count(Data):
	Labels = np.array(Data[['TIME _PERIOD']])       # obtain the column of labels
	numLabels = {}

	for label in Labels:
		label = label[0]

		if label in numLabels:
			numLabels[label] += 1
		else:
			numLabels[label]  = 1

	return numLabels



## ------------------------------------Main, SVM--------------------------------------- ##
# obtain training data and test data
data = pd.read_csv('LA_CRIMESDATA.csv', sep = ',')
data_train, data_test, label_train, label_test = SplitData(5, data, False)

# calculate the number of each label
numLabels = Count(data)
print numLabels

# scale the features in training data and test data
data_train, data_test = PreprocessData(data_train, data_test)

'''## ------------SVM
clf = svm.SVC(C=1.0, cache_size=200, class_weight=None, coef0=0.0,
    decision_function_shape='ovr', degree=3, gamma='auto', kernel='linear',
    max_iter=-1, probability=False, random_state=None, shrinking=True,
    tol=0.001, verbose=False)

clf.fit(data_train[:20000,:], label_train[:20000,:])

label_pred = clf.predict(data_train[0:8500])
label_true = label_train[0:8500]
print accuracy_score(label_true, label_pred)

label_pred = clf.predict(data_test[0:8500])
label_true = label_test[0:8500]
print accuracy_score(label_true, label_pred)'''

## ------------KNN
neigh = KNeighborsClassifier(n_neighbors = 5, algorithm = 'auto', p = 2)
neigh.fit(data_train, label_train)

label_pred = neigh.predict(data_train)
label_true = label_train
print accuracy_score(label_true, label_pred)

label_pred = neigh.predict(data_test)
label_true = label_test
print accuracy_score(label_true, label_pred)