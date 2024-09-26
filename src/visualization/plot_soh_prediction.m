function plot_soh_prediction(prediction_result)
    % Extract actual and predicted capacities
    y_test = prediction_result.y_test;
    y_pred = prediction_result.y_pred;
    
    % Calculate SOH as a percentage of the initial capacity
    initial_capacity = y_test(1); % Assuming the first capacity is the nominal capacity
    soh_actual = (y_test / initial_capacity) * 100;
    soh_predicted = (y_pred / initial_capacity) * 100;
    
    % Plot the actual and predicted SOH
    plot(soh_actual, 'b-', 'DisplayName', 'Actual SOH');
    hold on;
    plot(soh_predicted, 'r--', 'DisplayName', 'Predicted SOH');
    hold off;
    xlabel('Sample Index');
    ylabel('State of Health (%)');
    legend('Location', 'Best');
    title('SOH Prediction');
end