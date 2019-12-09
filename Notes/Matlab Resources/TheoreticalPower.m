% Set values:
alpha = 0.05;
c_bg = 127.5;
sigma_range = 1:150;

% Initialize vectors for lower and upper bounds:
lower_bound = zeros(1, size(sigma_range, 2));
upper_bound = zeros(1, size(sigma_range, 2));

% Calculate second argument for the Marcum Q-function:
b = sqrt(- 2 * log(alpha));

for sigma = sigma_range
    % Calculate lower and upper bound:
    lower_bound(1, sigma) = marcumq((2 * c_bg) / sigma, b);
    upper_bound(1, sigma) = 1 - min(1, 2 * (1 - marcumq(c_bg / (sqrt(2) * sigma), b)));
end

% Plot lower and upper bounds:
figure(1)
hold on
plot(sigma_range, lower_bound, 'Linewidth', 2.0)
plot(sigma_range, upper_bound, 'Linewidth', 2.0)
hold off
legend('Upper bound', 'Lower bound', 'Location', 'southeast')
xlabel('sigma')
ylabel('power')