% Import data (in format .data) and divide it into 5 parts randomly

function [AllData data1 data2 data3 data4 data5] = DataProcessing(filename)
    RawData = importdata(filename);
    RawData = deblank(RawData);           % Removes trailing whitespace
    SplittedData = regexp(RawData, ',', 'split');
    
    m = size(SplittedData, 1);
    n = size(SplittedData{1}, 2);
    
    for i = 1:m
        AllData(i,:) = reshape(SplittedData{i}, 1, n);
    end
    
    % Label the desired results
    Y = AllData(:,n);
    MoveForward_id = strcmp(Y, 'Move-Forward');
    SlightRight_id = strcmp(Y, 'Slight-Right-Turn');
    SharpRight_id  = strcmp(Y, 'Sharp-Right-Turn');
    SlightLeft_id  = strcmp(Y, 'Slight-Left-Turn');
    Y(MoveForward_id) = {'0'};
    Y(SlightRight_id) = {'1'};
    Y(SharpRight_id)  = {'2'};
    Y(SlightLeft_id)  = {'3'};
    
    % Transform the data into a matrix
    data = AllData;
    data(:,n) = Y;
    data = str2double(data);
    
    % Randomly divide AllData into 5 parts
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