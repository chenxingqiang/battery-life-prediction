function mdl = fit_arrhenius_temp(temp_features, dc)
    % Fit an Arrhenius model using temperature features
    % Assuming temperature in Kelvin
    % Convert temperatures to Kelvin if necessary
    % temp_features_K = temp_features + 273.15; % Uncomment if temperatures are in Celsius

    % Take the inverse of temperature features
    temp_inverse = 1 ./ temp_features;

    % Transform the response variable
    dc_log = log(dc);

    % Ensure predictors and response have matching lengths
    if size(temp_inverse, 1) ~= length(dc_log)
        error('Predictor and response variables must have the same number of observations.');
    end

    mdl = fitlm(temp_inverse, dc_log);
end