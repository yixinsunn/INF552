function distance = computeDistance(x, sensor, map, k_map, b_map, k, b)
% computes 4 distances, distance = [front; left; right; back]
%
% in every variable name, '1','2', '3' corresponds to intersections with 
% right line, middle line, left line

sol = []; % a matrix consisting of intersections with arc
m = [];   % m and n are structs consisting of intersections
n = [];   % with right and left lines
minX = []; minY = []; maxX = []; maxY = [];
distance = inf(4,1);
numLines = numel(k_map);
r = sensor.range;
a = sensor.bearing/2;

r_c = r * cos(a);
r_s = r * sin(a);

%% Computes all intersections
for i = 1:numLines
    if i == numLines
        minX(i) = min(map(1,i), map(1,1));
        minY(i) = min(map(2,i), map(2,1));
        maxX(i) = max(map(1,i), map(1,1));
        maxY(i) = max(map(2,i), map(2,1));
    else
        minX(i) = min(map(1,i), map(1,i+1));
        minY(i) = min(map(2,i), map(2,i+1));
        maxX(i) = max(map(1,i), map(1,i+1));
        maxY(i) = max(map(2,i), map(2,i+1));
    end
    
    m{i}(1,1) = (b{1}(1) - b_map(i)) / (k_map(i) - k{1}(1));
    n{i}(1,1) = k_map(i) * m{i}(1,1) + b_map(i);
    
    m{i}(1,2) = (b{1}(2) - b_map(i)) / (k_map(i) - k{1}(2));
    n{i}(1,2) = k_map(i) * m{i}(1,2) + b_map(i);
    
    m{i}(2,1) = (b{2}(1) - b_map(i)) / (k_map(i) - k{2}(1));
    n{i}(2,1) = k_map(i) * m{i}(2,1) + b_map(i);
    
    m{i}(2,2) = (b{2}(2) - b_map(i)) / (k_map(i) - k{2}(2));
    n{i}(2,2) = k_map(i) * m{i}(2,2) + b_map(i);
    
    m{i}(3,1) = (b{3}(1) - b_map(i)) / (k_map(i) - k{3}(1));
    n{i}(3,1) = k_map(i) * m{i}(3,1) + b_map(i);
    
    m{i}(3,2) = (b{3}(2) - b_map(i)) / (k_map(i) - k{3}(2));
    n{i}(3,2) = k_map(i) * m{i}(3,2) + b_map(i);
    
    m{i}(4,1) = (b{4}(1) - b_map(i)) / (k_map(i) - k{4}(1));
    n{i}(4,1) = k_map(i) * m{i}(4,1) + b_map(i);
    
    m{i}(4,2) = (b{4}(2) - b_map(i)) / (k_map(i) - k{4}(2));
    n{i}(4,2) = k_map(i) * m{i}(4,2) + b_map(i);
    
    sol{i}(1,1) = -(b_map(i) - (b_map(i) + k_map(i)*(-b_map(i)^2 ...
        - 2*b_map(i)*k_map(i)*x(1) + 2*b_map(i)*x(2) - k_map(i)^2*x(1)^2 + ...
        k_map(i)^2*r^2 + 2*k_map(i)*x(1)*x(2) - x(2)^2 + r^2)^(1/2) + ...
        k_map(i)*x(1) + k_map(i)^2*x(2))/(k_map(i)^2 + 1))/k_map(i);
    
    sol{i}(1,2) = -(b_map(i) - (b_map(i) - k_map(i)*(-b_map(i)^2 ...
        - 2*b_map(i)*k_map(i)*x(1) + 2*b_map(i)*x(2) - k_map(i)^2*x(1)^2 + ...
        k_map(i)^2*r^2 + 2*k_map(i)*x(1)*x(2) - x(2)^2 + r^2)^(1/2) + ...
        k_map(i)*x(1) + k_map(i)^2*x(2))/(k_map(i)^2 + 1))/k_map(i);
    
    sol{i}(2,1) = (b_map(i) + k_map(i)*(-b_map(i)^2 - 2*b_map(i)*k_map(i)*x(1) ...
        + 2*b_map(i)*x(2) - k_map(i)^2*x(1)^2 + k_map(i)^2*r^2 + 2*k_map(i)*x(1)*x(2) ...
        - x(2)^2 + r^2)^(1/2) + k_map(i)*x(1) + k_map(i)^2*x(2))/(k_map(i)^2 + 1);
    
    sol{i}(2,2) = (b_map(i) - k_map(i)*(-b_map(i)^2 - 2*b_map(i)*k_map(i)*x(1) ...
        + 2*b_map(i)*x(2) - k_map(i)^2*x(1)^2 + k_map(i)^2*r^2 + 2*k_map(i)*x(1)*x(2) ...
        - x(2)^2 + r^2)^(1/2) + k_map(i)*x(1) + k_map(i)^2*x(2))/(k_map(i)^2 + 1);
    
    dist = sum((sol{i} - repmat(x(1:2), 1, 2)).^2);
    % there are two intersections with a circle
    % we only consider the one which is close to the robot
    [~, ind] = min(dist);
    sol{i} = sol{i}(:,ind);
