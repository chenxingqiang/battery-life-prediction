function export_to_csv(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results)
    datasets = {'B0005', 'B0006', 'B0007', 'B0018'};
    
    for i = 1:length(datasets)
        filename = ['results_', datasets{i}, '.csv'];
        fid = fopen(filename, 'w');
        
        % Write header
        fprintf(fid, 'Dataset,VMD_DC,VMD_IMF1,VMD_IMF2,VMD_IMF3,VMD_Alpha,VMD_K,VMD_Tau,Temp_Best_Model,Temp_RMSE,SVR_Prediction,LSTM_Prediction,Combined_Prediction,SOH\n');
        
        % Determine the number of data points
        num_data_points = length(vmd_results{i}.dc);
        
        % Handle IMFs (ensure there are at least 3 columns)
        num_imfs = size(vmd_results{i}.imfs, 2);
        imfs_padded = zeros(num_data_points, 3);
        imfs_padded(:, 1:min(num_imfs, 3)) = vmd_results{i}.imfs(:, 1:min(num_imfs, 3));
        
        % Get Grid Search parameters
        alpha = gs_results{i}.alpha;
        k = gs_results{i}.k;
        tau = gs_results{i}.tau;
        
        % Get Temperature Analysis results
        best_model = temperature_analysis_results{i}.best_model;
        best_fit = temperature_analysis_results{i}.best_fit;
        
        % Compute RMSE from the LinearModel
        residuals = best_fit.Residuals.Raw;
        rmse = sqrt(mean(residuals.^2));
        
        % Initialize prediction results
        y_pred = NaN(num_data_points, 1);
        lstm_pred = NaN(num_data_points, 1);
        combined_pred = NaN(num_data_points, 1);
        soh = NaN(num_data_points, 1);
        
        % Check if capacity_prediction_results{i} is available and contains data
        if i <= length(capacity_prediction_results) && ~isempty(capacity_prediction_results{i}) && isstruct(capacity_prediction_results{i})
            % Access capacity_prediction_results for the current dataset
            y_pred_full = capacity_prediction_results{i}.y_pred;
            y_test_full = capacity_prediction_results{i}.y_test;
            
            % Ensure the lengths match num_data_points
            min_length = min(num_data_points, length(y_pred_full));
            y_pred(1:min_length) = y_pred_full(1:min_length);
            y_test = y_test_full(1:min_length);
            
            % Handle LSTM and combined predictions if they exist
            if isfield(capacity_prediction_results{i}, 'lstm_prediction')
                lstm_pred_full = capacity_prediction_results{i}.lstm_prediction;
                lstm_pred(1:min_length) = lstm_pred_full(1:min_length);
            end
            if isfield(capacity_prediction_results{i}, 'combined_prediction')
                combined_pred_full = capacity_prediction_results{i}.combined_prediction;
                combined_pred(1:min_length) = combined_pred_full(1:min_length);
            end
            
            % Compute SOH
            initial_capacity = y_test(1);
            soh(1:min_length) = (y_test / initial_capacity) * 100;
        end
        
        % Write data to CSV
        for j = 1:num_data_points
            fprintf(fid, '%s,', datasets{i});
            fprintf(fid, '%.4f,', vmd_results{i}.dc(j));
            fprintf(fid, '%.4f,%.4f,%.4f,', imfs_padded(j, 1), imfs_padded(j, 2), imfs_padded(j, 3));
            fprintf(fid, '%.4f,%.0f,%.2f,', alpha, k, tau);
            fprintf(fid, '%s,%.4f,', best_model, rmse);
            fprintf(fid, '%.4f,%.4f,%.4f,%.4f\n', y_pred(j), lstm_pred(j), combined_pred(j), soh(j));
        end
        
        fclose(fid);
    end
end