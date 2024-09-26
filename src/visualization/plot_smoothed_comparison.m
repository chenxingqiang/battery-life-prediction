function plot_smoothed_comparison(data, ylabel_text, cycle_type)
    plot(data, 'DisplayName', 'Original');
    hold on;
    plot(smoothdata(data, 'gaussian', 5), 'DisplayName', 'Smoothed');
    hold off;
    title([cycle_type ' Cycle']);
    xlabel('Time');
    ylabel(ylabel_text);
    legend('show');
end