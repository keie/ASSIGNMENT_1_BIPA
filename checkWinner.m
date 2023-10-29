function [winner, winningLine] = checkWinner(player1_coords, player2_coords, threshold)
    players = {'Player 1', 'Player 2'};
    coordsList = {player1_coords, player2_coords};
    winningLine = [];
    winner = 'None';
    
    for p = 1:2
        coords = coordsList{p};
        coords = sortrows(coords, 1); % Ordenar por x

        for i = 1:size(coords, 1)
            % Buscar puntos cercanos
            potentialMatches = coords(sqrt((coords(:,1)-coords(i,1)).^2 + (coords(:,2)-coords(i,2)).^2) < 1, :);

            if size(potentialMatches, 1) >= threshold
                % Comprobar alineación
                diffs = diff(potentialMatches, 1, 1);
                ratios = diffs(:,2) ./ diffs(:,1);

                if length(unique(ratios)) == 1
                    winner = players{p};
                    winningLine = [potentialMatches(1,:); potentialMatches(end,:)];
                    return;
                end
            end
        end
    end
end
