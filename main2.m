clc
close all
filename ="input/img01.png";
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
figure(1)
imshow(BW);

%%
CC = bwconncomp(BW);
disp(CC)
%%
stats = regionprops(CC);
disp(stats);
bw2 = BW;
% Display the original image
subplot(1,2,1);
imshow(BW);
title('Binary Image')

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





% Crea una figura para el gráfico de juego
subplot(1,2,2); % Selecciona el segundo sub-gráfico


% Crea una figura para el gráfico de juego
subplot(1,2,2); % Selecciona el segundo sub-gráfico
axis tight; % Ajusta el eje para que se adapte a los datos
grid on;
hold on;
xlim([0 size(img1, 2)]); % Ajusta el límite x según el ancho de la imagen
ylim([0 size(img1, 1)]); % Ajusta el límite y según el alto de la imagen
set(gca, 'YDir','reverse'); % Invierte el eje Y

% ... (resto del código)




% Define dos listas vacías para las coordenadas X e Y de los puntos
player1_x = [];
player1_y = [];
player2_x = [];
player2_y = [];

% Itera sobre las estadísticas de las regiones
for i = 1:numel(stats)
    x = stats(i).BoundingBox(1) + stats(i).BoundingBox(3)/2; % Centroid x
    y = stats(i).BoundingBox(2) + stats(i).BoundingBox(4)/2; % Centroid y
    
    test_mat = BW(round(y)-3:round(y)+3,round(x)-3:round(x)+3);
    
    if any(test_mat == 0) 
        player1_x = [player1_x, x];
        player1_y = [player1_y, y];
    else  
        player2_x = [player2_x, x];
        player2_y = [player2_y, y];
    end
end

% Grafica los puntos en el gráfico de juego
scatter(player1_x, player1_y, 300, 'g', 'filled'); % Jugador 1 en rojo
scatter(player2_x, player2_y, 300, 'r', 'filled'); % Jugador 2 en azul
legend('Player 1', 'Player 2');


hold off;



