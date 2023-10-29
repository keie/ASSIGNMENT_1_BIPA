close all; clc; clear;

I = imread("input/img19.png");

stretch_img = stretch_lin(I);

figure(4);
subplot(2,2,1); 
    imshow(I);
    title('Original image');
subplot(2,2,2); 
    imshow(stretch_img);
    title('Stretched image (linear)');
subplot(2,2,3);
    bar(calc_hist_vector(I));
    title('Original histogram');
    xlim([1,256]);
subplot(2,2,4);
    bar(calc_hist_vector(stretch_img));
    title('Stretched histogram (linear)');
    xlim([1,256]);
 %%   
% ax1 = subplot(2,2,1);
Igray = rgb2gray(stretch_img);
% imshow(Igray);

%%
edge_de =  edge(Igray, 'canny');
figure,imshow(edge_de);
%%
[H,theta,rho] = hough(edge_de);
peaks  = houghpeaks(H,10);
lines = houghlines(edge_de,theta,rho,peaks);
% ax3 = subplot(2,2,3);
% figure, imshow(edge_de)

hold on
for k = 1:numel(lines)
    x1 = lines(k).point1(1);
    y1 = lines(k).point1(2);
    x2 = lines(k).point2(1);
    y2 = lines(k).point2(2);
    plot([x1 x2],[y1 y2],'Color','g','LineWidth', 2)
end
hold off

%%
angle_rot = mode([lines.theta]);
disp(angle_rot);
%%
J = imrotate( I , angle_rot);
figure, imshow(J);

%%
[centers, radii, metric] = imfindcircles(Igray,[15 30]);
centersStrong5 = centers(); 
radiiStrong5 = radii();
metricStrong5 = metric();
viscircles(centersStrong5, radiiStrong5,'EdgeColor','b');



    
