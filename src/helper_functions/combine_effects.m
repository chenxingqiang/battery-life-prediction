function combined_prediction = combine_effects(svr_prediction, lstm_prediction, dataset)
    % 结合温度和容量再生效应
    w1 = 0.5; w2 = 0.5; % 权重可以根据需要调整
    combined_prediction = w1 * svr_prediction + w2 * lstm_prediction;
    
    % 添加温度效应
    temp_effect = dataset.temperature_analysis.best_fit.model.Fitted;
    combined_prediction = combined_prediction + temp_effect;
    
    % 添加容量再生效应
    regen_effect = sum(dataset.capacity_regeneration.imfs_filtered, 2);
    combined_prediction = combined_prediction + regen_effect;
end
