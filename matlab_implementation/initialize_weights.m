function [ stack ] = initialize_weights( ei )
% this function initialize weight structure randomly
% for a network architecture
%   
%   This uses Xavier's weight initialization tricks for better backprop
%   See: X. Glorot, Y. Bengio. Understanding the difficulty of training 
%        deep feedforward neural networks.

%% initialize hidden layers
stack = cell(1, numel(ei.layer_sizes));
for l = 1 : numel(ei.layer_sizes)
    if l > 1
        prev_size = ei.layer_sizes(l-1);
    else
        prev_size = ei.input_dim;
    end
    current_size = ei.layer_sizes(l);
    
    % Xavier's scaling factor
    s = sqrt(6/(prev_size + current_size));
    stack{l}.W = 2*s * rand(current_size, prev_size) - s;
    stack{l}.b = zeros(current_size, 1);
end