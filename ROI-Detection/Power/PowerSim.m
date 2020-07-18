function [lowerBound, upperBound] = PowerSim(t_alpha, nr_noise, max_sigma, c_bg)

% Simulate random variable:
RV = RVSim(nr_noise, max_sigma, c_bg);

% Initialize output vectors:
lowerBound = zeros(1, max_sigma);
upperBound = zeros(1, max_sigma);

% Estimate lower and upper bound for the probability of a type II error:
for sigma = 1: max_sigma
    lowerBound(1, sigma) = sum(RV.('D2c2c')(:, sigma) <= sigma * t_alpha) / nr_noise;
    upperBound(1, sigma) = min(2 * sum(RV.('Dcc')(:, sigma) <= sigma * t_alpha) / nr_noise, 1);
end

end

function RV = RVSim(nr_noise, max_sigma, c_bg)

% Initialize structure to save results:
RV = struct;

% Initialize matrices to store simulation results:
RV.('dcc') = zeros(nr_noise, max_sigma);
RV.('d2c2c') = zeros(nr_noise, max_sigma);

% Generate realizations of a standard normal distribution:
eps1 = randn(nr_noise, 1);
eps2 = randn(nr_noise, 1);
eps = randn(nr_noise, 1);

for sigma = 1 : max_sigma
    % Calculate random variables:
    RV.('Dcc')(:, sigma) = sqrt((c_bg + sigma * eps1 - sigma * eps).^2 + (c_bg + sigma * eps2 - sigma * eps).^2);
    RV.('D2c2c')(:, sigma) = sqrt((2 * c_bg + sigma * eps1 - sigma * eps).^2 + (2 * c_bg + sigma * eps2 - sigma * eps).^2);
end

end