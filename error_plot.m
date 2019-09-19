% [err_FDR, err_Bon, err_Hoc, t] = ConfidenceTest(M, N, sigma_range, noise, alpha);

% Type I error plot
figure(1)
hold on
plot(sigma_range, err_Bon(:, 1) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_dA(:, 1) / t_dA(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR(:, 1) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_dA(:, 1) / t_dA(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc(:, 1) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_dA(:, 1) / t_dA(1), 'Linewidth', 2.0)
hold off
legend('Bonferroni', 'Bonferroni_{dA}', 'FDR', 'FDR_{dA}', 'Hochberg', 'Hochberg_{dA}', 'Location', 'southeast')
title('Type I error')

% Type II error plot
figure(2)
hold on
plot(sigma_range, err_Bon(:, 2) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_dA(:, 2) / t_dA(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR(:, 2) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_dA(:, 2) / t_dA(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc(:, 2) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_dA(:, 2) / t_dA(2), 'Linewidth', 2.0)
hold off
legend('Bonferroni', 'Bonferroni_{dA}', 'FDR', 'FDR_{dA}', 'Hochberg', 'Hochberg_{dA}', 'Location', 'southeast')
title('Type II error')