function plot_prediction_pdf(prediction_result)
    errors = prediction_result.y_test - prediction_result.y_pred;
    
    % Plot the probability density function of the prediction errors
    histogram(errors, 'Normalization', 'pdf');
    xlabel('Prediction Error');
    ylabel('Probability Density');
    title('Prediction Error PDF');
end