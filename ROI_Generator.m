function ROI_Picture = ROI_Generator(M, N, c_bg)
%ROI_GENERATOR Generate random rectangle with checkerboard pattern
% INPUT
% -----
% M: height/vertical size of the output matrix
% N: width/horizontal size of the output matrix
% c_bg: greyscale value for the image background (optional)

% Check whether an alternative background greyvalue was given:
if (~exist('c_bg', 'var'))
    c_bg = 127.5;
end

% Initialize the picture with constant background:
ROI_Picture = ones(M, N) * c_bg;

% Generate random bounds for the ROI:
bounds_vert = randi(M, 2, 1);
bounds_hori = randi(N, 2, 1);

% Determine top left corner and bottom right corner of the ROI:
tlc(1) = min(bounds_vert);
tlc(2) = min(bounds_hori);
brc(1) = max(bounds_vert);
brc(2) = max(bounds_hori);

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