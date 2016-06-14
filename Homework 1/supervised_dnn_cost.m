function [cost, grad, pred] = supervised_dnn_cost(theta, ei, data, labels, pred_only)
% does all the work of cost / gradient computation
% returns squared-error cost, weight norm, and prox reg

%% default values
po = false;
if exist('pred_only', 'var')
    po = pred_only;
end

%% reshape into network
errors = [];
stack = param2stack(theta, ei);
numLayers = numel(ei.layer_sizes);
numData = size(data, 2);
hAct = cell(numLayers, 1);
gradStack = cell(numLayers, 1);


for i = 1:numData
%% forward propagation
for l = 1:numLayers
    if l == 1
        z = stack{l}.W * data(:,i) + stack{l}.b;
        hAct{l}.outputs(:,i) = sigmoid(z);
    else
        z = stack{l}.W * hAct{l-1}.outputs(:,i) + stack{l}.b;
        hAct{l}.outputs(:,i) = sigmoid(z);
    end
end

%% return here if only predictions desired
if po
    cost = 0;
    grad = [];
    pred = hAct{numLayers}.outputs;
    return;
end

%% compute cost    
% sum of squared errors
J1 = sum((hAct{numLayers}.outputs(:,i) - labels(:,i)).^2);

% sum of squared weights
J2 = 0;
for l = 1:numLayers
    J2 = J2 + sum(sum((stack{l}.W).^2));
end

cost = J1/numData + 0.5 * ei.lambda * J2;

%% compute errors
% errors in output layer
errors{numLayers}.val(:,i) = -(labels(:,i)-hAct{numLayers}.outputs(:,i)) .* hAct{numLayers}.outputs(:,i) .* (1-hAct{numLayers}.outputs(:,i));

% errors in hidden layers
for l = numLayers-1 : 1
    errors{l}.val(:,i) = (stack{l+1}.W' * errors{l+1}.val(:,i)) .* hAct{l}.outputs(:,i) .* (1-hAct{l}.outputs(:,i));
end

%% compute gradients using backpropagation
for l = 1 : numLayers
    if l == 1
        gradStack{l}.W = errors{l}.val(:,i) * data(:,i)';
    else
        gradStack{l}.W = errors{l}.val(:,i) * hAct{l-1}.outputs(:,i)';
    end
    
    gradStack{l}.b = errors{l}.val(:,i);
end

%% reshape gradients into vector
[grad] = stack2params(gradStack);

end

end