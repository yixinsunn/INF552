% Load data and split it randomly for cross-validation

function [data_train label_train data_test label_test] = DataProcessing(RawData, K, CV_or_Not)
    m = size(RawData, 1);
    
    if CV_or_Not == false
        % Randomly divide RawData into 2 parts (70% : 30%)
        k = floor(m * 0.7);
        row_ind = randperm(m, k);
        data_train  = RawData(row_ind, 2:end)';
        label_train = RawData(row_ind, 1)' - 1;
        
        RawData(row_ind, :) = [];
        data_test  = RawData(:, 2:end)';
        label_test = RawData(:, 1)' - 1;
        
        % normalize all labels into [0, 1]
        label_train = mapminmax(label_train, 0, 1);
        label_test  = mapminmax(label_test, 0, 1);
        
        % only pick 'crime category', 'longitude', 'attitude', 'events' as
        % features
        data_train = data_train([4,6,7,8], :);
        data_test  = data_test([4,6,7,8], :);
        
        % normalize training data and test data
        num_DataTest = size(data_test, 2);
        min_mat = min(data_train, [], 2);
        max_mat = max(data_train, [], 2);
        
        data_train = mapminmax(data_train, 0, 1);
        data_test  = (data_test - repmat(min_mat, 1, num_DataTest)) ./ repmat((max_mat-min_mat), 1, num_DataTest);
        
%         % standardlize training data and test data
%         num_DataTrain = size(data_train, 2);
%         num_DataTest  = size(data_test, 2);
%         mean_mat = mean(data_train, 2);
%         std_mat  = std(data_train,0,2);
%         
%         data_train = (data_train - repmat(mean_mat, 1, num_DataTrain)) ./ repmat(std_mat, 1, num_DataTrain);
%         data_test  = (data_test  - repmat(mean_mat, 1, num_DataTest))  ./ repmat(std_mat, 1, num_DataTest);
    end
    
%     if CV_or_Not == true
%         % Randomly divide RawData into K parts for K-fold cross-validation
%         k = floor(m/K);
%         row_ind = randperm(m, k);
%         for i = 1:K
%             data_test{i}  = RawData(row_ind, 2:end);
%             label_test{i} = RawData(row_ind, 1);
%             
%             RawData(row_ind, :) = [];
%             data_test{i}  = RawData(:, 2:end);
%             label_test{i} = RawData(:, 1);
%     
%         row_ind = randperm(m-k, k);
%         data2 = RawData(row_ind, :);
%         RawData(row_ind, :) = [];
%     
%         row_ind = randperm(m-2*k, k);
%         data3 = RawData(row_ind, :);
%         RawData(row_ind, :) = [];
%     
%         row_ind = randperm(m-3*k, k);
%         data4 = RawData(row_ind, :);
%         RawData(row_ind, :) = [];   
%     
%         data5 = RawData;
end