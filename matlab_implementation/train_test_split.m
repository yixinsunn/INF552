function [X_train, y_train, X_test, y_test] = train_test_split(data1,data2,data3,data4,data5)
% Obtain a training set and a test set
% data1, data2, data3, data4 form the training set,
% while data5 is the test data.
    train = [...
        data1;
        data2;
        data3;
        data4];
    
    X_train = train(:, 1:end-1); X_train = X_train';
    y_train = train(:,end); y_train = y_train';
    
    X_test = data5(:, 1:end-1); X_test = X_test';
    y_test = data5(:, end); y_test = y_test';
    
    %% Normalize
    y_train = mapminmax(y_train, 0, 1);
    y_test = mapminmax(y_test, 0, 1);

end