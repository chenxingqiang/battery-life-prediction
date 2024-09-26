function [vmd_results, gs_results] = analyze_capacity_regeneration_v2(data_B0005, data_B0006, data_B0007, data_B0018)
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    dataset_names = {'B0005', 'B0006', 'B0007', 'B0018'};
    vmd_results = cell(1, length(datasets));
    gs_results = cell(1, length(datasets));
    
    for i = 1:length(datasets)
        disp(['Analyzing dataset: ', dataset_names{i}]);
        capacity = extract_capacity_v2(datasets{i});
        
        if isempty(capacity)
            warning('Unable to extract capacity data for dataset %d', i);
            vmd_results{i} = struct('dc', [], 'imfs', []);
            gs_results{i} = struct('alpha', [], 'k', [], 'tau', []);
            continue;
        end
        
        % Perform VMD decomposition with automatic parameter selection
        try
            [dc, imfs, alpha, k, tau] = auto_vmd(capacity);
            disp(['VMD decomposition successful. Number of IMFs: ', num2str(size(imfs, 2))]);
        catch e
            warning('VMD decomposition failed for dataset %d: %s', i, e.message);
            vmd_results{i} = struct('dc', [], 'imfs', []);
            gs_results{i} = struct('alpha', [], 'k', [], 'tau', []);
            continue;
        end
        
        % Make predictions using ensemble methods
        [ensemble_prediction, prediction_uncertainty] = predict_capacity_ensemble(dc, imfs);
        disp(['Prediction completed. Ensemble prediction length: ', num2str(length(ensemble_prediction))]);
        
        % Adaptive noise filtering
        [dc_filtered, imfs_filtered] = adaptive_filter(dc, imfs);
        disp(['Adaptive filtering completed. Filtered IMFs shape: ', num2str(size(imfs_filtered))]);
        
        % Calculate capacity regeneration data
        regeneration_data = calculate_capacity_regeneration_v2(capacity);
        disp(['Calculated capacity regeneration data. Length: ', num2str(length(regeneration_data))]);
        
        % Perform advanced correlation analysis of capacity regeneration
        charge_intervals = extract_charge_intervals_v2(datasets{i});
        disp(['Extracted charge intervals. Length: ', num2str(length(charge_intervals))]);
        
        if ~isempty(charge_intervals)
            correlation_results = analyze_regeneration_correlation_v2(imfs_filtered, regeneration_data, charge_intervals);
            disp(['Advanced correlation analysis completed. Number of correlation results: ', num2str(length(correlation_results))]);
        else
            warning('Unable to extract charge intervals for dataset %d', i);
            correlation_results = [];
        end
        
        % Save results
        vmd_results{i} = struct('dc', dc, 'imfs', imfs, 'dc_filtered', dc_filtered, 'imfs_filtered', imfs_filtered, ...
                                'ensemble_prediction', ensemble_prediction, 'prediction_uncertainty', prediction_uncertainty, ...
                                'regeneration_data', regeneration_data, ...
                                'correlation_results', correlation_results);
        gs_results{i} = struct('alpha', alpha, 'k', k, 'tau', tau);
        
        disp(['Analysis completed for dataset: ', dataset_names{i}]);
        disp('-----------------------------------');
    end
end

function regeneration_data = calculate_capacity_regeneration_v2(capacity)
    capacity_diff = diff(capacity);
    regeneration_data = [0; capacity_diff];
    regeneration_data(regeneration_data < 0) = 0;
    
    % Normalize regeneration data
    regeneration_data = regeneration_data / max(regeneration_data);
    
    % Apply moving average smoothing
    window_size = 5;
    regeneration_data = movmean(regeneration_data, window_size);
end