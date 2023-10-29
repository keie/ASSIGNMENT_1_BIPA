function [lineLength,lineStart, lineEnd] = findLongestLine(coords)
    % Ordena los puntos según las coordenadas x e y
    sortedByX = sortrows(coords, 1);
    sortedByY = sortrows(coords, 2);
    
    maxDist = 40; % Distancia máxima entre puntos consecutivos
    longestStreak = 1;
    currentStreak = 1;
    lineStart = [];
    lineEnd = [];
    
    for i = 2:size(sortedByX, 1)
        if abs(sortedByX(i, 1) - sortedByX(i-1, 1)) < maxDist && abs(sortedByX(i, 2) - sortedByX(i-1, 2)) < maxDist
            currentStreak = currentStreak + 1;
            if currentStreak > longestStreak
                longestStreak = currentStreak;
                lineStart = sortedByX(i-currentStreak+1, :);
                lineEnd = sortedByX(i, :);
            end
        else
            currentStreak = 1;
        end
    end
    
    currentStreak = 1;
    for i = 2:size(sortedByY, 1)
        if abs(sortedByY(i, 2) - sortedByY(i-1, 2)) < maxDist && abs(sortedByY(i, 1) - sortedByY(i-1, 1)) < maxDist
            currentStreak = currentStreak + 1;
            if currentStreak > longestStreak
                longestStreak = currentStreak;
                lineStart = sortedByY(i-currentStreak+1, :);
                lineEnd = sortedByY(i, :);
            end
        else
            currentStreak = 1;
        end
    end

    % Dibuja la línea más larga
    line([lineStart(1), lineEnd(1)], [lineStart(2), lineEnd(2)], 'LineWidth', 2, 'Color', 'g');

    % Al final de la función, después de encontrar lineStart y lineEnd:
    if isempty(lineStart) || isempty(lineEnd)
        lineLength = 0;
    else
        lineLength = sqrt((lineStart(1) - lineEnd(1))^2 + (lineStart(2) - lineEnd(2))^2);
    end
    
end