function plot_temperature_impact(temp_result)
    % Extract the LinearModel object
    mdl = temp_result.best_fit;
    
    % Get predictor and response variable names
    predictorNames = mdl.PredictorNames;
    responseName = mdl.ResponseName;
    
    % Access the variables used in the model
    X = mdl.Variables(:, predictorNames);
    y = mdl.Variables.(responseName);
    
    % Get the fitted values
    y_fitted = mdl.Fitted;
    
    % If there's only one predictor, proceed to plot
    if numel(predictorNames) == 1
        predictor = X.(predictorNames{1});
    
        % Convert tables to arrays if necessary
        predictor = table2array(predictor);
        y_array = table2array(y);
        y_fitted_array = table2array(y_fitted);
    
        % Plot the observed data
        plot(predictor, y_array, 'b.');
    
        hold on;
    
        % Plot the fitted values
        plot(predictor, y_fitted_array, 'r-');
    
        hold off;
    
        xlabel(predictorNames{1});
        ylabel(responseName);
        legend('Observed Data', 'Fitted Model');
        title(['Temperature Impact Model Fit - ', temp_result.best_model]);
    else
        % For multiple predictors, you can use plotAdjustedResponse
        for i = 1:numel(predictorNames)
            subplot(ceil(numel(predictorNames)/2), 2, i);
            plotAdjustedResponse(mdl, predictorNames{i});
            title(['Adjusted Response - ', predictorNames{i}]);
        end
    end
end