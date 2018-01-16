clear; close all; clc;

%% Setup environment
% a struct containing network information e.g. layer sizes
ei = [];

addpath('.\Wall-Following_Robot_Navigation');

%% Import data, and divide it into 5 parts
[rawData, data1, data2, data3, data4, data5] = split_data('sensor_readings_4.data');

% Obtain training data and test data
% labels are normalized here.
[X_train, y_train, X_test, y_test] = train_test_split(data1,data2,data3,data4,data5);

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
weights = stack2params(stack);

%% run training
cost = 1;       % initialize the value of cost function
epochs = 0;
hold on
while (cost > 0.01)
[weights, cost, grad, ~] = backpropagation(weights, ei, X_train, y_train, false);
epochs = epochs + 1;
plot(epochs, cost, 'b.')
end

%% compute accuracy on the train and test set
opt_weights = weights;
[~, ~, ~, pred] = Backpropagation(opt_weights, ei, X_train, [], true);
acc_train = mean(round(3 * pred) == (3 * y_train));
fprintf('Train accuracy: %f\n', acc_train);

[~, ~, ~, pred] = Backpropagation(opt_weights, ei, X_test, [], true);
acc_test = mean(round(3 * pred) == (3*y_test));
fprintf('test accuracy: %f\n', acc_test);
fprintf('mean squared error: %f\nnorm of gradient: %f\n', ...
    [cost; norm(grad)]);