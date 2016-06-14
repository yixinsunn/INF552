function x = Odometry(x, u)

rot1 = u(1);
trans = u(2);
rot2 = u(3);

theta = x(3);

x = x + [...
    trans * cos(theta + rot1);
    trans * sin(theta + rot1);
    rot1 + rot2];

if x(3) < -pi
    x(3) = x(3) + 2*pi;
end
if x(3) > pi
    x(3) = x(3) - 2*pi;
end

end