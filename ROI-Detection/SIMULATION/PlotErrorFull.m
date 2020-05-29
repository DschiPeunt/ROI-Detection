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
legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
title('Type I error')
xlabel('sigma')
ylabel('% of type I errors')
axis([0 max_sigma 0 1])
hold off

% Type II error plot
figure(2)
hold on
plot(sigma_range, err(:, 2) / total(2), 'Linewidth', 2.0)
plot(sigma_range, err_o(:, 2) / total(2), 'Linewidth', 2.0)
plot(sigma_range, err_oc(:, 2) / total(2), 'Linewidth', 2.0)
legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
title('Type II error')
xlabel('sigma')
ylabel('% of type II errors')
axis([0 max_sigma 0 1])
hold off

% ------------------------------------------------------------------------

% Write to .csv file:
% csvwrite('resultsErrorFullTypeI.csv', [sigma_range' (err(:, 1) / total(1))])
% csvwrite('resultsErrorFullTypeI_o.csv', [sigma_range' (err_o(:, 1) / total(1))])
% csvwrite('resultsErrorFullTypeI_oc.csv', [sigma_range' (err_oc(:, 1) / total(1))])
% csvwrite('resultsErrorFullTypeII.csv', [sigma_range' (err(:, 2) / total(2))])
% csvwrite('resultsErrorFullTypeII_o.csv', [sigma_range' (err_o(:, 2) / total(2))])
% csvwrite('resultsErrorFullTypeII_oc.csv', [sigma_range' (err_oc(:, 2) / total(2))])