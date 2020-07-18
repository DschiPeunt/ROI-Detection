function [t, alpha_real] = Threshold(alpha, increment)

% Set initial guess for t:
t = 0;
alpha_real = 1;

while alpha_real >= alpha
    t = t + increment;
    alpha_real = 1 - CDF(t, 1);
end

end

function y = CDF(x, sigma)
% Initialize output array:
y = zeros(size(x));

% Compute pdf values:
for i = 1 : size(x, 1)
    for j = 1 : size(x, 2)
        y(i, j) = (1 / sqrt(3)) * ( 3 / 2 - (3 / 2) * exp(-x(i, j)^2 / (3 * sigma^2)) * besseli(0, x(i, j)^2 / (6 * sigma^2)) ) - sqrt(3)...
            - ((2 - sqrt(3)) / 2) * marcumq(((2 - sqrt(3)) / 2) * (x(i, j) / sigma), ((2 + sqrt(3)) / 2) * (x(i, j) / sigma))...
            + ((2 + sqrt(3)) / 2) * marcumq(((2 + sqrt(3)) / 2) * (x(i, j) / sigma), ((2 - sqrt(3)) / 2) * (x(i, j) / sigma));
    end
end

end