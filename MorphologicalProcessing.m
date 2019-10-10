function f_morph = MorphologicalProcessing(A)
%MORPHOLOGICALPROCESSING Perform morphological operations on ROI
% INPUT
% -----
% f: binary ROI indicator matrix

% Define structuring element B:
B = ones(3, 3);

f_morph = BinConvexHull(BinOpening(A, B));

end

% ------------------------------------------------------------------------
% ------------------ BELOW ARE MORPHOLOGICAL ALGORITHMS ------------------
% ------------------------------------------------------------------------

function A_conv = BinConvexHull(A)
%BINCONVEXHULL Calculate binary convex hull of A
% Test case:
% A = [0 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0 0; 0 0 1 1 0 0 0 0 0; 0 1 1 1 0 1 0 0 0; 0 1 1 1 0 1 1 0 0; 0 1 1 1 1 1 1 1 0; 0 0 1 1 1 1 1 0 0; 0 0 0 0 1 1 0 0 0; 0 0 0 0 1 0 0 0 0];
% res = [0 0 0 0 0 0 0 0 0; 0 0 0 1 0 0 0 0 0; 0 0 1 1 1 0 0 0 0; 0 1 1 1 1 1 0 0 0; 1 1 1 1 1 1 1 0 0; 0 1 1 1 1 1 1 1 0; 0 0 1 1 1 1 1 0 0; 0 0 0 1 1 1 0 0 0; 0 0 0 0 1 0 0 0 0];

% Initialize structuring elements:
B1 = [1 0 0; 1 0 0; 1 0 0];
B2 = [1 1 1; 0 0 0; 0 0 0];
B3 = [0 0 1; 0 0 1; 0 0 1];
B4 = [0 0 0; 0 0 0; 1 1 1];
B = cat(3, B1, B2, B3, B4);
C = [0 0 0; 0 1 0; 0 0 0];

% Initialize initial matrices:
X = repmat(A, [1 1 4]);

% Initialize output matrix:
A_conv = zeros(size(A));

for i = 1 : 4
    % Initialize matrix to store a matrix while performing the next iteration:
    X_old = zeros(size(A));
    
    while any(any(X(:, :, i) ~= X_old))
        % Store result:
        X_old = X(:, :, i);
        
        % Perform iteration step:
        X(:, :, i) = 1 - (1 - BinHoM(X(:, :, i), B(:, :, i), C)) .* (1 - X(:, :, i));
    end
    
    % Add results:
    A_conv = 1 - (1 - A_conv) .* (1 - X(:, :, i));
end

end

function A_HoM_B1B2 = BinHoM(A, B1, B2)
%BINHOM Perform binary hit-or-miss transform of A by (B1, B2)
% Test case:
% A = [0 0 0 0 0 0 0 0; 0 0 1 0 1 0 0 0; 0 1 0 1 1 1 1 0; 0 0 1 0 1 0 0 0; 0 0 0 0 1 1 1 0; 0 1 1 0 1 0 1 0; 0 1 1 0 0 0 1 0; 0 0 0 0 0 0 0 0];
% B1 = [0 1 0; 0 1 1; 0 1 0];
% B2 = [1 0 1; 1 0 0; 1 0 1];
% res = [0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 1 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0; 0 0 0 0 0 0 0 0];

A_HoM_B1B2 = BinErosion(A, B1) .* BinErosion(1 - A, B2);

end

function A_open_B = BinOpening(A, B)
%BINOPENING Perform binary opening of A by B

% Check whether B was specified and set it, if it wasn't:
if (~exist('B', 'var'))
    B = ones(3, 3);
end

A_open_B = BinDilation(BinErosion(A, B), B);

end

function A_close_B = BinClosing(A, B)
%BINCLOSING Perform binary closing of A by B

% Check whether B was specified and set it, if it wasn't:
if (~exist('B', 'var'))
    B = ones(3, 3);
end

A_close_B = BinErosion(BinDilation(A, B), B);

end

function A_ero_B = BinErosion(A, B)
%BINEROSION Perform binary erosion of A by B
% Test case:
% A = [0 1 0 0; 0 1 0 0; 0 1 1 0; 1 0 0 0];
% B = [0 0 1 1 0];
% res = [0 0 0 0; 0 0 0 0; 0 1 0 0; 0 0 0 0];

% Check that the structuring element has odd dimensions:
if any(any(mod(size(B), 2) == 0))
    error('Structuring element B must have odd dimensions.')
end

% Initialize output matrix:
A_ero_B = zeros(size(A));

% Pad array with zeros:
pad_vert = (size(B, 1) - 1) / 2;
pad_hori = (size(B, 2) - 1) / 2;
A = padarray(A, [pad_vert pad_hori], 0);

for i = 1 + pad_vert : size(A, 1) - pad_vert
    for j = 1 + pad_hori : size(A, 2) - pad_hori
        % Calculate erosion of A by B:
        W = 1 - B .* (1 - A(i - pad_vert : i + pad_vert, j - pad_hori : j + pad_hori));
        A_ero_B(i - pad_vert, j - pad_hori) = all(all(W));
    end
end

end

function A_dil_B = BinDilation(A, B)
%BINDILATION Perform binary dilation of A by B
% Test case:
% A = [0 1 0 0; 0 1 0 0; 0 1 0 0; 0 1 0 0];
% B = [0 0 1 0 1];
% res = [0 1 0 1; 0 1 0 1; 0 1 0 1; 0 1 0 1];

% Check that the structuring element has odd dimensions:
if any(any(mod(size(B), 2) == 0))
    error('Structuring element B must have odd dimensions.')
end

% Initialize output matrix:
A_dil_B = zeros(size(A));

% Pad array with zeros:
pad_vert = (size(B, 1) - 1) / 2;
pad_hori = (size(B, 2) - 1) / 2;
A = padarray(A, [pad_vert pad_hori], 0);

for i = 1 + pad_vert : size(A, 1) - pad_vert
    for j = 1 + pad_hori : size(A, 2) - pad_hori
        % Calculate dilation of A by B:
        W = B .* A(i + pad_vert : -1 : i - pad_vert, j + pad_hori : -1 : j - pad_hori);
        A_dil_B(i - pad_vert, j - pad_hori) = any(any(W));
    end
end

end