
function pdf = generate_pdf(prediction)
    % 生成概率密度函数
    [f, xi] = ksdensity(prediction);
    pdf = struct('f', f, 'xi', xi);
end