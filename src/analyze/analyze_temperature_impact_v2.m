function temperature_analysis_results = analyze_temperature_impact_v2(data_B0005, data_B0006, data_B0007, data_B0018)
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    dataset_names = {'B0005', 'B0006', 'B0007', 'B0018'};
    temperature_analysis_results = cell(1, length(datasets));

    for i = 1:length(datasets)
        disp(['Analyzing temperature impact for dataset: ', dataset_names{i}]);
        
        % 1. Extract capacity data
        capacity = extract_capacity_v2(datasets{i});

        if isempty(capacity)
            warning('Unable to extract capacity data for dataset %d', i);
            continue;
        end

        % 2. Extract DC signal (using VMD)
        [dc, ~] = vmd(capacity, 'Alpha', 2000, 'Tau', 0, 'K', 3, 'DC', 1, 'InitMethod', 'rand', 'TolA', 1e-7);
        dc = dc(:);

        % 3. Extract temperature features
        temp_features = extract_temperature_features_v2(datasets{i});

        if isempty(temp_features)
            warning('Unable to extract temperature features for dataset %d', i);
            continue;
        end

        % Preprocess data
        [dc, temp_features] = preprocess_temp_data(dc, temp_features);

        % 4. Perform PCA on temperature features
        [temp_features_pca, explained] = perform_pca(temp_features);

        % 5. Fit temperature models
        models = {
            @(x) fit_direct_temp(temp_features_pca, x),
            @(x) fit_exponential_temp(temp_features_pca, x),
            @(x) fit_arrhenius_temp(temp_features_pca, x),
            @(x) fit_no_temp(x)
        };
        model_names = {'Direct', 'Exponential', 'Arrhenius', 'No Temperature'};
        fit_results = cell(1, length(models));

        for j = 1:length(models)
            fit_results{j} = models{j}(dc);
        end

        % 6. Evaluate models and select the best one
        [best_model, best_fit] = evaluate_models(fit_results, model_names);

        % Save results
        temperature_analysis_results{i} = struct('best_model', best_model, 'best_fit', best_fit, 'pca_coeff', temp_features_pca, 'explained_variance', explained);
        
        disp(['Best model selected: ', best_model]);
        disp('-----------------------------------');
    end
end

function [dc, temp_features] = preprocess_temp_data(dc, temp_features)
    % Handle missing or infinite values
    valid_indices = ~any(isnan(temp_features), 2) & ~any(isinf(temp_features), 2) & ~isnan(dc) & ~isinf(dc) & (dc > 0);
    temp_features = temp_features(valid_indices, :);
    dc = dc(valid_indices);

    % Remove zero variance columns
    zero_variance_columns = var(temp_features) == 0;
    temp_features(:, zero_variance_columns) = [];

    % Standardize temp_features
    temp_features = zscore(temp_features);
end

function [temp_features_pca, explained] = perform_pca(temp_features)
    [~, temp_features_pca, ~, ~, explained] = pca(temp_features);
    
    % Keep only principal components that explain 95% of the variance
    variance_threshold = 95;
    cumulative_explained = cumsum(explained);
    num_components = find(cumulative_explained >= variance_threshold, 1);
    
    if isempty(num_components)
        warning('No components explaining 95%% variance found. Using all components.');
        num_components = size(temp_features_pca, 2);
    end
    
    temp_features_pca = temp_features_pca(:, 1:num_components);
end