function [data_B0005, data_B0006, data_B0007, data_B0018] = preprocess_data()
    % 加载数据
    data_B0005 = load('B0005.mat');
    data_B0006 = load('B0006.mat');
    data_B0007 = load('B0007.mat');
    data_B0018 = load('B0018.mat');
    
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    dataset_names = {'B0005', 'B0006', 'B0007', 'B0018'};
    
    for i = 1:length(datasets)
        disp(['Examining dataset: ' dataset_names{i}]);
        disp('Fields in the dataset:');
        disp(fieldnames(datasets{i}));
        
        % 检查深层结构
        main_field = dataset_names{i};
        if isfield(datasets{i}, main_field)
            disp(['Examining the content of ' main_field ':']);
            disp('Fields in the main structure:');
            disp(fieldnames(datasets{i}.(main_field)));
            
            if isfield(datasets{i}.(main_field), 'cycle')
                disp('The "cycle" field exists in the main structure. Examining its content:');
                disp(class(datasets{i}.(main_field).cycle));
                disp(['Size: ' num2str(size(datasets{i}.(main_field).cycle))]);
                if ~isempty(datasets{i}.(main_field).cycle)
                    disp('First element of cycle:');
                    disp(datasets{i}.(main_field).cycle(1));
                end
            else
                disp('The "cycle" field does not exist in the main structure.');
                disp('Available fields and their types:');
                fields = fieldnames(datasets{i}.(main_field));
                for j = 1:length(fields)
                    disp([fields{j} ': ' class(datasets{i}.(main_field).(fields{j}))]);
                end
            end
        end
        disp('-----------------------------------');
        
        % 更新数据集引用
        datasets{i} = datasets{i}.(main_field);
        
        % 检查数据结构
        if ~isfield(datasets{i}, 'cycle')
            warning('Dataset %d does not contain a "cycle" field. Skipping preprocessing.', i);
            continue;
        end
        
        % 数据补齐
        datasets{i} = fill_missing_cycles(datasets{i});
        
        % 数据平滑
        datasets{i} = smooth_data(datasets{i});
        
        % 提取健康因子
        datasets{i}.health_factors = extract_health_factors(datasets{i});
        
        % 提取温度相关数据
        datasets{i}.temp_features = extract_temperature_features(datasets{i});
    end
    
    % 将处理后的数据重新赋值
    [data_B0005, data_B0006, data_B0007, data_B0018] = datasets{:};
end