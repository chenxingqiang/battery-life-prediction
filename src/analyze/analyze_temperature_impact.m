function temperature_analysis_results = analyze_temperature_impact(data_B0005, data_B0006, data_B0007, data_B0018)
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    temperature_analysis_results = cell(1, length(datasets));

    for i = 1:length(datasets)
        % 1. Extract capacity data
        capacity = extract_capacity(datasets{i});

        if isempty(capacity)
            warning('Unable to extract capacity data for dataset %d', i);
            continue;
        end

        % 2. Extract DC signal (from VMD decomposition)
        [dc, ~] = vmd(capacity);

        % Ensure dc is a column vector
        dc = dc(:);

        % Check for NaNs, Infs, and complex values in dc
        if any(isnan(dc))
            error('Response variable dc contains NaN values.');
        end

        if any(isinf(dc))
            error('Response variable dc contains Inf values.');
        end

        if ~isreal(dc)
            warning('dc contains complex values. Taking the real part.');
            dc = real(dc);
        end

        % Ensure dc is numeric and a vector
        if ~isnumeric(dc) || ~isvector(dc)
            error('Response variable dc must be a numeric vector.');
        end

        % 3. Extract temperature features
        temp_features = extract_temperature_features(datasets{i});

        if isempty(temp_features)
            warning('Unable to extract temperature features for dataset %d', i);
            continue;
        end

        % Convert temp_features struct to numeric matrix
        fields = fieldnames(temp_features);
        numFields = length(fields);
        numSamples = length(temp_features.(fields{1}));
        temp_features_matrix = zeros(numSamples, numFields);

        for idxField = 1:numFields
            fieldData = temp_features.(fields{idxField});
            if isnumeric(fieldData)
                temp_features_matrix(:, idxField) = fieldData;
            else
                error('Field %s is not numeric.', fields{idxField});
            end
        end

        temp_features = temp_features_matrix;

        % Ensure temp_features and dc have matching lengths
        min_length = min(length(dc), size(temp_features, 1));
        dc = dc(1:min_length);
        temp_features = temp_features(1:min_length, :);

        % Display sizes and classes for debugging
        disp(['After trimming: Size of dc: ', mat2str(size(dc))]);
        disp(['After trimming: Size of temp_features: ', mat2str(size(temp_features))]);
        disp(['Class of temp_features: ', class(temp_features)]);
        disp(['Class of dc: ', class(dc)]);

        % Handle missing or infinite values
        valid_indices = ~any(isnan(temp_features), 2) & ~isnan(dc);

        % Ensure valid_indices is logical
        valid_indices = logical(valid_indices);

        % Display size of valid_indices
        disp(['Size of valid_indices: ', mat2str(size(valid_indices))]);
        disp(['Class of valid_indices: ', class(valid_indices)]);

        % Apply valid_indices to filter data
        temp_features = temp_features(valid_indices, :);
        dc = dc(valid_indices);      

        % Check for empty arrays
        if isempty(dc) || isempty(temp_features)
            warning('No valid data after removing NaN or infinite values.');
            continue; % Skip to the next dataset
        end

        % Identify and remove zero variance columns
        zero_variance_columns = var(temp_features) == 0;
        if any(zero_variance_columns)
            warning(['Removed ', num2str(sum(zero_variance_columns)), ' columns with zero variance from temp_features.']);
            temp_features(:, zero_variance_columns) = [];
        end

        % Standardize temp_features
        [temp_features, mu, sigma] = zscore(temp_features);

        % Check for NaNs after standardization
        if any(isnan(temp_features), 'all')
            error('NaN values detected in temp_features after standardization.');
        end

        % 4. Perform PCA on temperature features
        [~, temp_features_pca, ~, ~, explained] = pca(temp_features);

         % Remove non-positive dc values and corresponding predictors
positive_indices = dc > 0;
dc = dc(positive_indices);
temp_features_pca = temp_features_pca(positive_indices, :);

% Calculate the percentage of non-positive dc values
num_non_positive = sum(dc <= 0);
total_observations = length(dc);
percentage = (num_non_positive / total_observations) * 100;
disp(['Non-positive dc values constitute ', num2str(percentage), '% of the data.']);

        % Keep only principal components that explain 95% of the variance
        variance_threshold = 95; % Adjust this threshold as needed
        cumulative_explained = cumsum(explained);
        num_components = find(cumulative_explained >= variance_threshold, 1);

        % If no components explain 95%, try lower thresholds or use all components
        if isempty(num_components)
            warning('No components explaining 95%% variance found. Using all components.');
            num_components = size(temp_features_pca, 2); % Use all components
        end

        % Keep only relevant principal components
        temp_features_pca = temp_features_pca(:, 1:num_components);

        % Ensure the number of rows (observations) in temp_features_pca and dc match
        disp(['Size of temp_features_pca: ', mat2str(size(temp_features_pca))]);
        disp(['Length of dc: ', num2str(length(dc))]);

        if size(temp_features_pca, 1) ~= length(dc)
            error('After PCA, temp_features_pca and dc have different numbers of observations.');
        end

        % Check for NaNs, Infs, and complex values in temp_features_pca
        if any(isnan(temp_features_pca), 'all') || any(isinf(temp_features_pca), 'all')
            error('temp_features_pca contains NaN or Inf values.');
        end

        if ~isreal(temp_features_pca)
            error('temp_features_pca contains complex values.');
        end

        % 5. Set up models and fit
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
        temperature_analysis_results{i} = struct('best_model', best_model, 'best_fit', best_fit, 'pca_coeff', temp_features_pca);
    end
end