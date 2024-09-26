function [predictions, feature_importance] = improved_soh_prediction(X, y)
    % Split data
    cv = cvpartition(size(X,1), 'HoldOut', 0.3);
    X_train = X(cv.training,:);
    y_train = y(cv.training);
    X_test = X(cv.test,:);
    y_test = y(cv.test);
    
    % Feature selection
    [idx, scores] = fscmrmr(X_train, y_train);
    numTopFeatures = 10;
    topFeatures = idx(1:numTopFeatures);
    
    % Train multiple models
    mdl_rf = TreeBagger(100, X_train(:,topFeatures), y_train, 'Method', 'regression');
    mdl_svm = fitrsvm(X_train(:,topFeatures), y_train, 'KernelFunction', 'rbf', 'Standardize', true);
    mdl_gbm = fitensemble(X_train(:,topFeatures), y_train, 'LSBoost', 100, 'Tree');
    
    % Make predictions
    pred_rf = predict(mdl_rf, X_test(:,topFeatures));
    pred_svm = predict(mdl_svm, X_test(:,topFeatures));
    pred_gbm = predict(mdl_gbm, X_test(:,topFeatures));
    
    % Ensemble predictions
    predictions = (pred_rf + pred_svm + pred_gbm) / 3;
    
    % Calculate feature importance (for Random Forest)
    feature_importance = mdl_rf.OOBPermutedPredictorDeltaError;
    
    % Evaluate
    mse = mean((predictions - y_test).^2);
    fprintf('Mean Squared Error: %.4f\n', mse);
    
    % Plot results
    figure;
    plot(y_test, 'b-', 'LineWidth', 2);
    hold on;
    plot(predictions, 'r--', 'LineWidth', 2);
    legend('Actual', 'Predicted');
    title('Improved SOH Prediction');
    xlabel('Sample');
    ylabel('SOH');
    
    % Plot feature importance
    figure;
    bar(feature_importance);
    title('Feature Importance');
    xlabel('Feature Index');
    ylabel('Importance Score');
end