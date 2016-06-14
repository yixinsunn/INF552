function DrawSector(x, sensor)

% (x0,y0) is the origin of the sector, (angle1,angle2) is the angle
% r is the radius
x0 = x(1);
y0 = x(2);
theta = x(3);
angle1 = -sensor.bearing/2;
angle2 =  sensor.bearing/2;
r = sensor.range;

t = linspace(angle1, angle2, 100);

x_front = [x0, x0 + r * cos(t+pi/2+theta)];
y_front = [y0, y0 + r * sin(t+pi/2+theta)];
X_front = [x0, x0 + r * cos(angle2+pi/2+theta)];
Y_front = [y0, y0 + r * sin(angle2+pi/2+theta)];

x_back = [x0, x0 + r * cos(t-pi/2+theta)];
y_back = [y0, y0 + r * sin(t-pi/2+theta)];
X_back = [x0, x0 + r * cos(angle2-pi/2+theta)];
Y_back = [y0, y0 + r * sin(angle2-pi/2+theta)];

x_left = [x0, x0 + r * cos(t+pi+theta)];
y_left = [y0, y0 + r * sin(t+pi+theta)];
X_left = [x0, x0 + r * cos(angle2+pi+theta)];
Y_left = [y0, y0 + r * sin(angle2+pi+theta)];

x_right = [x0, x0 + r * cos(t+theta)];
y_right = [y0, y0 + r * sin(t+theta)];
X_right = [x0, x0 + r * cos(angle2+theta)];
Y_right = [y0, y0 + r * sin(angle2+theta)];

plot(x_front, y_front, 'color', 'r', 'linestyle', ':')
plot(x_back, y_back, 'color', 'r', 'linestyle', ':')
plot(x_left, y_left, 'color', 'r', 'linestyle', ':')
plot(x_right, y_right, 'color', 'r', 'linestyle', ':')
line(X_front, Y_front, 'color', 'r', 'linestyle', ':')
line(X_back, Y_back, 'color', 'r', 'linestyle', ':')
line(X_left, Y_left, 'color', 'r', 'linestyle', ':')
line(X_right, Y_right, 'color', 'r', 'linestyle', ':')