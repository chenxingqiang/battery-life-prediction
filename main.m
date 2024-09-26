function main()
    setup;

    try
        % 1. 数据预处理
        [data_B0005, data_B0006, data_B0007, data_B0018] = preprocess_data_v2();
    
        % 对每个数据集进行健康因子提取和绘图
        plot_health_factors(data_B0005.B0005.health_factors);
        plot_health_factors(data_B0006.B0006.health_factors);
        plot_health_factors(data_B0007.B0007.health_factors);
        plot_health_factors(data_B0018.B0018.health_factors);
    
        % 检查每个数据集的结构
        fprintf('Checking B0005 data structure:\n');
        check_data_structure(data_B0005);
        fprintf('\nChecking B0006 data structure:\n');
        check_data_structure(data_B0006);
        fprintf('\nChecking B0007 data structure:\n');
        check_data_structure(data_B0007);
        fprintf('\nChecking B0018 data structure:\n');
        check_data_structure(data_B0018);
    
    
        % 2. 容量再生现象影响分析
        [vmd_results, gs_results] = analyze_capacity_regeneration_v2(data_B0005.B0005, data_B0006.B0006, data_B0007.B0007, data_B0018.B0018);

        % 3. 温度影响分析
        temperature_analysis_results = analyze_temperature_impact_v2(data_B0005.B0005, data_B0006.B0006, data_B0007.B0007, data_B0018.B0018);

        % 4. 容量预测
        capacity_prediction_results = predict_capacity(data_B0005.B0005, data_B0006.B0006, data_B0007.B0007, data_B0018.B0018);

        % 5. 结果可视化
        visualize_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results);

        % 6. 保存结果
        save_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results);

    catch err
        fprintf('Error in main function: %s\n', err.message);
        fprintf('Stack trace:\n');
        disp(err.stack);
    end
end