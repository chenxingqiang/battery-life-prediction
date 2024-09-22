function capacity_prediction_results = predict_capacity(data_B0005, data_B0006, data_B0007, data_B0018)
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    capacity_prediction_results = cell(1, length(datasets));
    
    for i = 1:length(datasets)
        % 提取容量和健康因子数据
        capacity = datasets{i}.capacity;
        health_factors = datasets{i}.health_factors;
        
        % 1. SVR with sliding window
        svr_prediction = predict_svr_sliding_window(capacity, health_factors);
        
        % 2. LSTM prediction
        lstm_prediction = predict_lstm(capacity, health_factors);
        
        % 3. Combine temperature and capacity regeneration effects
        combined_prediction = combine_effects(svr_prediction, lstm_prediction, datasets{i});
        
        % 4. Calculate SOH
        soh = calculate_soh(capacity);
        
        % 5. Generate probability density function
        pdf = generate_pdf(combined_prediction);
        
        % Save results
        capacity_prediction_results{i} = struct('svr_prediction', svr_prediction, ...
                                                'lstm_prediction', lstm_prediction, ...
                                                'combined_prediction', combined_prediction, ...
                                                'soh', soh, ...
                                                'pdf', pdf);
    end
end
