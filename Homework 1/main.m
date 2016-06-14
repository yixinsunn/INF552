clear; close all; clc;

%% setup environment
% a struct containing network information e.g. layer sizes
ei = [];

addpath('C:\Users\Administrator\Desktop\Machine Learnning\INF552\HW1\Wall-Following_Robot_Navigation');
addpath('C:\Users\Administrator\Desktop\Machine Learnning\INF552\HW1\minFunc');

%% import data, and divide it into 5 parts
[AllData data1 data2 data3 data4 data5] = DataProcessing('sensor_readings_4.data');

% obtain 5 training data and 5 test data, 5-fold cross-validation
% The labels are normalized here.
[data_train1 labels_train1 data_test1 labels_test1] = TrainingTest(data1,data2,data3,data4,data5);

%% populate ei with the network architecture to train
% dimension of input features;
ei.input_dim = 4;
% number of output classes
ei.output_dim = 1;
% sizes of all hidden layers and the output layer
ei.layer_sizes = [6, ei.output_dim];
% scaling parameter for weight regularization penaty
ei.lambda = 0;
% type of activation function to use in hidden layers
ei.activation_fun = 'logistic';

%% setup random initial weights
stack = initialize_weights(ei);
params = stack2params(stack);

%% setup minfunc options
options = [];
options.display = 'iter';
options.maxFunEvals = 1e6;
options.Method = 'lbfgs';

%% run training
[opt_params,opt_value,exitflag,output] = minFunc(@supervised_dnn_cost, ...
    params, options, ei, data_train1, labels_train1);

%% compute accuracy on the test and train set
[~, ~, pred] = supervised_dnn_cost( opt_params, ei, data_test1, [], true);

[~, ~, pred1] = supervised_dnn_cost( opt_params, ei, data_train1, [], true);