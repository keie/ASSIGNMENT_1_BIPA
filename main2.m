%% Carga y procesamiento inicial
I = imread("input/img01.png");
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

img_gray = rgb2gray(stretch_img);
edges_img = edge(img_gray, 'Canny'); % Detección de bordes con Canny

figure; % Nueva figura para mostrar la imagen con bordes resaltados
imshow(edges_img);
title("Edges using Canny");


%%
[H,theta,rho] = hough(edges_img);
peaks = houghpeaks(H,10);
lines = houghlines(edges_img,theta,rho,peaks)

%%
angle_rot = mode([lines.theta]);
disp(angle_rot);

%%
J = imrotate(I,angle_rot);
figure(4)
imshow(J)
