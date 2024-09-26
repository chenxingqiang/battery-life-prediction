function plot_health_factors(health_factors)
    figure;
    cycle_numbers = 1:length(health_factors.charge_time_to_4_2V);
    
    subplot(2,2,1);
    plot(cycle_numbers, health_factors.charge_time_to_4_2V, '.-');
    title('Charge Time to 4.2V');
    xlabel('Cycle Number'); ylabel('Time (s)');

    subplot(2,2,2);
    plot(cycle_numbers, health_factors.charge_time_to_current_drop, '.-');
    title('Charge Time to Current Drop');
    xlabel('Cycle Number'); ylabel('Time (s)');

    subplot(2,2,3);
    plot(cycle_numbers, health_factors.discharge_time_to_min_voltage, '.-');
    title('Discharge Time to Min Voltage');
    xlabel('Cycle Number'); ylabel('Time (s)');

    subplot(2,2,4);
    plot(cycle_numbers, health_factors.discharge_time_to_zero_current, '.-');
    title('Discharge Time to Zero Current');
    xlabel('Cycle Number'); ylabel('Time (s)');

    sgtitle('Health Factors vs Cycle Number');
end