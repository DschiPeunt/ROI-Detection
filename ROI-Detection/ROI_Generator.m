function [ROI_Picture, tlc, brc] = ROI_Generator(M, N, min_size, c_bg)
%ROI_GENERATOR Generate random rectangle with checkerboard pattern
% INPUT
% -----
% M: height/vertical size of the output matrix
% N: width/horizontal size of the output matrix
% min_size: minimal size of the ROI (optional)
% c_bg: grayscale value for the image background (optional)

% Check whether a minimal size was given:
if (~exist('min_size', 'var'))
    min_size = 0;
end

% Check whether an alternative background grayvalue was given:
if (~exist('c_bg', 'var'))
    c_bg = 127.5;
end

% Initialize the picture with constant background:
ROI_Picture = ones(M, N) * c_bg;

% Generate random bounds for the ROI:
tlc(1) = randi(M - min_size);
tlc(2) = randi(N - min_size);
brc(1) = randi([tlc(1) + min_size M]);
brc(2) = randi([tlc(2) + min_size N]);

% Generate ROI pattern:
for i = tlc(1):brc(1)
    for j = tlc(2):brc(2)
        if mod(i+j, 2) == 0
            ROI_Picture(i, j) = 0;
        elseif mod(i+j, 2) == 1
            ROI_Picture(i, j) = 255;
        end
    end
end

end