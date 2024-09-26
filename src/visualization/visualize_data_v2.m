function visualize_data_v2(data)
    % 1. 原始数据与平滑后数据的对比图
    figure;
    subplot(3,1,1);
    plot_smoothed_comparison(data.cycle(1).data.Voltage_measured, 'Voltage (V)', data.cycle(1).type);
    subplot(3,1,2);
    plot_smoothed_comparison(data.cycle(1).data.Current_measured, 'Current (A)', data.cycle(1).type);
    subplot(3,1,3);
    plot_smoothed_comparison(data.cycle(1).data.Temperature_measured, 'Temperature (°C)', data.cycle(1).type);
    sgtitle(['Original vs Smoothed Data (First ' data.cycle(1).type ' Cycle)']);

    % 调整图表布局
    set(gcf, 'Position', [100, 100, 1200, 800]);

    % 2. 健康因子随循环次数的变化趋势图
    figure;
    % Charge Time to 4.2V
    subplot(2,2,1);
    plot(1:length(data.health_factors.charge_time_to_4_2V), data.health_factors.charge_time_to_4_2V, '.-');
    title('Charge Time to 4.2V');
    xlabel('Cycle Number');
    ylabel('Time (s)');
    
    % Charge Time to Current Drop
    subplot(2,2,2);
    plot(1:length(data.health_factors.charge_time_to_current_drop), data.health_factors.charge_time_to_current_drop, '.-');
    title('Charge Time to Current Drop');
    xlabel('Cycle Number');
    ylabel('Time (s)');
    
    % Discharge Time to Min Voltage
    subplot(2,2,3);
    plot(1:length(data.health_factors.discharge_time_to_min_voltage), data.health_factors.discharge_time_to_min_voltage, '.-');
    title('Discharge Time to Min Voltage');
    xlabel('Cycle Number');
    ylabel('Time (s)');
    
    % Discharge Time to Zero Current
    subplot(2,2,4);
    plot(1:length(data.health_factors.discharge_time_to_zero_current), data.health_factors.discharge_time_to_zero_current, '.-');
    title('Discharge Time to Zero Current');
    xlabel('Cycle Number');
    ylabel('Time (s)');
    
    % 设置总标题
    sgtitle('Health Factors vs Cycle Number');
    
    % 调整图表布局
    set(gcf, 'Position', [100, 100, 1200, 800]);


    % 3. 温度特征随循环次数的变化趋势图
    figure;
    subplot(2,2,1);
    plot(1:length(data.temp_features.charge_time_to_max_temp), data.temp_features.charge_time_to_max_temp, 'DisplayName', 'Charge');
    hold on;
    plot(1:length(data.temp_features.discharge_time_to_max_temp), data.temp_features.discharge_time_to_max_temp, 'DisplayName', 'Discharge');
    hold off;
    title('Time to Max Temperature');
    xlabel('Cycle Number');
    ylabel('Time (s)');
    legend('show');

    subplot(2,2,2);
    plot(1:length(data.temp_features.charge_max_temp), data.temp_features.charge_max_temp, 'DisplayName', 'Charge');
    hold on;
    plot(1:length(data.temp_features.discharge_max_temp), data.temp_features.discharge_max_temp, 'DisplayName', 'Discharge');
    hold off;
    title('Max Temperature');
    xlabel('Cycle Number');
    ylabel('Temperature (°C)');
    legend('show');

    subplot(2,2,3);
    plot(1:length(data.temp_features.charge_temp_diff), data.temp_features.charge_temp_diff, 'DisplayName', 'Charge');
    hold on;
    plot(1:length(data.temp_features.discharge_temp_diff), data.temp_features.discharge_temp_diff, 'DisplayName', 'Discharge');
    hold off;
    title('Temperature Difference');
    xlabel('Cycle Number');
    ylabel('Temperature (°C)');
    legend('show');

    subplot(2,2,4);
    plot(1:length(data.temp_features.charge_avg_temp_rate), data.temp_features.charge_avg_temp_rate, 'DisplayName', 'Charge');
    hold on;
    plot(1:length(data.temp_features.discharge_avg_temp_rate), data.temp_features.discharge_avg_temp_rate, 'DisplayName', 'Discharge');
    hold off;
    title('Average Temperature Rate');
    xlabel('Cycle Number');
    ylabel('Temperature Rate (°C/s)');
    legend('show');

    % 调整图表布局
    set(gcf, 'Position', [100, 100, 1200, 800]);
end