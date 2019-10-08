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