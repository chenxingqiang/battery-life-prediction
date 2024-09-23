function main()
    % 1. 数据预处理
    [data_B0005, data_B0006, data_B0007, data_B0018] = preprocess_data();

    % 2. 容量再生现象影响分析
    [vmd_results, gs_results] = analyze_capacity_regeneration(data_B0005, data_B0006, data_B0007, data_B0018);

    % 3. 温度影响分析
    temperature_analysis_results = analyze_temperature_impact(data_B0005, data_B0006, data_B0007, data_B0018);

    % 4. 容量预测
    capacity_prediction_results = predict_capacity(data_B0005, data_B0006, data_B0007, data_B0018);

    % 5. 结果可视化
    visualize_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results);

    % 6. 保存结果
    save_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results);
end