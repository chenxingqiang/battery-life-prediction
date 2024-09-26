function mdl = fit_no_temp(dc)
    % Fit a model without temperature features (e.g., intercept only)
    % Create a table with only the response variable
    T = table(dc);
    mdl = fitlm(T, 'dc ~ 1');
end
