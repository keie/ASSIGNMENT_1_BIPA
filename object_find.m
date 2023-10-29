clc
close all
filename ="input/img19.png";
img1 = imread(filename);
imshow(img1);
title('Original image')
%%
img = rgb2gray(imread(filename));
imshow(img);
%%
BW = imbinarize(img,graythresh(img));
%BW = stretch_lin(img);
BW = ~BW;
%figure
imshow(BW);

%%
CC = bwconncomp(BW);
disp(CC)
%%
stats = regionprops(CC);
disp(stats);
bw2 = BW;
% Display the original image
imshow(BW);

player1_symbol= {};
player2_symbol= {};
bbno=1;
for i = 1:numel(stats)
    % Extract the coordinates of the bounding box
    area = stats(i).Area;
    %if area > 50
        x = stats(i).BoundingBox(1);
        y = stats(i).BoundingBox(2);
        width = stats(i).BoundingBox(3);
        height = stats(i).BoundingBox(4);
        
        m_X = stats(i).Centroid(1);
        m_y = stats(i).Centroid(2);
        
        test_mat = BW(round(m_y)-3:round(m_y)+3,round(m_X)-3:round(m_X)+3);
        
        if any(test_mat == 0) 
            bboxColor = 'g';
            player1_symbol = [player1_symbol ,[stats(i).BoundingBox]];
        else  
            bboxColor = 'r';
            player2_symbol = [player2_symbol ,[stats(i).BoundingBox]];
        end    
%         bboxColor = 'g';
%         player1_symbol = [player1_symbol ,[stats(i).BoundingBox]];
%         if area >90
%             player2_symbol = [player2_symbol ,[stats(i).BoundingBox]];
%             bboxColor = 'r';   
% 
%         end
        % Draw the bounding box as a rectangle
        rectangle('Position', [x, y, width, height], 'EdgeColor', bboxColor, 'LineWidth', 0.5);
        H= text(x+5, y+5,string(bbno));
        set(H,'color','red','fontsize',10)
        bbno = bbno+1;

    %end
end