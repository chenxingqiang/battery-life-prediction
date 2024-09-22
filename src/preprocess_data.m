function [data_B0005, data_B0006, data_B0007, data_B0018] = preprocess_data()
    % 下载数据
    datasets = {'B0005', 'B0006', 'B0007', 'B0018'};
    for i = 1:length(datasets)
        url = sprintf('https://ti.arc.nasa.gov/m/project/prognostics-repository/Battery_%s.mat', datasets{i});
        websave(sprintf('../data/%s.mat', datasets{i}), url);
    end
    
    % 加载数据
    data_B0005 = load('../data/B0005.mat');
    data_B0006 = load('../data/B0006.mat');
    data_B0007 = load('../data/B0007.mat');
    data_B0018 = load('../data/B0018.mat');
    
    % 数据补齐
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    for i = 1:length(datasets)
        datasets{i} = fill_missing_cycles(datasets{i});
    end
    
    % 数据平滑
    for i = 1:length(datasets)
        datasets{i} = smooth_data(datasets{i});
    end
    
    % 提取健康因子
    for i = 1:length(datasets)
        datasets{i} = extract_health_factors(datasets{i});
    end
    
    % 提取温度相关数据
    for i = 1:length(datasets)
        datasets{i} = extract_temperature_data(datasets{i});
    end
    
    % 将处理后的数据重新赋值
    [data_B0005, data_B0006, data_B0007, data_B0018] = datasets{:};
end
