function [angle_rot] = rotation(adjusted_img)
    img_gray = rgb2gray(adjusted_img);
    edge_de = edge(img_gray,"canny");
    [H,theta,rho] = hough(edge_de);
    peaks = houghpeaks(H,10);
    lines = houghlines(edge_de,theta,rho,peaks)
    angle_rot = mode([lines.theta]);
end