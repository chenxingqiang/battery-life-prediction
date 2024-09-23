function [alpha, k, tau] = grid_search_vmd(signal)
    % 实现网格搜索逻辑
    k_range = 2:8;  % 确保至少有 2 个 IMF
    tau_range = [0, 0.25, 0.5, 0.75, 1];
    
    best_score = Inf;
    best_params = [k_range(1), tau_range(1)];  % 初始化为有效值
    
    for k = k_range
        for t = tau_range
            try
                % 尝试使用参数进行 VMD 分解
                [imfs, residual] = vmd(signal, 'NumIMF', k);
                score = evaluate_vmd(signal, imfs, residual);
                if score < best_score
                    best_score = score;
                    best_params = [k, t];
                end
            catch e
                % 如果出错，记录错误并继续下一次迭代
                warning('Error in VMD decomposition: %s', e.message);
                continue;
            end
        end
    end
    
    alpha = 2000; % 默认值，实际上不会被使用
    k = max(2, best_params(1));  % 确保 k 至少为 2
    tau = best_params(2);
    
    disp(['Grid search results: k = ', num2str(k), ', tau = ', num2str(tau)]);
end