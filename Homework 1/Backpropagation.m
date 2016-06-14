function [opt_params, cost, grad, pred] = Backpropagation(theta, ei, data, labels, pred_only)
% does all the work of cost / gradient computation
% returns squared-error cost, weight norm, and prox reg

%% default values
po = false;
if exist('pred_only', 'var')
    po = pred_only;
end

%% reshape into network
a = 0.5;                     % learning rate
errors = [];
numLayers = numel(ei.layer_sizes);
numData = size(data, 2);

stack = param2stack(theta, ei);
hAct = cell(numLayers, 1);
gradStack = cell(numLayers, 1);

%% return here if only predictions desired
if po
    % compute final outputs as the prediction
    for l = 1:numLayers
        if l == 1
            z = stack{l}.W * data + repmat(stack{l}.b, 1, numData);
            hAct{l}.outputs = sigmoid(z);
        else
            z = stack{l}.W * hAct{l-1}.outputs + repmat(stack{l}.b, 1, numData);
            hAct{l}.outputs = sigmoid(z);
        end
    end
    
    pred = hAct{numLayers}.outputs;
    cost = 0;
    grad = [];
    opt_params = theta;
    return;
end


%% --------------------Back-propagation algorithm-----------------%%
for i = 1:numData

    %% forward propagation
    for l = 1:numLayers
        if l == 1
            z = stack{l}.W * data(:,i) + stack{l}.b;
            hAct{l}.outputs = sigmoid(z);
        else
            z = stack{l}.W * hAct{l-1}.outputs + stack{l}.b;
            hAct{l}.outputs = sigmoid(z);
        end
    end

    %% compute gradients using backpropagation
    % errors in output layer
    errors{numLayers}.val = -(labels(:,i)-hAct{numLayers}.outputs) .* hAct{numLayers}.outputs .* (1-hAct{numLayers}.outputs);

    % errors in hidden layers
    for l = numLayers-1 : 1
        errors{l}.val = stack{l+1}.W' * errors{l+1}.val .* hAct{l}.outputs .* (1-hAct{l}.outputs);
    end

    for l = 1 : numLayers
        % partial derivative wrt W
        if l == 1
           gradStack{l}.W = errors{l}.val * data(:,i)';
        else
           gradStack{l}.W = errors{l}.val * hAct{l-1}.outputs';
        end
        % partial derivative wrt b
        gradStack{l}.b = errors{l}.val;
    end
    % updata W and b, using gradient descent
    for l = 1 : numLayers
        stack{l}.W = stack{l}.W - a * gradStack{l}.W;
        stack{l}.b = stack{l}.b - a * gradStack{l}.b;
    end

end
%%--------------------------------------------------------------------------%%


%% reshape gradients and optimal parameters into vector
[grad] = stack2params(gradStack);
opt_params = stack2params(stack);

%% compute final outputs as the prediction
for l = 1:numLayers
    if l == 1
        z = stack{l}.W * data + repmat(stack{l}.b, 1, numData);
        hAct{l}.outputs = sigmoid(z);
    else
        z = stack{l}.W * hAct{l-1}.outputs + repmat(stack{l}.b, 1, numData);
        hAct{l}.outputs = sigmoid(z);
    end
end
pred = hAct{numLayers}.outputs;

%% compute cost
% sum of squared errors
J1 = sum(sum((hAct{numLayers}.outputs - labels).^2));

% sum of squared weights
J2 = 0;
for l = 1:numLayers
    J2 = J2 + sum(sum((stack{l}.W).^2));
end

cost = J1/numData + 0.5 * ei.lambda * J2;

end