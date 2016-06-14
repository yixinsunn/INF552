% Obtain a training set and a test set with X and Y
% data1, data2, data3, data4 form the training set,
% while data5 is the test data.

function [trainingX trainingY testX testY] = TrainingTest(data1,data2,data3,data4,data5)
    training = [...
        data1;
        data2;
        data3;
        data4];
    
    trainingX = training(:, 1:end-1);
    trainingY = training(:,end);
    trainingX = trainingX';
    trainingY = trainingY';
    
    testX = data5(:, 1:end-1);
    testY = data5(:, end); 
    testX = testX';
    testY = testY';
    
    %% Normalize
    trainingY = mapminmax(trainingY, 0, 1);
    testY = mapminmax(testY, 0, 1);
    
end