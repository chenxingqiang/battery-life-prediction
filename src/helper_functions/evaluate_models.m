function [best_model, best_fit] = evaluate_models(fit_results, model_names)
    % Evaluate the models and select the best one based on adjusted R-squared
    num_models = length(fit_results);
    criteria = zeros(num_models, 1);

    for i = 1:num_models
        mdl = fit_results{i};
        criteria(i) = mdl.Rsquared.Adjusted; % Use adjusted R-squared
    end

    [~, best_idx] = max(criteria);
    best_model = model_names{best_idx};
    best_fit = fit_results{best_idx};

    disp(['Best model selected: ', best_model]);
end