function prediction = predict_svr_sliding_window(capacity, health_factors)
    % 实现 SVR with sliding window
    window_size = 10;
    X = zeros(length(capacity) - window_size, window_size * size(health_factors, 2));
    y = zeros(length(capacity) - window_size, 1);
    
    for i = 1:length(capacity) - window_size
        X(i, :) = reshape(health_factors(i:i+window_size-1, :)', 1, []);
        y(i) = capacity(i + window_size);
    end
    
    mdl = fitrsvm(X, y, 'KernelFunction', 'rbf', 'Standardize', true);
    prediction = predict(mdl, X);
end