function [ensemble_prediction, prediction_uncertainty] = predict_capacity_ensemble(dc, imfs)
    num_samples = size(imfs, 1);
    horizon = round(0.2 * num_samples);  % Predict 20% of the data length
    
    % Prepare data for prediction
    X = (1:num_samples)';
    y = dc + sum(imfs, 2);
    
    % Split data into training and testing sets
    train_size = num_samples - horizon;
    X_train = X(1:train_size);
    y_train = y(1:train_size);
    X_test = X(train_size+1:end);
    
    % Initialize ensemble models
    num_models = 5;
    predictions = zeros(horizon, num_models);
    
    % Train and predict with multiple models
    models = {'linearregression', 'tree', 'svm', 'gaussian', 'ensemble'};
    for i = 1:num_models
        mdl = fitrgp(X_train, y_train, 'Basis', 'linear', 'FitMethod', 'exact', 'PredictMethod', 'exact');
        predictions(:, i) = predict(mdl, X_test);
    end
    
    % Calculate ensemble prediction and uncertainty
    ensemble_prediction = mean(predictions, 2);
    prediction_uncertainty = std(predictions, 0, 2);
end