%% Load and initial processing
I = imread("input/img19.png");
stretch_img = stretch_lin(I);
stretch_img = mat2gray(stretch_img);

img_gray = rgb2gray(stretch_img);

% Aplicar un filtro gaussiano para suavizar
img_smooth = imgaussfilt(img_gray, 2);

edge_de = edge(img_smooth, "canny");

%% rotation
[H, theta, rho] = hough(edge_de);
peaks = houghpeaks(H, 10);
lines = houghlines(edge_de, theta, rho, peaks);

angle_rot = mode([lines.theta]);
disp(angle_rot);

J = imrotate(I, angle_rot);

%% GRID
J_gray = rgb2gray(J);
edges = edge(J_gray, 'canny');
edges = bwareaopen(edges, 50);

se = strel('line', 3, 0);
edges_dilated_horizontal = imdilate(edges, se);
se = strel('line', 3, 90);
edges_dilated_vertical = imdilate(edges, se);

edges_dilated = or(edges_dilated_horizontal, edges_dilated_vertical);

J_overlay = J;
J_overlay(edges_dilated) = 0;     
J_overlay(:,:,2) = J_overlay(:,:,2) + uint8(edges_dilated*255);
J_overlay(edges_dilated) = 0;

figure(2)

imshow(J_overlay);


%% Detectar celdas vacías o con símbolos
[labels, num] = bwlabel(~edges_dilated);
stats = regionprops(labels, 'Area', 'BoundingBox');

has_symbol = false(num, 1);
%threshold = 400; % Ajustar según el tamaño de la celda y el símbolo

all_areas = [stats.Area];
threshold = 400




disp(threshold)

for k = 1:num
    if stats(k).Area < threshold
        has_symbol(k) = true;
    end
end

%% Visualización
figure('Position', [100, 100, 2400, 1200]);

imshow(I);
title("Original Image");

figure(3)

imshow(J_overlay);
hold on;

for k = 1:num
    if has_symbol(k)
        rectangle('Position', stats(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    else
        rectangle('Position', stats(k).BoundingBox, 'EdgeColor', 'b', 'LineWidth', 2);
    end
    
end

title("Stretched image rotated AND GRIDED (linear)");
hold off;
