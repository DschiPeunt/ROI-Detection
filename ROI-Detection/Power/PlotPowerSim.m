% Load results:
% load('resultsPowerSim');

% ------------------------------------------------------------------------

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% ------------------------------------------------------------------------

% Estimated power bounds plot
figure(1)
hold on
plot(sigma_range, lowerBound, 'Linewidth', 2.0)
plot(sigma_range, upperBound, 'Linewidth', 2.0)
hold off
legend('Lower bound', 'Upper bound', 'Location', 'southeast')
title('Power bounds')
xlabel('sigma')
ylabel('power')

% ------------------------------------------------------------------------

% Write to .csv file:
% csvwrite('resultsPowerSimLowerBound.csv', [sigma_range' lowerBound'])
% csvwrite('resultsPowerSimUpperBound.csv', [sigma_range' upperBound'])