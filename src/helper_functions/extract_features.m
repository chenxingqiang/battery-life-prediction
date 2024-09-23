function features = extract_features(data)
    % Initialize feature arrays
    num_cycles = length(data.cycle);
    features = [];

    for i = 1:num_cycles
        cycle_data = data.cycle(i).data;
        
        % Extract features for this cycle
        feature_vector = [];
        
        % Example features (you may need to adjust based on your data)
        
        % 1. Charge time
        if isfield(cycle_data, 'Time')
            charge_time = cycle_data.Time(end) - cycle_data.Time(1);
            feature_vector = [feature_vector, charge_time];
        else
            feature_vector = [feature_vector, NaN];
        end
        
        % 2. Max voltage
        if isfield(cycle_data, 'Voltage_measured')
            max_voltage = max(cycle_data.Voltage_measured);
            feature_vector = [feature_vector, max_voltage];
        else
            feature_vector = [feature_vector, NaN];
        end
        
        % 3. Min voltage
        if isfield(cycle_data, 'Voltage_measured')
            min_voltage = min(cycle_data.Voltage_measured);
            feature_vector = [feature_vector, min_voltage];
        else
            feature_vector = [feature_vector, NaN];
        end
        
        % 4. Average current
        if isfield(cycle_data, 'Current_measured')
            avg_current = mean(cycle_data.Current_measured);
            feature_vector = [feature_vector, avg_current];
        else
            feature_vector = [feature_vector, NaN];
        end
        
        % 5. Temperature features
        if isfield(cycle_data, 'Temperature_measured')
            avg_temp = mean(cycle_data.Temperature_measured);
            max_temp = max(cycle_data.Temperature_measured);
            min_temp = min(cycle_data.Temperature_measured);
            feature_vector = [feature_vector, avg_temp, max_temp, min_temp];
        else
            feature_vector = [feature_vector, NaN, NaN, NaN];
        end
        
        % 6. Other features (add as needed)
        % ...
        
        % Append the feature vector to the features matrix
        features = [features; feature_vector];
    end
    
    % Handle missing values (NaNs)
    % You can choose to remove cycles with NaNs or impute missing values
    % For example, remove rows with any NaNs:
    features = features(~any(isnan(features), 2), :);
end