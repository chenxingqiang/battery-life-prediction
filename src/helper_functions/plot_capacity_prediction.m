function plot_capacity_prediction(prediction_result)
    y_test = prediction_result.y_test;
    y_pred = prediction_result.y_pred;
    
    plot(y_test, 'b-', 'DisplayName', 'Actual Capacity');
    hold on;
    plot(y_pred, 'r--', 'DisplayName', 'Predicted Capacity');
    hold off;
    xlabel('Sample Index');
    ylabel('Capacity');
    legend('Location', 'Best');
    title('Capacity Prediction');
end