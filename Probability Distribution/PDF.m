function y = PDF(x, sigma)
%PDF Summary of this function goes here
%   Detailed explanation goes here

% Initialize output array:
y = zeros(size(x));

% Compute pdf values:
for i = 1 : size(x, 1)
    for j = 1 : size(x, 2)
        y(i, j) = x(i, j) * exp( x(i, j)^2 * ( 1 / (4 + 2 / sigma^2) - 1 / 2 ) ) * besseli(0, x(i, j)^2 / (4 + 2 / sigma^2)) / sqrt(2 * sigma^2 + 1);
    end
end

end