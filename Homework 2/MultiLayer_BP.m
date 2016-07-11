clear; close all; clc;

%% setup environment
% a struct containing network information e.g. layer sizes
ei = [];

load('CrimeData.mat')

%% import data, and divide it into 5 parts
[data_train label_train data_test label_test] = DataProcessing(RawData, 5, false);

%% populate ei with the network architecture to train
% dimension of input features;
ei.input_dim = 4;
% number of output classes
ei.output_dim = 1;
% sizes of all hidden layers and the output layer
ei.layer_sizes = [5, ei.output_dim];
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
while (cost > 1e-4)
[params, cost, grad, pred] = Backpropagation(params, ei, data_train(:,40000), label_train(:,40000), false);
epochs = epochs + 1;
plot(epochs, cost, 'b.')
end

%% compute accuracy on the train and test set
opt_params = params;
[~, ~, ~, pred] = Backpropagation(opt_params, ei, data_train, [], true);
acc_train = length(find(round(11*pred) == (11*label_train))) / length(label_train);
fprintf('train accuracy: %f\n', acc_train);

[~, ~, ~, pred] = Backpropagation(opt_params, ei, data_test, [], true);
acc_test = length(find(round(11*pred) == (11*label_test))) / length(label_test);
fprintf('test accuracy: %f\n', acc_test);
fprintf('mean squared error: %f\nnorm of gradient: %f\n', ...
    [cost; norm(grad)]);