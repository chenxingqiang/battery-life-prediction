function correlation_results = analyze_regeneration_correlation_v2(imfs_filtered, regeneration_data, charge_intervals)
    num_imfs = size(imfs_filtered, 2);
    correlation_results = struct('pearson', [], 'spearman', [], 'kendall', [], 'mutual_info', []);
    
    for i = 1:num_imfs
        imf = imfs_filtered(:, i);
        
        % Pearson correlation
        correlation_results.pearson(i) = corr(imf, regeneration_data, 'Type', 'Pearson');
        
        % Spearman correlation
        correlation_results.spearman(i) = corr(imf, regeneration_data, 'Type', 'Spearman');
        
        % Kendall correlation
        correlation_results.kendall(i) = corr(imf, regeneration_data, 'Type', 'Kendall');
        
        % Mutual Information
        correlation_results.mutual_info(i) = mutual_information(imf, regeneration_data);
    end
    
    % Correlation with charge intervals
    correlation_results.charge_intervals = struct();
    correlation_results.charge_intervals.pearson = corr(charge_intervals, regeneration_data, 'Type', 'Pearson');
    correlation_results.charge_intervals.spearman = corr(charge_intervals, regeneration_data, 'Type', 'Spearman');
    correlation_results.charge_intervals.kendall = corr(charge_intervals, regeneration_data, 'Type', 'Kendall');
    correlation_results.charge_intervals.mutual_info = mutual_information(charge_intervals, regeneration_data);
end

function mi = mutual_information(X, Y)
    % Simple implementation of mutual information
    % Note: This is a basic implementation and might not be suitable for all cases
    X = X(:);
    Y = Y(:);
    
    % Discretize the data
    X_disc = discretize(X, 10);
    Y_disc = discretize(Y, 10);
    
    % Calculate joint and marginal probabilities
    xy_hist = histcounts2(X_disc, Y_disc, [10 10]);
    xy_prob = xy_hist / sum(xy_hist(:));
    x_prob = sum(xy_prob, 2);
    y_prob = sum(xy_prob, 1);
    
    % Calculate mutual information
    mi = sum(sum(xy_prob .* log2(xy_prob ./ (x_prob * y_prob + eps))));
end