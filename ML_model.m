% Machine learning Model

function [lb, ub, dim, fobj] = ML_model(F, X, y)
switch F
    case 'Linearmodel'  % Ridge Regression
        fobj = @(params) Linearmodel(params(1), X, y);
        lb = 0.001; ub = 10; dim = 1; 
        
    case 'Lassomodel'
        fobj = @(params) Lassomodel(params(1), X, y);
        lb = 0.001; ub = 10; dim = 1;
        
    case 'SVRmodel'
        fobj = @(params) SVRmodel(params(1), params(2), X, y);  % C, KernelScale
        lb = [0.1, 0.1]; ub = [100, 10]; dim = 2;
        
    case 'DTmodel'
        fobj = @(params) DTmodel(round(params(1)), round(params(2)), X, y); % MinLeafSize, MaxDepth
        lb = [1, 2]; ub = [50, 20]; dim = 2;
        
    case 'KNNmodel'
        fobj = @(params) KNNmodel(round(params(1)), X, y);  % NumNeighbors
        lb = 1; ub = 50; dim = 1;
        
    otherwise
        error('Invalid model name');
end
end


function mse = Linearmodel(alpha, X, y)
    % Train/Test Split
    num_samples = size(X, 1);
    idx = randperm(num_samples);
    train_idx = idx(1:round(0.8 * num_samples));
    test_idx = idx(round(0.8 * num_samples) + 1:end);
    
    X_train = X(train_idx, :);
    y_train = y(train_idx);
    X_test = X(test_idx, :);
    y_test = y(test_idx);
    
    % Train Ridge Regression
    B = ridge(y_train, X_train, alpha, 0);
    
    % Predict
    y_pred = [ones(size(X_test, 1), 1) X_test] * B;
    
    % Compute MSE
    mse = mean((y_test - y_pred).^2);
end


function mse = Lassomodel(alpha, X, y)
    % แบ่งข้อมูล Train/Test
    num_samples = size(X, 1);
    idx = randperm(num_samples);
    train_idx = idx(1:round(0.8 * num_samples));
    test_idx = idx(round(0.8 * num_samples) + 1:end);
    
    X_train = X(train_idx, :);
    y_train = y(train_idx);
    X_test = X(test_idx, :);
    y_test = y(test_idx);
    
    % Train Lasso Regression
    B = lasso(X_train, y_train, 'Lambda', alpha);
    
    % ทำนายค่า
    y_pred = [ones(size(X_test, 1), 1) X_test] * [mean(y_train); B];
    
    % คำนวณ MSE
    mse = mean((y_test - y_pred).^2);
end

function mse = SVRmodel(C, KernelScale, X, y)
    num_samples = size(X, 1);
    idx = randperm(num_samples);
    train_idx = idx(1:round(0.8 * num_samples));
    test_idx = idx(round(0.8 * num_samples) + 1:end);
    
    X_train = X(train_idx, :);
    y_train = y(train_idx);
    X_test = X(test_idx, :);
    y_test = y(test_idx);
    
    % Train SVR Model
    svr_model = fitrsvm(X_train, y_train, ...
        'KernelFunction', 'rbf', ...
        'BoxConstraint', C, ...
        'KernelScale', KernelScale);
    
    % Predict
    y_pred = predict(svr_model, X_test);
    
    % Compute MSE
    mse = mean((y_test - y_pred).^2);
end

function mse = DTmodel(MinLeafSize, MaxNumSplits, X, y)
    % แบ่งข้อมูล Train/Test
    num_samples = size(X, 1);
    idx = randperm(num_samples);
    train_idx = idx(1:round(0.8 * num_samples));
    test_idx = idx(round(0.8 * num_samples) + 1:end);
    
    X_train = X(train_idx, :);
    y_train = y(train_idx);
    X_test = X(test_idx, :);
    y_test = y(test_idx);
    
    % สร้าง Decision Tree Regressor
    tree_model = fitrtree(X_train, y_train, ...
                          'MinLeafSize', MinLeafSize, ...
                          'MaxNumSplits', MaxNumSplits); 
    
    % ทำนายค่า
    y_pred = predict(tree_model, X_test);
    
    % คำนวณ MSE
    mse = mean((y_test - y_pred).^2);
end

function mse = KNNmodel(NumNeighbors, X, y)
    num_samples = size(X, 1);
    idx = randperm(num_samples);
    train_idx = idx(1:round(0.8 * num_samples));
    test_idx = idx(round(0.8 * num_samples) + 1:end);
    
    X_train = X(train_idx, :);
    y_train = y(train_idx);
    X_test = X(test_idx, :);
    y_test = y(test_idx);
    
    % Train KNN-like Regression Model using Ensemble (Bagged Trees)
    knn_model = fitrensemble(X_train, y_train, ...
        'Method', 'Bag', ...         % ใช้ Bagging
        'NumLearningCycles', NumNeighbors, ... % ใช้ NumNeighbors กำหนดจำนวนต้นไม้
        'Learners', 'tree');         % ใช้ Decision Tree เป็นตัวเรียนรู้
    
    % Predict
    y_pred = predict(knn_model, X_test);
    
    % Compute MSE
    mse = mean((y_test - y_pred).^2);
end


