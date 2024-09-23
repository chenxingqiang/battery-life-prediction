function correlation_results = analyze_regeneration_correlation(imfs_filtered, regeneration_data)
    % Analyze the correlation between IMFs and capacity regeneration data
    num_imfs = size(imfs_filtered, 2);
    correlation_results = zeros(num_imfs, 1);
    
    for i = 1:num_imfs
        % Ensure the data vectors are the same length
        min_length = min(length(imfs_filtered(:, i)), length(regeneration_data));
        imf = imfs_filtered(1:min_length, i);
        regeneration = regeneration_data(1:min_length);
        
        % Compute the correlation coefficient
        correlation_results(i) = corr(imf, regeneration, 'Rows', 'complete');
    end
end