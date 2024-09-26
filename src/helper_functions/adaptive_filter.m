function [dc_filtered, imfs_filtered] = adaptive_filter(dc, imfs)
    % Apply Savitzky-Golay filter to dc
    dc_filtered = sgolayfilt(dc, 3, 21);
    
    % Apply adaptive thresholding to IMFs
    num_imfs = size(imfs, 2);
    imfs_filtered = zeros(size(imfs));
    
    for i = 1:num_imfs
        imf = imfs(:, i);
        threshold = 3 * std(imf);  % 3-sigma rule
        imf_filtered = imf;
        imf_filtered(abs(imf) < threshold) = 0;
        imfs_filtered(:, i) = imf_filtered;
    end
end