function DrawRobot(x, forwards)

ShiftAngel = atan2(forwards(2), forwards(1));

p = 0.02;    % percentage of axes size
a = axis;
l1 = (a(2) - a(1)) * p;
l2 = (a(4) - a(3)) * p;

triangle = [1 1 -2 1; 1 -1 0 1];  % basic triangle

theta = x(3) - pi/2 + ShiftAngel;    % rotate to point along x axis
Rotation = [cos(theta) -sin(theta); sin(theta) cos(theta)];
triangle = Rotation * triangle;      % rotate the triangle by theta

triangle(1,:) = triangle(1,:) * l1 + x(1);  % scale and shift to x, y
triangle(2,:) = triangle(2,:) * l2 + x(2);

G = plot(triangle(1,:), triangle(2,:), 'b', 'LineWidth', 0.15);
plot(x(1), x(2))