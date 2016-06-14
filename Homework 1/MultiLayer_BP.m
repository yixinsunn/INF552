clear; close all; clc;

%% setup environment
% a struct containing network information e.g. layer sizes
ei = [];

addpath('C:\Users\Administrator\Desktop\Machine Learnning\INF552\HW1\Wall-Following_Robot_Navigation');

%% import data, and divide it into 5 parts
[AllData data1 data2 data3 data4 data5] = DataProcessing('sensor_readings_4.data');

% obtain 5 training data and 5 test data, 5-fold cross-validation
% The labels are normalized here.
[data_train labels_train data_test labels_test] = TrainingTest(data1,data2,data3,data4,data5);

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

%% run training
cost = 1;
epochs = 0;
hold on
while (cost > 0.01)
[params, cost, grad, pred] = Backpropagation(params, ei, data_train, labels_train, false);
epochs = epochs + 1;
plot(epochs, cost, 'b.')
end

%% compute accuracy on the train and test set
opt_params = params;
[~, ~, ~, pred] = Backpropagation(opt_params, ei, data_train, [], true);
acc_train = length(find(round(3*pred) == (3*labels_train))) / length(labels_train);
fprintf('train accuracy: %f\n', acc_train);

[~, ~, ~, pred] = Backpropagation(opt_params, ei, data_test, [], true);
acc_test = length(find(round(3*pred) == (3*labels_test))) / length(labels_test);
fprintf('test accuracy: %f\n', acc_test);
fprintf('mean squared error: %f\nnorm of gradient: %f\n', ...
    [cost; norm(grad)]);