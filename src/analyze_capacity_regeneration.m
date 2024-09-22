function [vmd_results, gs_results] = analyze_capacity_regeneration(data_B0005, data_B0006, data_B0007, data_B0018)
    % 对每个数据集进行分析
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    vmd_results = cell(1, length(datasets));
    gs_results = cell(1, length(datasets));
    
    for i = 1:length(datasets)
        % 1. 使用 VMD 进行容量分解
        [dc, imfs] = vmd(datasets{i}.capacity);
        
        % 2. 使用网格搜索优化 VMD 参数
        [alpha, k, tau] = grid_search_vmd(datasets{i}.capacity);
        
        % 3. 使用优化后的参数重新进行 VMD 分解
        [dc_opt, imfs_opt] = vmd(datasets{i}.capacity, 'Alpha', alpha, 'K', k, 'Tau', tau);
        
        % 4. 使用 LS 和 RVM 进行预测
        [ls_prediction, rvm_prediction] = predict_capacity(dc_opt, imfs_opt);
        
        % 5. 使用小波过滤算法过滤噪声
        [dc_filtered, imfs_filtered] = wavelet_filter(dc_opt, imfs_opt);
        
        % 6. 对容量再生现象进行相关度分析
        correlation_results = analyze_regeneration_correlation(imfs_filtered, datasets{i}.charge_intervals);
        
        % 保存结果
        vmd_results{i} = struct('dc', dc_opt, 'imfs', imfs_opt, 'dc_filtered', dc_filtered, 'imfs_filtered', imfs_filtered);
        gs_results{i} = struct('alpha', alpha, 'k', k, 'tau', tau);
    end
end
