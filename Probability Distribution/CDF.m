function y = CDF(x, sigma)
%PDF Summary of this function goes here
%   Detailed explanation goes here

% Initialize output array:
y = zeros(size(x));

% Compute pdf values:
for i = 1 : size(x, 1)
    for j = 1 : size(x, 2)
        y(i, j) = (1 / sqrt(3)) * ( 3 / 2 - (3 / 2) * exp(-x(i, j)^2 / (3 * sigma^2)) * besseli(0, x(i, j)^2 / (6 * sigma^2)) ) - sqrt(3)...
            - ((2 - sqrt(3)) / 2) * marcumq(((2 - sqrt(3)) / 2) * sqrt(x(i, j) / sigma), ((2 + sqrt(3)) / 2) * sqrt(x(i, j) / sigma))...
            + ((2 + sqrt(3)) / 2) * marcumq(((2 + sqrt(3)) / 2) * sqrt(x(i, j) / sigma), ((2 - sqrt(3)) / 2) * sqrt(x(i, j) / sigma));
    end
end

end