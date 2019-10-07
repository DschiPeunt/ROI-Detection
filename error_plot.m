% [err_FDR, err_Bon, err_Hoc, t] = ConfidenceTest(M, N, sigma_range, noise, alpha);

% Type I error plot
figure(1)
hold on
plot(sigma_range, err_Bon_1dd(:, 1) / t_1dd(2), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_2dd(:, 1) / t_dA(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_1dd(:, 1) / t_1dd(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_2dd(:, 1) / t_dA(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_1dd(:, 1) / t_1dd(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_2dd(:, 1) / t_dA(2), 'Linewidth', 2.0)
hold off
legend('Bonferroni', 'Bonferroni_{dA}', 'FDR', 'FDR_{dA}', 'Hochberg', 'Hochberg_{dA}', 'Location', 'southeast')
title('Type I error')

% Type II error plot
figure(2)
hold on
plot(sigma_range, err_Bon_1dd(:, 2) / t_1dd(1), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_2dd(:, 2) / t_dA(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_1dd(:, 2) / t_1dd(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_2dd(:, 2) / t_dA(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_1dd(:, 2) / t_1dd(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_2dd(:, 2) / t_dA(1), 'Linewidth', 2.0)
hold off
legend('Bonferroni', 'Bonferroni_{dA}', 'FDR', 'FDR_{dA}', 'Hochberg', 'Hochberg_{dA}', 'Location', 'southeast')
title('Type II error')