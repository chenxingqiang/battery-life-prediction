function time = calculate_discharge_time_to_min_voltage(cycle_data)
    voltage = cycle_data.Voltage_measured;
    time_vector = cycle_data.Time;
    [~, idx] = min(voltage);
    time = time_vector(idx);
end