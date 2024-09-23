function avg_temp_change_rate = calculate_avg_temp_change_rate(time, temp)
    % Calculate the average temperature change rate
    dt = time(end) - time(1);
    if dt == 0
        avg_temp_change_rate = NaN;
    else
        avg_temp_change_rate = (temp(end) - temp(1)) / dt;
    end
end