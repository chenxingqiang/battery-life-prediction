function time = calculate_discharge_time_to_zero_current(cycle_data)
    current = cycle_data.Current_measured;
    time_vector = cycle_data.Time;
    [~, idx] = min(abs(current));
    time = time_vector(idx);
end