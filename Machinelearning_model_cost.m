% Machine learning Model
function [lb,ub,dim,fobj] = ML_model(F)
switch F
    case 'Linearmodel'
        fobj = @Linearmodel;
        lb=0.001;
        ub=10;
        dim=1;
        
end        
end
function mse = Linearmodel(alpha, X, y)
    % แบ่งข้อมูล Train/Test
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
    
    % ทำนายค่า
    y_pred = [ones(size(X_test, 1), 1) X_test] * B;
    
    % คำนวณ MSE
    mse = mean((y_test - y_pred).^2);
end