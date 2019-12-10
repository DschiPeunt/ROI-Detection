function [lowerBound, upperBound] = PowerSim(t, nr, max_sigma, c_bg)
%POWERSIM Simulate random variables to obtain bounds for the power
% Input:
% ------
% t: threshold for a given statistical significance alpha
% max_sigma: maximal standard deviation for which to simulate the RV
% nr: number of simulations to perform
% c_bg: background value

% Simulate random variable:
RV = RVSim(nr, max_sigma, c_bg);

% Initialize output vectors:
lowerBound = zeros(1, max_sigma);
upperBound = zeros(1, max_sigma);

% Estimate lower and upper bound for the probability of a type II error:
for sigma = 1: max_sigma
    lowerBound(1, sigma) = sum(RV.('d2c2c')(:, sigma) <= sigma * t) / nr;
    upperBound(1, sigma) = min(2 * sum(RV.('dc0')(:, sigma) <= sigma * t) / nr, 1);
end

end

function RV = RVSim(nr, max_sigma, c_bg)

% Initialize structure to save results:
RV = struct;

% Initialize matrices to store simulation results:
RV.('dc0') = zeros(nr, max_sigma);
RV.('d2c2c') = zeros(nr, max_sigma);

% Generate realizations of a standard normal distribution:
eps1 = randn(nr, 1);
eps2 = randn(nr, 1);
eps = randn(nr, 1);

for sigma = 1 : max_sigma
    % Calculate random variables:
    RV.('dc0')(:, sigma) = sqrt((c_bg + sigma * eps1 - sigma * eps).^2 + (0 + sigma * eps2 - sigma * eps).^2);
    RV.('d2c2c')(:, sigma) = sqrt((2 * c_bg + sigma * eps1 - sigma * eps).^2 + (2 * c_bg + sigma * eps2 - sigma * eps).^2);
end

end

function [] = histSim(RV, d1, d2, sigma)

% Display histogram:
histogram(RV.strcat('d', d1, d2).strcat('sigma', num2str(sigma)))

end

function [] = plotBounds(max_sigma, lowerBound, upperBound)

figure(1)
hold on
plot(1 : max_sigma, 1 - lowerBound, 'Linewidth', 2.0)
plot(1 : max_sigma, 1 - upperBound, 'Linewidth', 2.0)
hold off
legend('Lower bound', 'Upper bound', 'Location', 'southeast')
xlabel('sigma')
ylabel('power')

end