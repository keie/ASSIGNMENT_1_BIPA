function [P,M] = fourier_parts(F)
    % center movement
    F_shifted = fftshift(F);
    % F Matrix base
    P = angle(F_shifted);
    % magnitude of F
    M = abs(F_shifted);
end