function hist_vector = calc_hist_vector(input_img)
    % vector initializ
    hist_vector = zeros(1, 256);

    % get params of image
    [rows, cols] = size(input_img);

    % Iteration
    for i = 1:rows
        for j = 1:cols
            % Get intensity from i and j
            intensity = input_img(i, j);
            
            % Increase count
            hist_vector(intensity + 1) = hist_vector(intensity + 1) + 1;
        end
    end
end
