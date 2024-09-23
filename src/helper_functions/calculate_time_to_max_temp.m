function time_to_max_temp = calculate_time_to_max_temp(time, temp)
    % Calculate the time to reach maximum temperature
    [~, idx_max_temp] = max(temp);
    time_to_max_temp = time(idx_max_temp) - time(1);
end