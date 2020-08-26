function [V, tlc, brc] = ROI_Generator(m, n, min_size)
% m: height/vertical size of the output matrix
% n: width/horizontal size of the output matrix
% min_size: minimal size of the ROI (optional)

% Check whether a minimal size was given:
if (~exist('min_size', 'var'))
    min_size = 0;
end

% Set the background grayvalue:
c_bg = 127.5;

% Initialize the picture with constant background:
V = ones(m, n) * c_bg;

% Generate random bounds for the ROI:
tlc(1) = randi(m - min_size);
tlc(2) = randi(n - min_size);
brc(1) = randi([tlc(1) + min_size m]);
brc(2) = randi([tlc(2) + min_size n]);

% Generate ROI pattern:
for i = tlc(1):brc(1)
    for j = tlc(2):brc(2)
        if mod(i+j, 2) == 0
            V(i, j) = 0;
        elseif mod(i+j, 2) == 1
            V(i, j) = 2 * c_bg;
        end
    end
end

end