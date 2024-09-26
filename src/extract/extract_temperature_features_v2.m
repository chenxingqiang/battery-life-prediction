function temp_features = extract_temperature_features_v2(cycles)
    num_cycles = length(cycles);
    temp_features = struct('charge_time_to_max_temp', zeros(1, num_cycles), ...
                           'discharge_time_to_max_temp', zeros(1, num_cycles), ...
                           'charge_max_temp', zeros(1, num_cycles), ...
                           'discharge_max_temp', zeros(1, num_cycles), ...
                           'charge_temp_diff', zeros(1, num_cycles), ...
                           'discharge_temp_diff', zeros(1, num_cycles), ...
                           'charge_avg_temp_rate', zeros(1, num_cycles), ...
                           'discharge_avg_temp_rate', zeros(1, num_cycles));
    
    for i = 1:num_cycles
        if strcmp(cycles(i).type, 'charge')
            charge_data = cycles(i).data;
            [max_temp, max_temp_idx] = max(charge_data.Temperature_measured);
            temp_features.charge_time_to_max_temp(i) = charge_data.Time(max_temp_idx);
            temp_features.charge_max_temp(i) = max_temp;
            temp_features.charge_temp_diff(i) = max_temp - charge_data.Temperature_measured(1);
            temp_features.charge_avg_temp_rate(i) = mean(diff(charge_data.Temperature_measured) ./ diff(charge_data.Time));
        elseif strcmp(cycles(i).type, 'discharge')
            discharge_data = cycles(i).data;
            [max_temp, max_temp_idx] = max(discharge_data.Temperature_measured);
            temp_features.discharge_time_to_max_temp(i) = discharge_data.Time(max_temp_idx);
            temp_features.discharge_max_temp(i) = max_temp;
            temp_features.discharge_temp_diff(i) = max_temp - discharge_data.Temperature_measured(1);
            temp_features.discharge_avg_temp_rate(i) = mean(diff(discharge_data.Temperature_measured) ./ diff(discharge_data.Time));
        end
    end
end