end     

%% --------------------compute front distance--------------------%%
solutionSet = [];

for i = 1:numLines
    % first, compute the intersection with right line
    if (m{i}(1,1) >= minX(i) && m{i}(1,1) <= maxX(i) && ...
            n{i}(1,1) >= minY(i) && n{i}(1,1) <= maxY(i))
        
        % transform the intersection from world frame to local frame
        p = [m{i}(1,1); n{i}(1,1)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
            
        % whether the intersection is in the zone of sensor?
        if (px > 0 && px <= r_s && py > 0 && py <= r_c)
            solutionSet = [solutionSet, p];
        end
    end
   
    % second, compute the intersections with arc
    if (sol{i}(1) >= minX(i) && sol{i}(1) <= maxX(i) && ...
            sol{i}(2) >= minY(i) && sol{i}(2) <= maxY(i))
        
        p_local = world2local(x, sol{i});
        px = p_local(1); py = p_local(2);
         
        if (px < r_s && px > -r_s && py > r_c && py <= r)
            solutionSet = [solutionSet, sol{i}];
        end
    end
    
    % finally, compute the intersection with left line        
    if (m{i}(1,2) >= minX(i) && m{i}(1,2) <= maxX(i) && ...
            n{i}(1,2) >= minY(i) && n{i}(1,2) <= maxY(i))
        
        % transform the intersection from world frame to local frame
        p = [m{i}(1,2); n{i}(1,2)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
              
        if (px < 0 && px >= -r_s && py > 0 && py <= r_c)
            solutionSet = [solutionSet, p];
        end
    end
end
    
if isempty(solutionSet)
    distance(1) = 1;
else
    numSolutions = size(solutionSet, 2);
    distance(1)= sqrt(min(sum((solutionSet - repmat(x(1:2),1,numSolutions)).^2)));
end

%% --------------------compute back distance--------------------%%
solutionSet = [];

for i = 1:numLines
    if (m{i}(2,1) >= minX(i) && m{i}(2,1) <= maxX(i) && ...
            n{i}(2,1) >= minY(i) && n{i}(2,1) <= maxY(i))
        
        % transform the intersection from world frame to local frame
        p = [m{i}(2,1); n{i}(2,1)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
      
        % whether the intersection is in the zone of sensor?
        if (px < 0 && px >= -r_s && py < 0 && py >= -r_c)
            solutionSet = [solutionSet, p];
        end
    end
    
    if (sol{i}(1) >= minX(i) && sol{i}(1) <= maxX(i) && ...
            sol{i}(2) >= minY(i) && sol{i}(2) <= maxY(i))
        
        p_local = world2local(x, sol{i});
        px = p_local(1); py = p_local(2);
         
        if (px < r_s && px > -r_s && py < r_c && py >= -r)
            solutionSet = [solutionSet, sol{i}];
        end
    end
    
    if (m{i}(2,2) >= minX(i) && m{i}(2,2) <= maxX(i) && ...
            n{i}(2,2) >= minY(i) && n{i}(2,2) <= maxY(i))
        
        p = [m{i}(2,2); n{i}(2,2)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
        
        if (px > 0 && px <= r_s && py < 0 && py >= -r_c)
            solutionSet = [solutionSet, p];
        end
    end
end

if isempty(solutionSet)
    distance(4) = 0.5;
else
    numSolutions = size(solutionSet, 2);
    distance(4)= sqrt(min(sum((solutionSet - repmat(x(1:2),1,numSolutions)).^2)));
end

%% --------------------compute left distance--------------------%%
solutionSet = [];

for i = 1:numLines    
    if (m{i}(3,1) >= minX(i) && m{i}(3,1) <= maxX(i) && ...
            n{i}(3,1) >= minY(i) && n{i}(3,1) <= maxY(i))
        
        p = [m{i}(3,1); n{i}(3,1)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
               
        if (px < 0 && px >= -r_c && py > 0 && py <= r_s)
            solutionSet = [solutionSet, p];
        end
    end
    
    if (sol{i}(1) >= minX(i) && sol{i}(1) <= maxX(i) && ...
            sol{i}(2) >= minY(i) && sol{i}(2) <= maxY(i))
        
        p_local = world2local(x, sol{i});
        px = p_local(1); py = p_local(2);
         
        if (px < -r_c && px >= -r && py < r_s && py > -r_s)
            solutionSet = [solutionSet, sol{i}];
        end
    end
       
    if (m{i}(3,2) >= minX(i) && m{i}(3,2) <= maxX(i) && ...
            n{i}(3,2) >= minY(i) && n{i}(3,2) <= maxY(i))
        
        p = [m{i}(3,2); n{i}(3,2)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
        
        if (px < 0 && px >= -r_c && py < 0 && py >= r_s)
            solutionSet = [solutionSet, p];
        end
    end
end

if isempty(solutionSet)
    distance(2) = 0.5;
else
    numSolutions = size(solutionSet, 2);
    distance(2)= sqrt(min(sum((solutionSet - repmat(x(1:2),1,numSolutions)).^2)));
end

%% --------------------compute right distance--------------------%%
solutionSet = [];

for i = 1:numLines  
    if (m{i}(4,1) >= minX(i) && m{i}(4,1) <= maxX(i) && ...
            n{i}(4,1) >= minY(i) && n{i}(4,1) <= maxY(i))
        
        p = [m{i}(4,1); n{i}(4,1)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
          
        if (px > 0 && px <= r_c && py < 0 && py >= -r_s)
            solutionSet = [solutionSet, p];
        end
    end
    
    if (sol{i}(1) >= minX(i) && sol{i}(1) <= maxX(i) && ...
            sol{i}(2) >= minY(i) && sol{i}(2) <= maxY(i))
        
        p_local = world2local(x, sol{i});
        px = p_local(1); py = p_local(2);
         
        if (px <= r && px > r_c && py < r_s && py > -r_s)
            solutionSet = [solutionSet, sol{i}];
        end
    end
        
    if (m{i}(4,2) >= minX(i) && m{i}(4,2) <= maxX(i) && ...
            n{i}(4,2) >= minY(i) && n{i}(4,2) <= maxY(i))
        
        p = [m{i}(4,2); n{i}(4,2)];
        p_local = world2local(x, p);
        px = p_local(1); py = p_local(2);
        
        if (px > 0 && px <= r_c && py > 0 && py <= r_s)
            solutionSet = [solutionSet, p];
        end
    end
end

if isempty(solutionSet)
    distance(3) = 3;
else
    numSolutions = size(solutionSet, 2);
    distance(3)= sqrt(min(sum((solutionSet - repmat(x(1:2),1,numSolutions)).^2)));
end

end
