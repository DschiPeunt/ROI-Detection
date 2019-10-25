% Specify dimensions, range of standard deviations and results to be loaded:
dims = '8x16';
sigma_range = 1:150;
res1 = 'o';
res2 = 'oc';

% ------------------------------------------------------------------------

% Load results to display and compare:
R1 = load(strcat('resultsStatSignificance', dims, '_', res1));
R2 = load(strcat('resultsStatSignificance', dims, '_', res2));

% Rename loaded variables:
err_Bon_res1 = R1.(strcat('err_Bon_', res1));
err_Bon_res2 = R2.(strcat('err_Bon_', res2));
err_FDR_res1 = R1.(strcat('err_FDR_', res1));
err_FDR_res2 = R2.(strcat('err_FDR_', res2));
err_Hoc_res1 = R1.(strcat('err_Hoc_', res1));
err_Hoc_res2 = R2.(strcat('err_Hoc_', res2));
t_res1 = R1.(strcat('t_', res1));
t_res2 = R2.(strcat('t_', res2));

% Delete loaded structures:
clear R1 R2

% ------------------------------------------------------------------------

% Type I error plot
figure(1)
hold on
plot(sigma_range, err_Bon_res1(:, 1) / t_res1(2), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_res2(:, 1) / t_res2(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res1(:, 1) / t_res1(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res2(:, 1) / t_res2(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res1(:, 1) / t_res1(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res2(:, 1) / t_res2(2), 'Linewidth', 2.0)
hold off
legend(strcat('Bonferroni_{', res1, '}'), strcat('Bonferroni_{', res2, '}'), strcat('FDR_{', res1, '}'), strcat('FDR_{', res2, '}'), strcat('Hochberg_{', res1, '}'), strcat('Hochberg_{', res2, '}'), 'Location', 'southeast')
title('Type I error')

% Type II error plot
figure(2)
hold on
plot(sigma_range, err_Bon_res1(:, 2) / t_res1(1), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_res2(:, 2) / t_res2(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res1(:, 2) / t_res1(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res2(:, 2) / t_res2(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res1(:, 2) / t_res1(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res2(:, 2) / t_res2(1), 'Linewidth', 2.0)
hold off
legend(strcat('Bonferroni_{', res1, '}'), strcat('Bonferroni_{', res2, '}'), strcat('FDR_{', res1, '}'), strcat('FDR_{', res2, '}'), strcat('Hochberg_{', res1, '}'), strcat('Hochberg_{', res2, '}'), 'Location', 'southeast')
title('Type II error')