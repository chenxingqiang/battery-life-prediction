function charge_intervals = extract_charge_intervals_v2(data)
    if isfield(data, 'cycle')
        num_cycles = length(data.cycle);
        charge_intervals = zeros(num_cycles, 1);
        for i = 1:num_cycles
            if strcmp(data.cycle(i).type, 'charge') && isfield(data.cycle(i), 'data') && isfield(data.cycle(i).data, 'Time')
                charge_intervals(i) = data.cycle(i).data.Time(end) - data.cycle(i).data.Time(1);
            else
                charge_intervals(i) = NaN;
            end
        end
    else
        error('Cycle data not found in the provided structure');
    end
    
    % Remove NaN values
    charge_intervals = charge_intervals(~isnan(charge_intervals));
end