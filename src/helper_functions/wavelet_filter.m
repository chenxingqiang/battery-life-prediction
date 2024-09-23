function [dc_filtered, imfs_filtered] = wavelet_filter(dc, imfs)
    % 实现小波过滤算法
    wname = 'db4'; % 使用 Daubechies 4 小波
    level = 5; % 分解级别
    
    dc_filtered = wdenoise(dc, level, 'Wavelet', wname);
    
    imfs_filtered = zeros(size(imfs));
    for i = 1:size(imfs, 2)
        imfs_filtered(:, i) = wdenoise(imfs(:, i), level, 'Wavelet', wname);
    end
end