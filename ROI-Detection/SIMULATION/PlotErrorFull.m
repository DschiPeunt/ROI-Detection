% Load results:
% load('resultsErrorFull');

% ------------------------------------------------------------------------

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% ------------------------------------------------------------------------

% Type I error plot
figure(1)
hold on
plot(sigma_range, err(:, 1) / total(1), 'Linewidth', 2.0)
plot(sigma_range, err_o(:, 1) / total(1), 'Linewidth', 2.0)
plot(sigma_range, err_oc(:, 1) / total(1), 'Linewidth', 2.0)
hold off
legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
title('Type I error')

% Type II error plot
figure(2)
hold on
plot(sigma_range, err(:, 2) / total(2), 'Linewidth', 2.0)
plot(sigma_range, err_o(:, 2) / total(2), 'Linewidth', 2.0)
plot(sigma_range, err_oc(:, 2) / total(2), 'Linewidth', 2.0)
hold off
legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
title('Type II error')