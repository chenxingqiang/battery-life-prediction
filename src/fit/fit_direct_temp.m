function mdl = fit_direct_temp(temp_features, dc)
    % Fit a linear model directly using temperature features
    % Ensure predictors and response have matching lengths
    if size(temp_features, 1) ~= length(dc)
        error('Predictor and response variables must have the same number of observations.');
    end
    mdl = fitlm(temp_features, dc);
end