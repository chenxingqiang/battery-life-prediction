function visualize_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results)
    datasets = {'B0005', 'B0006', 'B0007', 'B0018'};
    
    for i = 1:length(datasets)
        % Check if vmd_results is not empty and contains the necessary fields
        if ~isempty(vmd_results{i}) && isfield(vmd_results{i}, 'dc') && isfield(vmd_results{i}, 'imfs')
            figure('Name', sprintf('Results for Dataset %s', datasets{i}), 'Position', [100, 100, 1200, 800]);
            
            % Plot 1: VMD Decomposition
            subplot(3, 2, 1);
            plot_vmd_decomposition(vmd_results{i});
            title('VMD Decomposition');
            
            % Plot 2: Capacity Regeneration Correlation
            subplot(3, 2, 2);
            plot_regeneration_correlation(vmd_results{i});
            title('Capacity Regeneration Correlation');
            
            % Plot 3: Temperature Impact
            subplot(3, 2, 3);
            if ~isempty(temperature_analysis_results{i})
                plot_temperature_impact(temperature_analysis_results{i});
            else
                text(0.5, 0.5, 'No temperature analysis results', 'HorizontalAlignment', 'center');
                axis off;
            end
            title('Temperature Impact');

            % Plot 4: Capacity Prediction
            subplot(3, 2, 4);
            if ~isempty(capacity_prediction_results{i})
                if isfield(capacity_prediction_results{i}, 'y_test') && isfield(capacity_prediction_results{i}, 'y_pred')
                    plot_capacity_prediction(capacity_prediction_results{i});
                else
                    text(0.5, 0.5, 'No capacity prediction results', 'HorizontalAlignment', 'center');
                    axis off;
                end
            else
                text(0.5, 0.5, 'No capacity prediction results', 'HorizontalAlignment', 'center');
                axis off;
            end
            title('Capacity Prediction');
            
            % Plot 5: SOH Prediction
            subplot(3, 2, 5);
            if ~isempty(capacity_prediction_results{i})
                if isfield(capacity_prediction_results{i}, 'y_test') && isfield(capacity_prediction_results{i}, 'y_pred')
                    plot_soh_prediction(capacity_prediction_results{i});
                else
                    text(0.5, 0.5, 'No SOH prediction results', 'HorizontalAlignment', 'center');
                    axis off;
                end
            else
                text(0.5, 0.5, 'No SOH prediction results', 'HorizontalAlignment', 'center');
                axis off;
            end
            title('SOH Prediction');
            
            % Plot 6: Prediction PDF
            subplot(3, 2, 6);
            if ~isempty(capacity_prediction_results{i})
                if isfield(capacity_prediction_results{i}, 'y_test') && isfield(capacity_prediction_results{i}, 'y_pred')
                    plot_prediction_pdf(capacity_prediction_results{i});
                else
                    text(0.5, 0.5, 'No prediction PDF results', 'HorizontalAlignment', 'center');
                    axis off;
                end
            else
                text(0.5, 0.5, 'No prediction PDF results', 'HorizontalAlignment', 'center');
                axis off;
            end
            title('Prediction Probability Density');
            
            sgtitle(sprintf('Analysis Results for Dataset %s', datasets{i}));
        else
            warning('No valid results for dataset %s. Skipping visualization.', datasets{i});
        end
    end
end