function [k, b] = LineFunctions_Sensor(x, sensor)
% obtain 8 line functions given by sensor
% p1_front_local represents the right line at front, in local frame
% p1_front       represents the right line at front, in world frame
%
% p2_front_local represents the left line at front, in local frame
% p2_front       represents the left line at front, in world frame
%
% k{1}(1) represents the slope of the right line at front
% k{1}(2) represents the slope of the left line at front
% k{2} is slopes of lines at back
% k{3} is slopes of lines at left
% k{4} is slopes of lines at right

k = [];
b = [];
r = sensor.range;
a = sensor.bearing/2;

r_s = r * sin(a);
r_c = r * cos(a);

% in local frame, compute points that the sensor can scan at right and left
p1_front_local = [r_s; r_c]; p2_front_local = [-r_s; r_c];

p1_left_local = [-r_c; r_s]; p2_left_local = [-r_c; -r_s];

% transform the two points to world frame
p1_front = Local2World(x, p1_front_local);
p2_front = Local2World(x, p2_front_local);

p1_left = Local2World(x, p1_left_local);
p2_left = Local2World(x, p2_left_local);

% obtain the parameters for the three lines
params = [p1_front(1) 1; x(1) 1] \ [p1_front(2); x(2)];
k{1}(1) = params(1); b{1}(1) = params(2);

params = [p2_front(1) 1; x(1) 1] \ [p2_front(2); x(2)];
k{1}(2) = params(1); b{1}(2) = params(2);

params = [p1_left(1) 1; x(1) 1] \ [p1_left(2); x(2)];
k{3}(1) = params(1); b{3}(1) = params(2);

params = [p2_left(1) 1; x(1) 1] \ [p2_left(2); x(2)];
k{3}(2) = params(1); b{3}(2) = params(2);

% since back lines and right lines are the same as front and left
k{2}(1) = k{1}(1); b{2}(1) = b{1}(1);

k{2}(2) = k{1}(2); b{2}(2) = b{1}(2);

k{4}(1) = k{3}(1); b{4}(1) = b{3}(1);

k{4}(2) = k{3}(2); b{4}(2) = b{3}(2);

end