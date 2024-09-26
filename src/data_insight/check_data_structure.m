function check_data_structure(data)
    fprintf('Checking data structure...\n');
    
    % 检查顶层字段
    top_fields = fieldnames(data);
    fprintf('Top-level fields: %s\n', strjoin(top_fields, ', '));
    
    % 检查 cycle 字段
    if isfield(data, 'cycle')
        fprintf('Number of cycles: %d\n', length(data.cycle));
        
        % 检查第一个和最后一个周期的结构
        check_cycle_structure(data.cycle(1), 'First cycle');
        check_cycle_structure(data.cycle(end), 'Last cycle');
        
        % 检查充电和放电周期的数量
        charge_cycles = sum(strcmp({data.cycle.type}, 'charge'));
        discharge_cycles = sum(strcmp({data.cycle.type}, 'discharge'));
        fprintf('Number of charge cycles: %d\n', charge_cycles);
        fprintf('Number of discharge cycles: %d\n', discharge_cycles);
    else
        fprintf('No cycle field found.\n');
    end
    
    % 检查健康因子
    if isfield(data, 'health_factors')
        check_health_factors(data.health_factors);
    else
        fprintf('No health_factors field found.\n');
    end
end

function check_cycle_structure(cycle, cycle_name)
    fprintf('\nChecking %s structure:\n', cycle_name);
    fprintf('Type: %s\n', cycle.type);
    fprintf('Fields in cycle: %s\n', strjoin(fieldnames(cycle), ', '));
    
    if isfield(cycle, 'data')
        data_fields = fieldnames(cycle.data);
        fprintf('Fields in cycle.data: %s\n', strjoin(data_fields, ', '));
        
        for i = 1:length(data_fields)
            field = data_fields{i};
            value = cycle.data.(field);
            if isnumeric(value)
                fprintf('%s: Size %s, Range [%.2f, %.2f]\n', field, mat2str(size(value)), min(value), max(value));
            else
                fprintf('%s: %s\n', field, class(value));
            end
        end
    else
        fprintf('No data field in cycle.\n');
    end
end

function check_health_factors(health_factors)
    fprintf('\nChecking health factors:\n');
    factor_names = fieldnames(health_factors);
    
    for i = 1:length(factor_names)
        factor = factor_names{i};
        values = health_factors.(factor);
        non_nan_count = sum(~isnan(values));
        fprintf('%s: %d non-NaN values out of %d\n', factor, non_nan_count, length(values));
        if non_nan_count > 0
            fprintf('  Range: [%.2f, %.2f]\n', min(values(~isnan(values))), max(values(~isnan(values))));
        end
    end
end