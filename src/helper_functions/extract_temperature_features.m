function temp_features = extract_temperature_features(data)
    % Extract temperature features from the data structure
    if ~isfield(data, 'cycle')
        warning('Data structure does not contain a "cycle" field. Unable to extract temperature features.');
        temp_features = [];
        return;
    end

    cycles = data.cycle;
    num_cycles = length(cycles);

    % Initialize feature arrays
    temp_features = struct();
    temp_features.time_to_max_temp_charge = zeros(num_cycles, 1);
    temp_features.time_to_max_temp_discharge = zeros(num_cycles, 1);
    temp_features.max_temp_charge = zeros(num_cycles, 1);
    temp_features.min_temp_charge = zeros(num_cycles, 1);
    temp_features.max_temp_discharge = zeros(num_cycles, 1);
    temp_features.min_temp_discharge = zeros(num_cycles, 1);
    temp_features.temp_range_charge = zeros(num_cycles, 1);
    temp_features.temp_range_discharge = zeros(num_cycles, 1);
    temp_features.avg_temp_change_rate_charge = zeros(num_cycles, 1);
    temp_features.avg_temp_change_rate_discharge = zeros(num_cycles, 1);

    for i = 1:num_cycles
        cycle_data = cycles(i).data;
        if strcmp(cycles(i).type, 'charge') && isfield(cycle_data, 'Temperature_measured')
            temp = cycle_data.Temperature_measured;
            time = cycle_data.Time;

            temp_features.time_to_max_temp_charge(i) = calculate_time_to_max_temp(time, temp);
            temp_features.max_temp_charge(i) = max(temp);
            temp_features.min_temp_charge(i) = min(temp);
            temp_features.temp_range_charge(i) = temp_features.max_temp_charge(i) - temp_features.min_temp_charge(i);
            temp_features.avg_temp_change_rate_charge(i) = calculate_avg_temp_change_rate(time, temp);
        elseif strcmp(cycles(i).type, 'discharge') && isfield(cycle_data, 'Temperature_measured')
            temp = cycle_data.Temperature_measured;
            time = cycle_data.Time;

            temp_features.time_to_max_temp_discharge(i) = calculate_time_to_max_temp(time, temp);
            temp_features.max_temp_discharge(i) = max(temp);
            temp_features.min_temp_discharge(i) = min(temp);
            temp_features.temp_range_discharge(i) = temp_features.max_temp_discharge(i) - temp_features.min_temp_discharge(i);
            temp_features.avg_temp_change_rate_discharge(i) = calculate_avg_temp_change_rate(time, temp);
        else
            % If Temperature_measured is not available, assign NaN
            temp_features.time_to_max_temp_charge(i) = NaN;
            temp_features.time_to_max_temp_discharge(i) = NaN;
            temp_features.max_temp_charge(i) = NaN;
            temp_features.min_temp_charge(i) = NaN;
            temp_features.max_temp_discharge(i) = NaN;
            temp_features.min_temp_discharge(i) = NaN;
            temp_features.temp_range_charge(i) = NaN;
            temp_features.temp_range_discharge(i) = NaN;
            temp_features.avg_temp_change_rate_charge(i) = NaN;
            temp_features.avg_temp_change_rate_discharge(i) = NaN;
        end
    end
end