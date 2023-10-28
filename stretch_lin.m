function output_img = stretch_lin(input_img)
    input_img = double(input_img);
    % Find min and Max
    x_min = min(input_img(:));
    x_max = max(input_img(:));
    % Apply stretching transformation
    output_img = uint8(255 * (input_img - x_min) / (x_max - x_min));
end
