function temperature_analysis_results = analyze_temperature_impact(data_B0005, data_B0006, data_B0007, data_B0018)
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    temperature_analysis_results = cell(1, length(datasets));
    
    for i = 1:length(datasets)
        % 1. 提取直流信号 (使用 VMD 分解后的直流部分)
        [dc, ~] = vmd(datasets{i}.capacity);
        
        % 2. 提取温度数据
        temp_data = extract_temperature_data(datasets{i});
        
        % 3. 使用主成分分析 (PCA) 融合温度参数
        [temp_features, pca_coeff] = pca(temp_data);
        
        % 4. 设置对照组并进行拟合
        models = {
            @(x) fit_direct_temp(x, temp_features),
            @(x) fit_exponential_temp(x, temp_features),
            @(x) fit_arrhenius_temp(x, temp_features),
            @(x) fit_no_temp(x)
        };
        
        model_names = {'Direct', 'Exponential', 'Arrhenius', 'No Temperature'};
        fit_results = cell(1, length(models));
        
        for j = 1:length(models)
            fit_results{j} = models{j}(dc);
        end
        
        % 5. 评估模型性能并选择最佳模型
        [best_model, best_fit] = evaluate_models(fit_results, model_names);
        
        % 保存结果
        temperature_analysis_results{i} = struct('best_model', best_model, 'best_fit', best_fit, 'pca_coeff', pca_coeff);
    end
end
