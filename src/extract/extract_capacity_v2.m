function capacity = extract_capacity_v2(data)
    if isfield(data, 'cycle')
        num_cycles = length(data.cycle);
        capacity = zeros(num_cycles, 1);
        for i = 1:num_cycles
            if isfield(data.cycle(i), 'data') && isfield(data.cycle(i).data, 'Capacity')
                capacity(i) = data.cycle(i).data.Capacity;
            else
                capacity(i) = NaN;
            end
        end
    elseif isfield(data, 'Capacity')
        capacity = data.Capacity;
    else
        error('Capacity data not found in the provided structure');
    end
    
    % Remove NaN values and interpolate
    valid_indices = ~isnan(capacity);
    x = find(valid_indices);
    capacity = interp1(x, capacity(valid_indices), 1:length(capacity), 'pchip');
end