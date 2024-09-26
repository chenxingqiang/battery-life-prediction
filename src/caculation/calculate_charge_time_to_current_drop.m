function time = calculate_charge_time_to_current_drop(cycle_data)
    current = cycle_data.Current_measured;
    time_vector = cycle_data.Time;
    [~, idx] = max(current);
    time = time_vector(idx);
end