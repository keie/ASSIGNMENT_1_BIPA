function [count, coords] = countConsecutive(x, y, dx, dy, player_x, player_y, max_x, max_y)
    count = 0;
    coords = [];
    while true
        x = x + dx;
        y = y + dy;
        if x < 1 || x > max_x || y < 1 || y > max_y || ~ismember([x, y], [player_x', player_y'], 'rows')
            break;
        end
        coords = [coords; x, y];
        count = count + 1;
    end
end
