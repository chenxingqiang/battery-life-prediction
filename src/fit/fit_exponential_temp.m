function mdl = fit_exponential_temp(temp_features, dc)
    % Check for non-positive dc values
    if any(dc <= 0)
        warning(['dc contains ', num2str(sum(dc <= 0)), ' non-positive values. Removing these observations.']);
        % Remove non-positive dc values and corresponding predictors
        positive_indices = dc > 0;
        dc = dc(positive_indices);
        temp_features = temp_features(positive_indices, :);
    end

    % Transform the response variable
    dc_exp = log(dc);

    % Ensure predictors and response have matching lengths
    if size(temp_features, 1) ~= length(dc_exp)
        error('Predictor and response variables must have the same number of observations.');
    end

    % Fit the linear model
    mdl = fitlm(temp_features, dc_exp);
end