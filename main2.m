clc
close all

filename = "input/img19.png";
img1 = imread(filename); % Read the original image

%% Convert to grayscale
img = rgb2gray(imread(filename));

%% Binarization
BW = imbinarize(img, graythresh(img));
BW = ~BW;
image_processed = BW;

%% Connected Components
CC = bwconncomp(image_processed);

%% Region properties
stats = regionprops(CC);

player1_symbol = {};
player2_symbol = {};
player1_coords = [];
player2_coords = [];

% Create an output image that will contain all the rectangles and numbers
outputImage = img1;

for i = 1:numel(stats)
    % Extract bounding box coordinates
    area = stats(i).Area;
    x = stats(i).BoundingBox(1);
    y = stats(i).BoundingBox(2);
    width = stats(i).BoundingBox(3);
    height = stats(i).BoundingBox(4);
    
    m_X = stats(i).Centroid(1);
    m_y = stats(i).Centroid(2);
    
    test_mat = image_processed(round(m_y)-3:round(m_y)+3, round(m_X)-3:round(m_X)+3);
    
    % Determine player by checking the matrix
    if any(test_mat == 0) 
        bboxColor = 'green';
        player1_symbol = [player1_symbol, [stats(i).BoundingBox]];
        player1_coords = [player1_coords; m_X, m_y];
    else  
        bboxColor = 'red';
        player2_symbol = [player2_symbol, [stats(i).BoundingBox]];
        player2_coords = [player2_coords; m_X, m_y];
    end    

    % Insert bounding box into the output image
    outputImage = insertShape(outputImage, 'Rectangle', [x, y, width, height], 'Color', bboxColor, 'LineWidth', 1);
end

% Display the original and processed images side by side
figure;

subplot(1, 2, 1); 
imshow(img1); 
title('Original Image');

subplot(1, 2, 2); 
imshow(outputImage); 
title('Processed Image');

% Adjust figure size
fig = figure('Position', [100, 100, 600, 600]);

hold on;

% Use scatter plot for player points
scatter(player1_coords(:,1), player1_coords(:,2), 300, 'ro', 'filled', 'MarkerFaceAlpha', 0.7); 
scatter(player2_coords(:,1), player2_coords(:,2), 300, 'bo', 'filled', 'MarkerFaceAlpha', 0.7);

grid on;
axis equal;
xlabel('X');
ylabel('Y');
set(gca,'YDir','reverse'); % Invert the Y-axis
legend('Player 1', 'Player 2');
title('Game Representation');
hold off;

% Find the length of the longest line for each player
[lengthP1, ~, ~] = findLongestLine(player1_coords);
[lengthP2, ~, ~] = findLongestLine(player2_coords);

% Announce the winner and the length of their lines
if lengthP1 > lengthP2
    disp('Player 1 is the winner with a line of ' + string(lengthP1) + ' consecutive points.');
elseif lengthP2 > lengthP1
    disp('Player 2 is the winner with a line of ' + string(lengthP2) + ' consecutive points.');
else
    disp('It is a tie!');
end

disp('Player 1 has ' + string(lengthP1) + ' consecutive points.');
disp('Player 2 has ' + string(lengthP2) + ' consecutive points.');
