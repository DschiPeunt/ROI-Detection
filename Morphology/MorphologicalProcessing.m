function f_morph = MorphologicalProcessing(A, B1, B2)
%MORPHOLOGICALPROCESSING Perform morphological operations on ROI
% INPUT
% -----
% f: binary ROI indicator matrix

% Define structuring element B:
% B = ones(3, 3);

f_morph = BinHoM(A, B1, B2);

end

% ------------------------------------------------------------------------
% ------------------ BELOW ARE MORPHOLOGICAL ALGORITHMS ------------------
% ------------------------------------------------------------------------

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

A_open_B = BinDilation(BinErosion(A, B), B);

end

function A_close_B = BinClosing(A, B)
%BINCLOSING Perform binary closing of A by B

A_close_B = BinErosion(BinDilation(A, B), B);

end

function A_ero_B = BinErosion(A, B)
%BINEROSION Perform binary erosion of A by B
% Test case:
% A = [0 1 0 0; 0 1 0 0; 0 1 1 0; 1 0 0 0];
% B = [0 0 1 1 0];
% res = [0 0 0 0; 0 0 0 0; 0 1 0 0; 0 0 0 0];

% Check that the structuring element has odd dimensions:
if any(mod(size(B), 2) == 0)
    error('Structuring element B must have odd dimensions.')
end

% Initialize output matrix:
A_ero_B = zeros(size(A));

for i = 1 : size(A, 1)
    for j = 1 : size(A, 2)
        % Determine bounds for the window of A around (i, j):
        A_top = max(1, i - (size(B, 1) - 1) / 2);
        A_left = max(1, j - (size(B, 2) - 1) / 2);
        A_bottom = min(size(A, 1), i + (size(B, 1) - 1) / 2);
        A_right = min(size(A, 2), j + (size(B, 2) - 1) / 2);
        
        % Determine bounds for values of B:
        B_top = (size(B, 1) + 1) / 2 - min(i - 1, (size(B, 1) - 1) / 2);
        B_left = (size(B, 2) + 1) / 2 - min(j - 1, (size(B, 2) - 1) / 2);
        B_bottom = (size(B, 1) + 1) / 2 + min(size(A, 1) - i, (size(B, 1) - 1) / 2);
        B_right = (size(B, 2) + 1) / 2 + min(size(A, 2) - j, (size(B, 2) - 1) / 2);
        
        % Calculate erosion of A by B:
        W = 1 - B(B_top : B_bottom, B_left : B_right) .* (1 - A(A_top : A_bottom, A_left : A_right));
        A_ero_B(i, j) = all(all(W));
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
if any(mod(size(B), 2) == 0)
    error('Structuring element B must have odd dimensions.')
end

% Initialize output matrix:
A_dil_B = zeros(size(A));

for i = 1 : size(A, 1)
    for j = 1 : size(A, 2)
        % Determine bounds for the window of A around (i, j):
        A_top = max(1, i - (size(B, 1) - 1) / 2);
        A_left = max(1, j - (size(B, 2) - 1) / 2);
        A_bottom = min(size(A, 1), i + (size(B, 1) - 1) / 2);
        A_right = min(size(A, 2), j + (size(B, 2) - 1) / 2);
        
        % Determine bounds for values of B:
        B_top = (size(B, 1) + 1) / 2 - min(size(A, 1) - i, (size(B, 1) - 1) / 2);
        B_left = (size(B, 2) + 1) / 2 - min(size(A, 2) - j, (size(B, 2) - 1) / 2);
        B_bottom = (size(B, 1) + 1) / 2 + min(i - 1, (size(B, 1) - 1) / 2);
        B_right = (size(B, 2) + 1) / 2 + min(j - 1, (size(B, 2) - 1) / 2);
        
        % Calculate dilation of A by B:
        W = B(B_top : B_bottom, B_left : B_right) .* A(A_bottom : -1 : A_top, A_right : -1 : A_left);
        A_dil_B(i, j) = any(any(W));
    end
end

end