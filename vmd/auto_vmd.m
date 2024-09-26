function [dc, imfs, alpha, K, tau] = auto_vmd(signal)
    % Estimate the number of modes
    [psd, freq] = periodogram(signal);
    [~, peaks] = findpeaks(psd);
    K = min(length(peaks), 10);  % Limit to a maximum of 10 modes
    
    % Set initial parameters
    alpha = 2000;
    tau = 0;
    tol = 1e-7;
    
    % Perform VMD
    [imfs, ~, ~] = vmd(signal, 'Alpha', alpha, 'Tau', tau, 'K', K, 'DC', 1, 'InitMethod', 'rand', 'TolA', tol);
    
    % Calculate trend (dc)
    dc = signal - sum(imfs, 2);
    
    % Optimize alpha using a simple grid search
    alpha_range = logspace(2, 4, 10);
    best_alpha = alpha;
    min_error = inf;
    
    for a = alpha_range
        [imfs_temp, ~, ~] = vmd(signal, 'Alpha', a, 'Tau', tau, 'K', K, 'DC', 1, 'InitMethod', 'rand', 'TolA', tol);
        error = norm(signal - sum(imfs_temp, 2) - dc);
        if error < min_error
            min_error = error;
            best_alpha = a;
        end
    end
    
    % Final VMD with optimized alpha
    [imfs, ~, ~] = vmd(signal, 'Alpha', best_alpha, 'Tau', tau, 'K', K, 'DC', 1, 'InitMethod', 'rand', 'TolA', tol);
    dc = signal - sum(imfs, 2);
    alpha = best_alpha;
end