function time = calculate_charge_time_to_voltage(cycle_data, target_voltage)
    voltage = cycle_data.Voltage_measured;
    time_vector = cycle_data.Time;
    [~, idx] = min(abs(voltage - target_voltage));
    time = time_vector(idx);
end