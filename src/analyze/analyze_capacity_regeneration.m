function [vmd_results, gs_results] = analyze_capacity_regeneration(data_B0005, data_B0006, data_B0007, data_B0018)
    % Analyze each dataset
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    dataset_names = {'B0005', 'B0006', 'B0007', 'B0018'};
    vmd_results = cell(1, length(datasets));
    gs_results = cell(1, length(datasets));
    
    for i = 1:length(datasets)
        disp(['Analyzing dataset: ', dataset_names{i}]);
        % Extract capacity data
        capacity = extract_capacity(datasets{i});
        
        if isempty(capacity)
            warning('Unable to extract capacity data for dataset %d', i);
            vmd_results{i} = struct('dc', [], 'imfs', []);
            gs_results{i} = struct('alpha', [], 'k', [], 'tau', []);
            continue;
        end
        
        % 1. Perform VMD decomposition on capacity
        try
            [dc, imfs] = vmd(capacity);
            disp(['Initial VMD decomposition successful. Number of IMFs: ', num2str(size(imfs, 2))]);
        catch e
            warning('Initial VMD decomposition failed for dataset %d: %s', i, e.message);
            vmd_results{i} = struct('dc', [], 'imfs', []);
            gs_results{i} = struct('alpha', [], 'k', [], 'tau', []);
            continue;
        end
        
        % 2. Optimize VMD parameters using grid search
        [alpha, k, tau] = grid_search_vmd(capacity);
        disp(['Grid search completed. Optimal parameters - alpha: ', num2str(alpha), ', k: ', num2str(k), ', tau: ', num2str(tau)]);
        
        % 3. Perform VMD decomposition with optimized parameters
        try
            [dc_opt, imfs_opt] = vmd(capacity, 'NumIMF', k);
            disp(['Optimized VMD decomposition successful. Number of IMFs: ', num2str(size(imfs_opt, 2))]);
        catch e
            warning('Optimized VMD decomposition failed for dataset %d: %s', i, e.message);
            dc_opt = dc;
            imfs_opt = imfs;
        end
        
        % 4. Make predictions using LS and SVR
        [ls_prediction, svr_prediction] = predict_capacity_single(dc_opt, imfs_opt);
        disp(['Prediction completed. LS prediction length: ', num2str(length(ls_prediction)), ', SVR prediction length: ', num2str(length(svr_prediction))]);
        
        % 5. Filter noise using wavelet filtering
        [dc_filtered, imfs_filtered] = wavelet_filter(dc_opt, imfs_opt);
        disp(['Wavelet filtering completed. Filtered IMFs shape: ', num2str(size(imfs_filtered))]);
        
        % **New Step: Calculate capacity regeneration data**
        % 6. Calculate capacity regeneration data
        regeneration_data = calculate_capacity_regeneration(capacity);
        disp(['Calculated capacity regeneration data. Length: ', num2str(length(regeneration_data))]);
        
        % 7. Perform correlation analysis of capacity regeneration
        charge_intervals = extract_charge_intervals(datasets{i});
        disp(['Extracted charge intervals. Length: ', num2str(length(charge_intervals))]);
        
        if ~isempty(charge_intervals)
            correlation_results = analyze_regeneration_correlation(imfs_filtered, regeneration_data);
            disp(['Correlation analysis completed. Number of correlation results: ', num2str(length(correlation_results))]);
        else
            warning('Unable to extract charge intervals for dataset %d', i);
            correlation_results = [];
        end
        
        % Save results, including regeneration_data
        vmd_results{i} = struct('dc', dc_opt, 'imfs', imfs_opt, 'dc_filtered', dc_filtered, 'imfs_filtered', imfs_filtered, ...
                                'ls_prediction', ls_prediction, 'svr_prediction', svr_prediction, ...
                                'regeneration_data', regeneration_data, ...
                                'correlation_results', correlation_results);
        gs_results{i} = struct('alpha', alpha, 'k', k, 'tau', tau);
        
        disp(['Analysis completed for dataset: ', dataset_names{i}]);
        disp('-----------------------------------');
    end
end


% Add the subfunction below the main function
function regeneration_data = calculate_capacity_regeneration(capacity)
    % Calculate the capacity difference between successive cycles
    capacity_diff = diff(capacity);
    % Identify capacity regeneration events (positive differences)
    regeneration_data = [0; capacity_diff]; % Prepend zero to align lengths
    % Replace negative differences with zero (no regeneration)
    regeneration_data(regeneration_data < 0) = 0;
end