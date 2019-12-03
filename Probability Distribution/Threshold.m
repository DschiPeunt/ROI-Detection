function [t, alpha_real] = Threshold(alpha, increment)
%THRESHOLD Calculate threshold based on target statistical significance

t = 0;

while CDF(t, 1) < 1 - alpha
    t = t + increment;
end

alpha_real = CDF(t, 1);

end

function y = CDF(x, sigma)
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