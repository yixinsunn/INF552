function p = local2world(x, p_local)
% this function transform a point from local frame to world frame

r = x(1:2);
theta = x(3);

rotation = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];

p = rotation * p_local + r;

end