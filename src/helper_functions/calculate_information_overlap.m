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