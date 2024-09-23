function data = fill_missing_cycles(data)
    % 实现数据补齐逻辑
    if isfield(data, 'cycle')
        for i = 1:length(data.cycle)
            if isfield(data.cycle(i), 'data')
                fields = fieldnames(data.cycle(i).data);
                for j = 1:length(fields)
                    data.cycle(i).data.(fields{j}) = fillmissing(data.cycle(i).data.(fields{j}), 'linear');
                end
            end
        end
    end
end