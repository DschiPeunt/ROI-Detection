% Set parameters:
x = 0:0.1:10;
sigma = 1;

% Initialize output:
y = zeros(size(x));

% Compute cdf values:
for i = 1 : size(x, 1)
    for j = 1 : size(x, 2)
        y(i, j) = (1 / sqrt(3)) * ( 3 / 2 - (3 / 2) * exp(-x(i, j)^2 / (3 * sigma^2)) * besseli(0, x(i, j)^2 / (6 * sigma^2)) ) - sqrt(3)...
            - ((2 - sqrt(3)) / 2) * marcumq(((2 - sqrt(3)) / 2) * sqrt(x(i, j) / sigma), ((2 + sqrt(3)) / 2) * sqrt(x(i, j) / sigma))...
            + ((2 + sqrt(3)) / 2) * marcumq(((2 + sqrt(3)) / 2) * sqrt(x(i, j) / sigma), ((2 - sqrt(3)) / 2) * sqrt(x(i, j) / sigma));
    end
end

% Plot the cdf and the 0.95 and 0.99 quantile:
figure(1)
hold on

% Plot cdf function:
plot(x, y, 'Linewidth', 2.0)

% Mark 0.95 and 0.99 quantile on the curve:
plot(3.2554, 0.95, 'r*', 'Linewidth', 2.0)
plot(4.2791, 0.99, 'r*', 'Linewidth', 2.0)

% Plot vertical lines:
plot([4.2791 4.2791], [0 0.99], 'k--', 'Linewidth', 2.0)
plot([3.2554 3.2554], [0 0.95], 'k--', 'Linewidth', 2.0)

% Plot horizontal lines:
plot([0 3.2554], [0.95 0.95], 'k--', 'Linewidth', 2.0)
plot([0 4.2791], [0.99 0.99], 'k--', 'Linewidth', 2.0)

hold off