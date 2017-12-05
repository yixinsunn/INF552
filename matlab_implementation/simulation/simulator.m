clear;clc;close all;clf;

%% Load variables
addpath('..\Wall-Following_Robot_Navigation');

% load neural network output weights given by multilayer_neural_network.m
opt_weights = load('output_weights_4.mat');
% load a simple map graph
load('example_densemap2.mat');

%% populate ei with the network architecture
ei = [];
ei.input_dim = 4;
ei.output_dim = 1;
% sizes of all hidden layers and the output layer
ei.layer_sizes = [6, ei.output_dim];
% scaling parameter for weight regularization penaty
ei.lambda = 0;
ei.activation_fun = 'logistic';

%% Setup plots
figure(1); hold on; axis equal;
plot(wp(1,:),wp(2,:), 'k', wp(1,:),wp(2,:),'k.')
line([wp(1,1) wp(1,end)], [wp(2,1) wp(2,end)], 'color', 'k')
xlabel('meters'), ylabel('meters')
set(gcf,'doublebuffer','on');

%% Initialize variables
% length of the experiments
numSteps = 10000;

% setting of the sensors specs
sensor = [];
sensor.bearing = pi/3;    % Degrees
sensor.range = 5;         % Meters

% noise to be added
% SensorNoise = 0.5 * randn(2,1);
% SensorNoise = [-0.47214208099745;0.419190146407549];
% sensor.bearing = pi/3 + SensorNoise(1);
% sensor.range   = 5 + SensorNoise(2);

% initial position of the vehicle
x = [-20; -6; 0];

% line functions in map
[k_map, b_map] = line_functions_in_map(wp);

%% Simulator
for t = 1 : numSteps
    % line functions of sensor
    [k, b] = line_functions_sensor(x, sensor);

    % compute 4 distances
    distance = computeDistance(x, sensor, wp, k_map, b_map, k, b);

    % predict next motion according to prediction made by
    % multilayer_neural_network
    [~, ~, ~, pred] = backpropagation(opt_weights, ei, distance, [], true);
    pred = round(3 * pred);
    
    if pred == 0
       u = [0; -1; 0]; x = odometry(x, u); % u is control vector, u(1) is rot1
       legend(sprintf('Move Forward'))    % u(2) is trans, u(3) is rot2
       
    elseif pred == 1
       u = [-pi/24; -0.7; -pi/24]; x = odometry(x, u); 
       legend(sprintf('Slight Right'))
       
    elseif pred == 2
       u = [-pi/24; -0.3; -pi/24]; x = odometry(x, u);
       legend(sprintf('Sharp Right'))
       
    elseif pred == 3
       u = [pi/12; -0.5; pi/12]; x = odometry(x, u);
       legend(sprintf('Slight Left'))
    end

    % draw path of the robot
    cla;
    plot(wp(1,:),wp(2,:), 'k', wp(1,:),wp(2,:),'k.')
    line([wp(1,1) wp(1,end)], [wp(2,1) wp(2,end)], 'color', 'k')
    drawRobot(x, [0 1]);
    drawSector(x, sensor);
    drawnow;

end