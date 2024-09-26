function charge_intervals = extract_charge_intervals(data)
    if isfield(data, 'cycle')
        cycles = data.cycle;
        charge_intervals = zeros(length(cycles), 1);
        last_charge_time = [];
        charge_count = 0;
        for i = 1:length(cycles)
            if strcmp(cycles(i).type, 'charge')
                if ~isempty(last_charge_time)
                    charge_count = charge_count + 1;  % Increment charge_count here
                    charge_intervals(charge_count) = etime(cycles(i).time, last_charge_time);
                end
                last_charge_time = cycles(i).time;
            end
        end
        % Remove extra zeros
        charge_intervals = charge_intervals(1:charge_count);
        disp(['Extracted charge intervals. Length: ', num2str(length(charge_intervals)), ', Charge count: ', num2str(charge_count)]);
    else
        warning('Data structure does not contain a "cycle" field.');
        charge_intervals = [];
    end
end