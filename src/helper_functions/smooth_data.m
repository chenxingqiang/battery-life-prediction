function data = smooth_data(data)
    % 实现数据平滑逻辑
    window_size = 5; % 可以根据需要调整窗口大小
    if isfield(data, 'cycle')
        for i = 1:length(data.cycle)
            if isfield(data.cycle(i), 'data')
                fields = fieldnames(data.cycle(i).data);
                for j = 1:length(fields)
                    data.cycle(i).data.(fields{j}) = movmean(data.cycle(i).data.(fields{j}), window_size);
                end
            end
        end
    end
end