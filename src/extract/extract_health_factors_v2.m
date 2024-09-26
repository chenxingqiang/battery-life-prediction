function health_factors = extract_health_factors_v2(cycles)
num_cycles = length(cycles);
health_factors = struct('charge_time_to_4_2V', nan(1, num_cycles), ...
    'charge_time_to_current_drop', nan(1, num_cycles), ...
    'discharge_time_to_min_voltage', nan(1, num_cycles), ...
    'discharge_time_to_zero_current', nan(1, num_cycles));

valid_cycles = 0;
for i = 1:num_cycles

     if isfield(cycles(i), 'data') && isfield(cycles(i).data, 'Voltage_measured') && ...
           isfield(cycles(i).data, 'Current_measured') && isfield(cycles(i).data, 'Time') && ...
           length(cycles(i).data.Time) > 10  % 添加数据点数量检查

        if strcmp(cycles(i).type, 'charge')
            voltage_above_4_2 = find(cycles(i).data.Voltage_measured >= 4.2, 1);
            if ~isempty(voltage_above_4_2)
                health_factors.charge_time_to_4_2V(i) = cycles(i).data.Time(voltage_above_4_2);
            end

            % 修改电流下降的计算方法
            [~, max_current_idx] = max(cycles(i).data.Current_measured);
            current_drop = find(cycles(i).data.Current_measured(max_current_idx:end) < 0.1 * max(cycles(i).data.Current_measured), 1);
            if ~isempty(current_drop)
                health_factors.charge_time_to_current_drop(i) = cycles(i).data.Time(max_current_idx + current_drop - 1);
            end

            valid_cycles = valid_cycles + 1;

        elseif strcmp(cycles(i).type, 'discharge')
            [~, min_voltage_idx] = min(cycles(i).data.Voltage_measured);
            health_factors.discharge_time_to_min_voltage(i) = cycles(i).data.Time(min_voltage_idx);

            % 修改零电流的计算方法
            [min_current, min_current_idx] = min(abs(cycles(i).data.Current_measured));
            if min_current < 0.1  % 假设小于 0.1A 可以视为接近零
                health_factors.discharge_time_to_zero_current(i) = cycles(i).data.Time(min_current_idx);
            end

            valid_cycles = valid_cycles + 1;
        end
    end
end

fprintf('Successfully processed %d out of %d cycles\n', valid_cycles, num_cycles);
end