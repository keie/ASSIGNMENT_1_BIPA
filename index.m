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

figure(1);
imshow(J);






