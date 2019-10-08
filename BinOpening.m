function A_open = BinOpening(A, B)
%BINOPENING Perform binary opening of A by B

% Check whether B was specified and set it, if it wasn't:
if (~exist('B', 'var'))
    B = ones(3, 3);
end

A_open = BinDilation(BinErosion(A, B), B);

end

function A_ero_B = BinErosion(A, B)
%BINEROSION Perform binary erosion of A by B

A_ero_B = zeros(size(A));

for i = 1 : size(A, 1)
    for j = 1 : size(A, 2)
        dim1 = min(size(B, 1), size(A, 1) - i + 1);
        dim2 = min(size(B, 2), size(A, 2) - j + 1);
        M = 1 - B(1 : dim1, 1 : dim2) .* (1 - A(i : i + dim1 - 1, j : j + dim2 - 1));
        A_ero_B(i, j) = all(all(M));
    end
end

end

function A_dil_B = BinDilation(A, B)
%BINDILATION Perform binary dilation of A by B

A_dil_B = zeros(size(A));

for i = 1 : size(A, 1)
    for j = 1 : size(A, 2)
        dim1 = min(size(B, 1), i);
        dim2 = min(size(B, 2), j);
        M = B(1 : dim1, 1 : dim2) .* flip(A(i - dim1 + 1 : i, j - dim2 + 1 : j), 2);
        A_dil_B(i, j) = any(any(M));
    end
end

end