% Import data (in format .data) and divide it into 5 parts randomly

function [rawData, data1, data2, data3, data4, data5] = split_data(filename)
    allData = importdata(filename);
    allData = deblank(allData);           % remove trailing whitespace
    splittedData = regexp(allData, ',', 'split');
    
    m = size(splittedData, 1);
    n = size(splittedData{1}, 2);
    
    for i = 1:m
        rawData(i,:) = reshape(splittedData{i}, 1, n);
    end
    
    % Label encoder
    y = rawData(:,n);
    moveForward_idx = strcmp(y, 'Move-Forward');
    slightRight_idx = strcmp(y, 'Slight-Right-Turn');
    sharpRight_idx  = strcmp(y, 'Sharp-Right-Turn');
    slightLeft_idx  = strcmp(y, 'Slight-Left-Turn');
    y(moveForward_idx) = {'0'};
    y(slightRight_idx) = {'1'};
    y(sharpRight_idx)  = {'2'};
    y(slightLeft_idx)  = {'3'};
    
    % Transform rawData into a matrix
    data = rawData;
    data(:,n) = y;
    data = str2double(data);
    
    % Randomly divide rawData into 5 parts
    k = floor(m/5);
    row_ind = randperm(m, k);
    data1 = data(row_ind, :);
    data(row_ind, :) = [];
    
    row_ind = randperm(m-k, k);
    data2 = data(row_ind, :);
    data(row_ind, :) = [];
    
    row_ind = randperm(m-2*k, k);
    data3 = data(row_ind, :);
    data(row_ind, :) = [];
    
    row_ind = randperm(m-3*k, k);
    data4 = data(row_ind, :);
    data(row_ind, :) = [];   
    
    data5 = data;
end