function p_local = world2local(x, p)
% this function transform a point from world frame to local frame

r = x(1:2);
theta = x(3);

rotation = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];

p_local = rotation' * (p - r);

end