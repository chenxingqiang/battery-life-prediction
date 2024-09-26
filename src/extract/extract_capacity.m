function capacity = extract_capacity(data)
    % Extract capacity data from the dataset
    if ~isfield(data, 'cycle')
        warning('Data structure does not contain a "cycle" field.');
        capacity = [];
        return;
    end

    cycles = data.cycle;
    num_cycles = length(cycles);
    capacity = zeros(num_cycles, 1);

    for i = 1:num_cycles
        if isfield(cycles(i).data, 'Capacity')
            capacity(i) = cycles(i).data.Capacity;
        else
            capacity(i) = NaN;
        end
    end

    % Remove NaN values
    capacity = capacity(~isnan(capacity));
end