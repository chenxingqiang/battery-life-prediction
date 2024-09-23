function score = evaluate_vmd(signal, imfs, residual)
    % 计算信息重叠度 (IO) 和重构误差 (RE)
    IO = calculate_information_overlap(imfs);
    RE = norm(signal - sum(imfs, 2) - residual) / norm(signal);
    score = IO + RE; % 可以根据需要调整权重
end