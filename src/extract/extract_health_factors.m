function data = extract_health_factors(data)
    % 提取健康因子
    data.health_factors = struct();
    
    if ~isfield(data, 'cycle')
        warning('Data structure does not contain a "cycle" field. Unable to extract health factors.');
        return;
    end
    
    cycles = data.cycle;
    num_cycles = length(cycles);
    
    % 初始化健康因子数组
    data.health_factors.charge_time_to_4_2V = zeros(num_cycles, 1);
    data.health_factors.charge_time_to_current_drop = zeros(num_cycles, 1);
    data.health_factors.discharge_time_to_min_voltage = zeros(num_cycles, 1);
    data.health_factors.discharge_time_to_zero_current = zeros(num_cycles, 1);
    
    % 提取健康因子
    for i = 1:num_cycles
        cycle_data = cycles(i);
        if isfield(cycle_data, 'type') && isfield(cycle_data, 'data')
            if strcmp(cycle_data.type, 'charge')
                data.health_factors.charge_time_to_4_2V(i) = calculate_charge_time_to_voltage(cycle_data.data, 4.2);
                data.health_factors.charge_time_to_current_drop(i) = calculate_charge_time_to_current_drop(cycle_data.data);
            elseif strcmp(cycle_data.type, 'discharge')
                data.health_factors.discharge_time_to_min_voltage(i) = calculate_discharge_time_to_min_voltage(cycle_data.data);
                data.health_factors.discharge_time_to_zero_current(i) = calculate_discharge_time_to_zero_current(cycle_data.data);
            end
        else
            warning('Unexpected cycle data structure at cycle %d', i);
        end
    end
end
