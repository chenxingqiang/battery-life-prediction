function [ls_prediction, svr_prediction] = predict_capacity_single(dc, imfs)
    % 使用前 70% 数据作为训练集,后 30% 作为测试集
    n = length(dc);
    train_size = round(0.7 * n);
    
    X = [dc, imfs];
    y = cumsum(dc); % 假设我们预测的是累积容量
    
    X_train = X(1:train_size, :);
    y_train = y(1:train_size);
    X_test = X(train_size+1:end, :);
    
    % LS 预测
    ls_model = fitlm(X_train, y_train);
    ls_prediction = predict(ls_model, X_test);
    
    % SVR 预测
    svr_model = fitrsvm(X_train, y_train, 'KernelFunction', 'rbf', 'Standardize', true);
    svr_prediction = predict(svr_model, X_test);
end