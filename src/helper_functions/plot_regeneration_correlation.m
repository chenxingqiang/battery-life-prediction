function plot_regeneration_correlation(vmd_result)
    % Plot the correlation between capacity regeneration and IMFs
    % Assuming vmd_result contains 'imfs' and 'charge_intervals'
    
    imfs = vmd_result.imfs;
    regeneration_data = vmd_result.regeneration_data; % Assuming this field exists
    
    % For simplicity, let's assume we have one IMF and regeneration data
    if size(imfs, 2) >= 1 && ~isempty(regeneration_data)
        scatter(imfs(:, 1), regeneration_data);
        xlabel('IMF 1');
        ylabel('Capacity Regeneration');
        title('Correlation between IMF 1 and Capacity Regeneration');
    else
        text(0.5, 0.5, 'Insufficient data for correlation plot', 'HorizontalAlignment', 'center');
        axis off;
    end
end