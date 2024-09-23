function plot_vmd_decomposition(vmd_result)
    % Plot the original signal and its decomposed modes (IMFs)
    dc = vmd_result.dc;
    imfs = vmd_result.imfs;
    num_imfs = size(imfs, 2);
    
    % Plot the original signal
    subplot(num_imfs + 1, 1, 1);
    plot(dc);
    title('Original Signal');
    ylabel('Amplitude');
    
    % Plot each IMF
    for i = 1:num_imfs
        subplot(num_imfs + 1, 1, i + 1);
        plot(imfs(:, i));
        title(['IMF ', num2str(i)]);
        ylabel('Amplitude');
    end
    xlabel('Sample Index');
end