
# coding: utf-8

import numpy as np
import pandas as pd
import tensorflow as tf
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import MinMaxScaler

data = pd.read_csv('C:/Users/yixin/Desktop/sensor_readings_4.csv', header=None)

scaler = MinMaxScaler(feature_range=(0, 1))
X_train, X_test, y_train, y_test = train_test_split(data[[0, 1, 2, 3]], data[4], test_size=0.3)
X_train, X_test = X_train.values, X_test.values
y_train, y_test = scaler.fit_transform(y_train[:, np.newaxis]), scaler.transform(y_test[:, np.newaxis])

tf.device('/gpu:0')

# Define add_layer function
def add_layer(X, in_size, out_size, activation_func=None, keep_prob=1):
    W = tf.Variable(tf.random_normal([in_size, out_size], stddev=0.1), name='weights')
    b = tf.Variable(tf.zeros([1, out_size]) + 0.1, name='bias')
    with tf.name_scope('XW_plus_b'):
        XW_plus_b = tf.add(tf.matmul(X, W), b)
    XW_plus_b = tf.nn.dropout(XW_plus_b, keep_prob)
    
    if activation_func:
        return activation_func(XW_plus_b)
    return XW_plus_b



input_dim = 4
output_dim = 1
num_neuron = 6
learning_rate = 0.5

# Define placeholder for inputs
X = tf.placeholder(tf.float32, [None, input_dim])
y = tf.placeholder(tf.float32, [None, output_dim])

# Add a hidden layer and an output layer
l1 = add_layer(X, input_dim, num_neuron, activation_func=tf.sigmoid)
pred = add_layer(l1, num_neuron, output_dim, activation_func=tf.sigmoid)

# Define loss function and optimization method
loss = tf.reduce_mean(tf.reduce_sum(tf.square(y - pred), 
                                    reduction_indices=[1]))
train_step = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss)

# Initialization
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)

# Training
prev_loss, curr_loss = 0x7fffffff, sess.run(loss, feed_dict={X: X_train, y: y_train})
while prev_loss - curr_loss > 1e-12:
    sess.run(train_step, feed_dict={X: X_train, y: y_train})
    prev_loss = curr_loss
    curr_loss = sess.run(loss, feed_dict={X: X_train, y: y_train})

# Make predictions using trained model
yhat_train = sess.run(pred, feed_dict={X: X_train, y: y_train})
yhat_test = sess.run(pred, feed_dict={X: X_test, y: y_test})
print('Accuracy on training set: {}'.format(accuracy_score((y_train * 3), np.round(yhat_train * 3))))
print('Accuracy on test set: {}'.format(accuracy_score(y_test * 3, np.round(yhat_test * 3))))
