function [K, B] = LineFunctions_in_Map(points)
% obtains line functions between 2 points in map

K = [];
B = [];
numPoints = size(points,2);

for i = 1:numPoints
    if i == numPoints
        x1 = points(1,i);
        y1 = points(2,i);
        x2 = points(1,1);
        y2 = points(2,1);
    else
        x1 = points(1,i);
        y1 = points(2,i);
        x2 = points(1,i+1);
        y2 = points(2,i+1);
    end
    
    params = [x2 1; x1 1] \ [y2; y1];
    K(i) = params(1);
    B(i) = params(2);
end

end