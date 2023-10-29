% Función para detectar intersecciones
function [x_inters, y_inters] = find_intersections(x1, y1, x2, y2)
    [x_inters, y_inters] = polyxpoly(x1, y1, x2, y2);
end
