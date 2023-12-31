%% Carga y procesamiento inicial
I = imread("input/img02.png");
stretch_img = stretch_lin(I);
stretch_img = mat2gray(stretch_img);

figure('Position', [100, 100, 2400, 1200]); 

% Original y estirado
subplot(1,2,1); 
imshow(I);
title("Original Image");

subplot(1,2,2);
imshow(stretch_img);
title("Stretched image (linear)");

%% Aplicación de Fourier
F = fft2(stretch_img);
[P,M] = fourier_parts(F);

%figure('Position', [100, 100, 2400, 1200]); 
%subplot(1,2,1); imagesc(P); axis equal off; colormap gray; title('Phase');
%subplot(1,2,2); imagesc(M); axis equal off; colormap gray; title('Magnitude');

img_gray = rgb2gray(stretch_img);

edge_de = edge(img_gray,"canny");

%figure(3);
%imshow(edge_de);

%%
[H,theta,rho] = hough(edge_de);
peaks = houghpeaks(H,10);
lines = houghlines(edge_de,theta,rho,peaks)

%%
angle_rot = mode([lines.theta]);
disp(angle_rot);

%%
J = imrotate(I,angle_rot);
%figure(4)
%imshow(J)



% Convertir J a escala de grises
imbinarize
J_gray = rgb2gray(J);

% Usar detector de bordes Canny
edges = edge(J_gray, 'canny');

% Engrosar las líneas detectadas
se = strel('line', 3, 0);  % elemento estructurante línea horizontal
edges_dilated_horizontal = imdilate(edges, se);
figure(9);
imshow(edges_dilated_horizontal);
se = strel('line', 3, 90); % elemento estructurante línea vertical
edges_dilated_vertical = imdilate(edges, se);

edges_dilated = or(edges_dilated_horizontal, edges_dilated_vertical);

% Superponer líneas engrosadas sobre J en color verde
J_overlay = J;
J_overlay(edges_dilated) = 0;     % establecer canal rojo a 0
J_overlay(:,:,2) = J_overlay(:,:,2) + uint8(edges_dilated*255); % incrementar canal verde
J_overlay(edges_dilated) = 0;     % establecer canal azul a 0

figure(5);
imshow(J_overlay);




% Encontrar la línea más larga para cada jugador
[lengthP1, lineStartP1, lineEndP1] = findLongestLine(player1_coords);
[lengthP2, lineStartP2, lineEndP2] = findLongestLine(player2_coords);

% Trazar la línea más larga para el jugador 1 (si existe)
if ~isempty(lineStartP1) && ~isempty(lineEndP1)
    hold on;
    plot([lineStartP1(1), lineEndP1(1)], [lineStartP1(2), lineEndP1(2)], 'g', 'LineWidth', 2);
    hold off;
end

% Trazar la línea más larga para el jugador 2 (si existe)
if ~isempty(lineStartP2) && ~isempty(lineEndP2)
    hold on;
    plot([lineStartP2(1), lineEndP2(1)], [lineStartP2(2), lineEndP2(2)], 'r', 'LineWidth', 2);
    hold off;
end

% Determinar el ganador
if lengthP1 > lengthP2
    fprintf('¡El ganador es el Jugador 1 con una línea de longitud %.2f!\n', lengthP1);
elseif lengthP2 > lengthP1
    fprintf('¡El ganador es el Jugador 2 con una línea de longitud %.2f!\n', lengthP2);
else
    fprintf('¡Es un empate!\n');
end