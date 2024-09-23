function save_results(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results)
    save('./results/battery_analysis_results.mat', 'vmd_results', 'gs_results', 'temperature_analysis_results', 'capacity_prediction_results');
    
    % 也可以考虑将结果导出为 CSV 或 Excel 文件,以便于进一步分析
    export_to_csv(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results);
end
