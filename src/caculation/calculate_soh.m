function soh = calculate_soh(capacity)
    % 计算 State of Health (SOH)
    initial_capacity = capacity(1);
    soh = capacity / initial_capacity * 100;
end