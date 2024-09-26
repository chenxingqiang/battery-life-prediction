function [data_B0005, data_B0006, data_B0007, data_B0018] = preprocess_data_v2()
    % 加载数据
    data_B0005 = load('B0005.mat');
    data_B0006 = load('B0006.mat');
    data_B0007 = load('B0007.mat');
    data_B0018 = load('B0018.mat');
    datasets = {data_B0005, data_B0006, data_B0007, data_B0018};
    dataset_names = {'B0005', 'B0006', 'B0007', 'B0018'};

    for i = 1:length(datasets)
        % 数据补齐
        datasets{i}.(dataset_names{i}).cycle = fill_missing_cycles_v2(datasets{i}.(dataset_names{i}).cycle);
        
        % 数据平滑
        datasets{i}.(dataset_names{i}).cycle = smooth_data_v2(datasets{i}.(dataset_names{i}).cycle);
        
        % 提取健康因子
        datasets{i}.(dataset_names{i}).health_factors = extract_health_factors_v2(datasets{i}.(dataset_names{i}).cycle);
        
        % 提取温度相关数据
        datasets{i}.(dataset_names{i}).temp_features = extract_temperature_features_v2(datasets{i}.(dataset_names{i}).cycle);
    end
    
    % 将处理后的数据重新赋值
    [data_B0005, data_B0006, data_B0007, data_B0018] = datasets{:};
end

function cycles = fill_missing_cycles_v2(cycles)
    num_cycles = length(cycles);
    for i = 1:num_cycles
        if strcmp(cycles(i).type, 'charge')
            % 补充缺失的放电数据
            cycles(i).discharge = interpolate_missing_data_v2(cycles, i, 'discharge');
        elseif strcmp(cycles(i).type, 'discharge')
            % 补充缺失的充电数据
            cycles(i).charge = interpolate_missing_data_v2(cycles, i, 'charge');
        end
    end
    
    % 如果周期数少于170，添加新的周期
    while length(cycles) < 170
        new_cycle = interpolate_new_cycle_v2(cycles);
        cycles(end+1) = new_cycle;
    end
end


function interpolated_data = interpolate_missing_data_v2(cycles, cycle_index, mode)
    % 使用相邻周期的数据进行插值
    prev_index = max(1, cycle_index - 1);
    next_index = min(length(cycles), cycle_index + 1);
    
    if strcmp(cycles(prev_index).type, mode) && strcmp(cycles(next_index).type, mode)
        prev_data = cycles(prev_index).data;
        next_data = cycles(next_index).data;
        interpolated_data = struct();
        fields = fieldnames(prev_data);
        for j = 1:length(fields)
            if isnumeric(prev_data.(fields{j})) && isnumeric(next_data.(fields{j}))
                % 确保两个数组具有相同的大小
                min_length = min(length(prev_data.(fields{j})), length(next_data.(fields{j})));
                interpolated_data.(fields{j}) = (prev_data.(fields{j})(1:min_length) + next_data.(fields{j})(1:min_length)) / 2;
            else
                % 如果不是数值数据，只复制前一个周期的数据
                interpolated_data.(fields{j}) = prev_data.(fields{j});
            end
        end
    elseif strcmp(cycles(prev_index).type, mode)
        interpolated_data = cycles(prev_index).data;
    elseif strcmp(cycles(next_index).type, mode)
        interpolated_data = cycles(next_index).data;
    else
        % 如果无法插值，创建一个空的结构体
        interpolated_data = struct();
    end
end


function new_cycle = interpolate_new_cycle_v2(cycles)
    % 使用最后两个周期的数据插值创建新的周期
    last_cycle = cycles(end);
    second_last_cycle = cycles(end-1);
    
    new_cycle = struct();
    new_cycle.type = 'charge';
    new_cycle.ambient_temperature = (last_cycle.ambient_temperature + second_last_cycle.ambient_temperature) / 2;
    new_cycle.time = last_cycle.time;
    new_cycle.data = struct();
    fields = fieldnames(last_cycle.data);
    for j = 1:length(fields)
        new_cycle.data.(fields{j}) = (last_cycle.data.(fields{j}) + second_last_cycle.data.(fields{j})) / 2;
    end
end

function cycles = smooth_data_v2(cycles)
    for i = 1:length(cycles)
        if isfield(cycles(i).data, 'Voltage_measured')
            cycles(i).data.Voltage_measured = smoothdata(cycles(i).data.Voltage_measured, 'gaussian', 5);
        end
        if isfield(cycles(i).data, 'Current_measured')
            cycles(i).data.Current_measured = smoothdata(cycles(i).data.Current_measured, 'gaussian', 5);
        end
        if isfield(cycles(i).data, 'Temperature_measured')
            cycles(i).data.Temperature_measured = smoothdata(cycles(i).data.Temperature_measured, 'gaussian', 5);
        end
    end
end
