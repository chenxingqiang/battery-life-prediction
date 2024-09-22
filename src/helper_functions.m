function prediction = predict_svr_sliding_window(capacity, health_factors)
    % 实现 SVR with sliding window
    window_size = 10;
    X = zeros(length(capacity) - window_size, window_size * size(health_factors, 2));
    y = zeros(length(capacity) - window_size, 1);
    
    for i = 1:length(capacity) - window_size
        X(i, :) = reshape(health_factors(i:i+window_size-1, :)', 1, []);
        y(i) = capacity(i + window_size);
    end
    
    mdl = fitrsvm(X, y, 'KernelFunction', 'rbf', 'Standardize', true);
    prediction = predict(mdl, X);
end

function prediction = predict_lstm(capacity, health_factors)
    % 实现 LSTM prediction
    X = health_factors';
    y = capacity';
    
    numFeatures = size(X, 1);
    numResponses = 1;
    numHiddenUnits = 100;
    
    layers = [ ...
        sequenceInputLayer(numFeatures)
        lstmLayer(numHiddenUnits)
        fullyConnectedLayer(numResponses)
        regressionLayer];
    
    options = trainingOptions('adam', ...
        'MaxEpochs', 100, ...
        'GradientThreshold', 1, ...
        'InitialLearnRate', 0.005, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropPeriod', 125, ...
        'LearnRateDropFactor', 0.2, ...
        'Verbose', 0, ...
        'Plots', 'training-progress');
    
    net = trainNetwork(X, y, layers, options);
    prediction = predict(net, X)';
end

function combined_prediction = combine_effects(svr_prediction, lstm_prediction, dataset)
    % 结合温度和容量再生效应
    w1 = 0.5; w2 = 0.5; % 权重可以根据需要调整
    combined_prediction = w1 * svr_prediction + w2 * lstm_prediction;
    
    % 添加温度效应
    temp_effect = dataset.temperature_analysis.best_fit.model.Fitted;
    combined_prediction = combined_prediction + temp_effect;
    
    % 添加容量再生效应
    regen_effect = sum(dataset.capacity_regeneration.imfs_filtered, 2);
    combined_prediction = combined_prediction + regen_effect;
end

function soh = calculate_soh(capacity)
    % 计算 State of Health (SOH)
    initial_capacity = capacity(1);
    soh = capacity / initial_capacity * 100;
end

function pdf = generate_pdf(prediction)
    % 生成概率密度函数
    [f, xi] = ksdensity(prediction);
    pdf = struct('f', f, 'xi', xi);
end

function plot_vmd_decomposition(vmd_result)
    % 绘制 VMD 分解结果
    figure;
    subplot(length(vmd_result.imfs)+1, 1, 1);
    plot(vmd_result.dc);
    title('DC Component');
    
    for i = 1:length(vmd_result.imfs)
        subplot(length(vmd_result.imfs)+1, 1, i+1);
        plot(vmd_result.imfs(:,i));
        title(['IMF ', num2str(i)]);
    end
    
    sgtitle('VMD Decomposition');
end

function plot_regeneration_correlation(vmd_result)
    % 绘制容量再生相关性
    figure;
    bar(vmd_result.correlation_results);
    xlabel('IMF Index');
    ylabel('Correlation with Charge Intervals');
    title('Capacity Regeneration Correlation');
end

function plot_temperature_impact(temp_result)
    % 绘制温度影响分析结果
    figure;
    plot(temp_result.best_fit.model.Variables.x, temp_result.best_fit.model.Variables.y, 'b.');
    hold on;
    plot(temp_result.best_fit.model.Variables.x, temp_result.best_fit.model.Fitted, 'r-');
    xlabel('Temperature');
    ylabel('Capacity');
    title(['Temperature Impact: ', temp_result.best_model]);
    legend('Data', 'Fitted Model');
end

function plot_capacity_prediction(pred_result)
    % 绘制容量预测结果
    figure;
    plot(pred_result.actual, 'b-', 'DisplayName', 'Actual');
    hold on;
    plot(pred_result.svr_prediction, 'r--', 'DisplayName', 'SVR Prediction');
    plot(pred_result.lstm_prediction, 'g--', 'DisplayName', 'LSTM Prediction');
    plot(pred_result.combined_prediction, 'k-', 'DisplayName', 'Combined Prediction');
    xlabel('Cycle');
    ylabel('Capacity');
    title('Capacity Prediction');
    legend('show');
end

function plot_soh_prediction(pred_result)
    % 绘制 SOH 预测结果
    figure;
    plot(pred_result.soh, 'b-');
    xlabel('Cycle');
    ylabel('SOH (%)');
    title('State of Health Prediction');
end

function plot_prediction_pdf(pred_result)
    % 绘制预测概率密度函数
    figure;
    plot(pred_result.pdf.xi, pred_result.pdf.f);
    xlabel('Predicted Capacity');
    ylabel('Density');
    title('Prediction Probability Density Function');
end

function export_to_csv(vmd_results, gs_results, temperature_analysis_results, capacity_prediction_results)
    % 实现导出到 CSV 的逻辑
    datasets = {'B0005', 'B0006', 'B0007', 'B0018'};
    
    for i = 1:length(datasets)
        filename = ['results_', datasets{i}, '.csv'];
        fid = fopen(filename, 'w');
        
        % 写入表头
        fprintf(fid, 'Dataset,VMD_DC,VMD_IMF1,VMD_IMF2,VMD_IMF3,VMD_Alpha,VMD_K,VMD_Tau,Temp_Best_Model,Temp_RMSE,SVR_Prediction,LSTM_Prediction,Combined_Prediction,SOH\n');
        
        % 写入数据
        for j = 1:length(vmd_results{i}.dc)
            fprintf(fid, '%s,', datasets{i});
            fprintf(fid, '%.4f,', vmd_results{i}.dc(j));
            fprintf(fid, '%.4f,%.4f,%.4f,', vmd_results{i}.imfs(j,:));
            fprintf(fid, '%.4f,%.0f,%.2f,', gs_results{i}.alpha, gs_results{i}.k, gs_results{i}.tau);
            fprintf(fid, '%s,%.4f,', temperature_analysis_results{i}.best_model, temperature_analysis_results{i}.best_fit.rmse);
            fprintf(fid, '%.4f,%.4f,%.4f,%.4f\n', ...
                capacity_prediction_results{i}.svr_prediction(j), ...
                capacity_prediction_results{i}.lstm_prediction(j), ...
                capacity_prediction_results{i}.combined_prediction(j), ...
                capacity_prediction_results{i}.soh(j));
        end
        
        fclose(fid);
    end
end

function fit_result = fit_direct_temp(dc, temp_features)
    % 直接使用温度特征进行拟合
    mdl = fitlm(temp_features, dc);
    fit_result = struct('model', mdl, 'rmse', sqrt(mean((predict(mdl) - dc).^2)));
end

function fit_result = fit_exponential_temp(dc, temp_features)
    % 使用指数温度模型进行拟合
    T = mean(temp_features, 2); % 使用平均温度
    mdl = fitnlm(T, dc, @(b,x) b(1) * exp(b(2) * x), [1, 0.01]);
    fit_result = struct('model', mdl, 'rmse', sqrt(mean((predict(mdl, T) - dc).^2)));
end

function fit_result = fit_arrhenius_temp(dc, temp_features)
    % 使用 Arrhenius 模型进行拟合
    T = mean(temp_features, 2); % 使用平均温度
    mdl = fitnlm(1./(T + 273.15), log(dc), @(b,x) b(1) + b(2) * x, [0, -1]);
    fit_result = struct('model', mdl, 'rmse', sqrt(mean((exp(predict(mdl, 1./(T + 273.15))) - dc).^2)));
end

function fit_result = fit_no_temp(dc)
    % 不考虑温度影响的基准拟合
    t = (1:length(dc))';
    mdl = fitlm(t, dc);
    fit_result = struct('model', mdl, 'rmse', sqrt(mean((predict(mdl) - dc).^2)));
end

function [best_model, best_fit] = evaluate_models(fit_results, model_names)
    % 评估模型性能并选择最佳模型
    rmse_values = cellfun(@(x) x.rmse, fit_results);
    [~, best_index] = min(rmse_values);
    best_model = model_names{best_index};
    best_fit = fit_results{best_index};
end

function correlation_results = analyze_regeneration_correlation(imfs, charge_intervals)
    % 实现相关度分析逻辑
    correlation_results = zeros(size(imfs, 2), 1);
    
    for i = 1:size(imfs, 2)
        correlation_results(i) = corr(imfs(:, i), charge_intervals);
    end
end

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


function [ls_prediction, rvm_prediction] = predict_capacity(dc, imfs)
    % 实现 LS 和 RVM 预测逻辑
    % 使用前 70% 数据作为训练集,后 30% 作为测试集
    n = length(dc);
    train_size = round(0.7 * n);
    
    X = [dc, imfs];
    y = cumsum(dc); % 假设我们预测的是累积容量
    
    X_train = X(1:train_size, :);
    y_train = y(1:train_size);
    X_test = X(train_size+1:end, :);
    
    % LS 预测
    ls_model = fitlm(X_train, y_train);
    ls_prediction = predict(ls_model, X_test);
    
    % RVM 预测
    rvm_model = rvm(X_train, y_train);
    [rvm_prediction, ~] = predict(rvm_model, X_test);
end

function [alpha, k, tau] = grid_search_vmd(signal)
    % 实现网格搜索逻辑
    alpha_range = logspace(-6, 1, 8);
    k_range = 2:8;
    tau_range = [0, 0.25, 0.5, 0.75, 1];
    
    best_score = Inf;
    best_params = [0, 0, 0];
    
    for a = alpha_range
        for k = k_range
            for t = tau_range
                [imfs, residual] = vmd(signal, 'Alpha', a, 'K', k, 'Tau', t);
                score = evaluate_vmd(signal, imfs, residual);
                if score < best_score
                    best_score = score;
                    best_params = [a, k, t];
                end
            end
        end
    end
    
    alpha = best_params(1);
    k = best_params(2);
    tau = best_params(3);
end

function score = evaluate_vmd(signal, imfs, residual)
    % 计算信息重叠度 (IO) 和重构误差 (RE)
    IO = calculate_information_overlap(imfs);
    RE = norm(signal - sum(imfs, 2) - residual) / norm(signal);
    score = IO + RE; % 可以根据需要调整权重
end

function IO = calculate_information_overlap(imfs)
    n_imfs = size(imfs, 2);
    IO = 0;
    for i = 1:n_imfs
        for j = i+1:n_imfs
            IO = IO + sum(abs(imfs(:,i) .* imfs(:,j))) / (norm(imfs(:,i)) * norm(imfs(:,j)));
        end
    end
    IO = IO / (n_imfs * (n_imfs - 1) / 2);
end


function data = extract_temperature_data(data)
    % 提取温度相关数据
    data.temp_features = struct();
    
    % 1. 温度从开始充/放电开始变化至温度最高点所需的时间
    data.temp_features.time_to_max_temp_charge = calculate_time_to_max_temp(data.charge);
    data.temp_features.time_to_max_temp_discharge = calculate_time_to_max_temp(data.discharge);
    
    % 2. 最高/低温度
    data.temp_features.max_temp_charge = max(data.charge.Temperature_measured);
    data.temp_features.min_temp_charge = min(data.charge.Temperature_measured);
    data.temp_features.max_temp_discharge = max(data.discharge.Temperature_measured);
    data.temp_features.min_temp_discharge = min(data.discharge.Temperature_measured);
    
    % 3. 温差
    data.temp_features.temp_range_charge = data.temp_features.max_temp_charge - data.temp_features.min_temp_charge;
    data.temp_features.temp_range_discharge = data.temp_features.max_temp_discharge - data.temp_features.min_temp_discharge;
    
    % 4. 某一段（具有分析意义的区间）的平均温度变化率
    data.temp_features.avg_temp_change_rate_charge = calculate_avg_temp_change_rate(data.charge);
    data.temp_features.avg_temp_change_rate_discharge = calculate_avg_temp_change_rate(data.discharge);
end

function time = calculate_time_to_max_temp(cycle_data)
    temp = cycle_data.Temperature_measured;
    time_vector = cycle_data.Time;
    [~, idx] = max(temp);
    time = time_vector(idx);
end

function rate = calculate_avg_temp_change_rate(cycle_data)
    temp = cycle_data.Temperature_measured;
    time_vector = cycle_data.Time;
    temp_change = temp(end) - temp(1);
    time_change = time_vector(end) - time_vector(1);
    rate = temp_change / time_change;
end

function data = extract_health_factors(data)
    % 提取健康因子
    data.health_factors = struct();
    
    % 1. 充电时电压上升至稳定4.2V左右所需时间
    data.health_factors.charge_time_to_4_2V = calculate_charge_time_to_voltage(data, 4.2);
    
    % 2. 充电至电流开始下降所需时间
    data.health_factors.charge_time_to_current_drop = calculate_charge_time_to_current_drop(data);
    
    % 3. 放电时电压降至最低所需时间
    data.health_factors.discharge_time_to_min_voltage = calculate_discharge_time_to_min_voltage(data);
    
    % 4. 放电时电流至0所需时间
    data.health_factors.discharge_time_to_zero_current = calculate_discharge_time_to_zero_current(data);
end

function time = calculate_charge_time_to_voltage(data, target_voltage)
    voltage = data.charge.Voltage_measured;
    time_vector = data.charge.Time;
    [~, idx] = min(abs(voltage - target_voltage));
    time = time_vector(idx);
end

function time = calculate_charge_time_to_current_drop(data)
    current = data.charge.Current_measured;
    time_vector = data.charge.Time;
    [~, idx] = max(current);
    time = time_vector(idx);
end

function time = calculate_discharge_time_to_min_voltage(data)
    voltage = data.discharge.Voltage_measured;
    time_vector = data.discharge.Time;
    [~, idx] = min(voltage);
    time = time_vector(idx);
end

function time = calculate_discharge_time_to_zero_current(data)
    current = data.discharge.Current_measured;
    time_vector = data.discharge.Time;
    [~, idx] = min(abs(current));
    time = time_vector(idx);
end

function data = smooth_data(data)
    % 实现数据平滑逻辑
    % 这里使用移动平均法进行平滑
    window_size = 5; % 可以根据需要调整窗口大小
    fields = fieldnames(data);
    for i = 1:length(fields)
        if isnumeric(data.(fields{i})) && size(data.(fields{i}), 1) > window_size
            data.(fields{i}) = movmean(data.(fields{i}), window_size, 'Endpoints', 'shrink');
        end
    end
end

function data = fill_missing_cycles(data)
    % 实现数据补齐逻辑
    % 这里使用线性插值方法补齐缺失的充放电数据
    fields = fieldnames(data);
    for i = 1:length(fields)
        if isnumeric(data.(fields{i})) && size(data.(fields{i}), 1) > 1
            data.(fields{i}) = fillmissing(data.(fields{i}), 'linear', 'EndValues', 'nearest');
        end
    end
end