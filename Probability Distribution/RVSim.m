function RV = RVSim(c, nr, sigmas)

% Initialize structure to save results:
RV = struct;

% Generate realizations of a standard normal distribution:
eps1 = randn(1, nr);
eps2 = randn(1, nr);
eps = randn(1, nr);

for sigma = sigmas
    % Calculate random variables:
    RV.('d00').(strcat('sigma', num2str(sigma))) = sqrt((0 + sigma * eps1 - sigma * eps).^2 + (0 + sigma * eps2 - sigma * eps).^2);
    RV.('dc0').(strcat('sigma', num2str(sigma))) = sqrt((c + sigma * eps1 - sigma * eps).^2 + (0 + sigma * eps2 - sigma * eps).^2);
    RV.('d2cc').(strcat('sigma', num2str(sigma))) = sqrt((2 * c + sigma * eps1 - sigma * eps).^2 + (c + sigma * eps2 - sigma * eps).^2);
    RV.('d2c2c').(strcat('sigma', num2str(sigma))) = sqrt((2 * c + sigma * eps1 - sigma * eps).^2 + (2 * c + sigma * eps2 - sigma * eps).^2);
end

end

function [] = histSim(RV, d1, d2, sigma)

% Display histogram:
histogram(RV.strcat('d', d1, d2).strcat('sigma', num2str(sigma)))

end

function t = ThresholdSim(nr, alpha)



end