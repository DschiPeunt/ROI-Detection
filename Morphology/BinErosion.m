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