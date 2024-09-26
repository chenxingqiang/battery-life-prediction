function capacity_prediction_results = predict_capacity(data_B0005, data_B0006, data_B0007, data_B0018)
    % Prepare datasets
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    capacity_prediction_results = cell(1, length(datasets));
    dataset_names = {'B0005', 'B0006', 'B0007', 'B0018'};
    
    for i = 1:length(datasets)
        data = datasets{i};
        
        % Extract features and capacity
        features = extract_features(data);
        capacity = extract_capacity(data);
        
        % **Ensure capacity and features have matching lengths**
        min_length = min(length(capacity), size(features, 1));
        capacity = capacity(1:min_length);
        features = features(1:min_length, :);
        
        % Recalculate number of samples
        num_samples = min_length;
        split_idx = round(0.8 * num_samples);
        
        % **Check for enough data**
        if split_idx < 1 || split_idx >= num_samples
            warning('Not enough data for training/testing for dataset %s. Skipping.', dataset_names{i});
            capacity_prediction_results{i} = [];
            continue;
        end
        
        % Split data into training and test sets
        X_train = features(1:split_idx, :);
        y_train = capacity(1:split_idx);
        X_test = features(split_idx+1:end, :);
        y_test = capacity(split_idx+1:end);
        
        % Check if there is enough data for training and testing
        if isempty(X_train) || isempty(X_test)
            warning('Not enough data for training/testing for dataset %s. Skipping.', dataset_names{i});
            capacity_prediction_results{i} = [];
            continue;
        end
        
        % Train the model (e.g., SVR)
        svr_model = fitrsvm(X_train, y_train);
        
        % Predict on the test set
        y_pred = predict(svr_model, X_test);
        
        % Save results
        capacity_prediction_results{i} = struct('model', svr_model, 'y_pred', y_pred, 'y_test', y_test);
    end
end