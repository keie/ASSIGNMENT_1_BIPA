%works with 19,21

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
figure(2);
imshow(J_overlay);

%% Detectar celdas vacías o con símbolos
clean_img = imopen(~edges_dilated, se);
[labels, num] = bwlabel(clean_img);
stats = regionprops(labels, 'Area', 'BoundingBox', 'Eccentricity', 'Solidity');

has_symbol = false(num, 1);
all_areas = [stats.Area];
threshold = 400;
disp(threshold);

% Definición de valores iniciales
some_value = 0.856;  % excentricidad máxima esperada para un símbolo
another_value = 0.55;  % solidez mínima esperada para un símbolo

for k = 1:num
    if stats(k).Area < threshold && stats(k).Eccentricity < some_value && stats(k).Solidity > another_value
        has_symbol(k) = true;
    end
end



%% Convertir J_overlay a escala de grises para mostrar en fondo negro
% J_overlay_gray = rgb2gray(J_overlay);
% 
% output_img = false(size(J_overlay_gray));
% 
% for k = 1:num
%     if has_symbol(k)
%         output_img(labels == k) = J_overlay_gray(labels == k) > 0;
%     end
% end

%% Visualización
figure('Position', [100, 100, 2400, 1200]);
imshow(I);
title("Original Image");

figure(3);
imshow(J_overlay);
hold on;
for k = 1:num
    if has_symbol(k)
        rectangle('Position', stats(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
end
title("Stretched image rotated AND GRIDED (linear)");
hold off;
% 
% figure(4);
% imshow(output_img);
% title("Output Image with Detected Symbols");



% Define un umbral para diferenciar entre cuadrados grandes y pequeños.
% Este valor puede necesitar ser ajustado según la imagen.
umbral_cuadro = 10; 

for k = 1:num
    if has_symbol(k) % Solo si la celda tiene un símbolo
        % Extrae las dimensiones de la celda
        bb = floor(stats(k).BoundingBox);
        width = bb(3);
        height = bb(4);

        % Si es un cuadro pequeño, lo coloreamos
        if width < umbral_cuadro && height < umbral_cuadro
            x_start = bb(1); x_end = bb(1) + bb(3);
            y_start = bb(2); y_end = bb(2) + bb(4);

            % Cambia el color de la celda a azul
            J_overlay(y_start:y_end, x_start:x_end, 1) = 0; % Canal rojo
            J_overlay(y_start:y_end, x_start:x_end, 2) = 0; % Canal verde
            J_overlay(y_start:y_end, x_start:x_end, 3) = 255; % Canal azul
        end
    end
end

% Visualizar la imagen con los cuadros pequeños coloreados
figure(5);
imshow(J_overlay);
title("Image with Small Cells Colored");





