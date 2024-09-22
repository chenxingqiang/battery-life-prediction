function visualize_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results)
    datasets = {'B0005', 'B0006', 'B0007', 'B0018'};
    
    for i = 1:length(datasets)
        figure('Name', sprintf('Results for Dataset %s', datasets{i}));
        
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
        plot_temperature_impact(temperature_analysis_results{i});
        title('Temperature Impact');
        
        % Plot 4: Capacity Prediction
        subplot(3, 2, 4);
        plot_capacity_prediction(capacity_prediction_results{i});
        title('Capacity Prediction');
        
        % Plot 5: SOH Prediction
        subplot(3, 2, 5);
        plot_soh_prediction(capacity_prediction_results{i});
        title('SOH Prediction');
        
        % Plot 6: Prediction PDF
        subplot(3, 2, 6);
        plot_prediction_pdf(capacity_prediction_results{i});
        title('Prediction Probability Density');
        
        sgtitle(sprintf('Analysis Results for Dataset %s', datasets{i}));
    end
end
