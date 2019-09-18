% Top plot
figure(1)
plot(sigma_range, err_Bon(:, 1), sigma_range, err_Bon_dA(:, 1), sigma_range, err_FDR(:, 1), sigma_range, err_FDR_dA(:, 1), sigma_range, err_Hoc(:, 1), sigma_range, err_Hoc_dA(:, 1), 'Linewidth', 2.0)
legend('err_Bon','err_Bon_dA','err_FDR','err_FDR_dA','err_Hoc','err_Hoc_dA','Location','southeast')
title('Type I Error')

% Bottom plot
figure(2)
plot(sigma_range, err_Bon(:, 2), sigma_range, err_Bon_dA(:, 2), sigma_range, err_FDR(:, 2), sigma_range, err_FDR_dA(:, 2), sigma_range, err_Hoc(:, 2), sigma_range, err_Hoc_dA(:, 2), 'Linewidth', 2.0)
legend('err_Bon','err_Bon_dA','err_FDR','err_FDR_dA','err_Hoc','err_Hoc_dA','Location','southeast')
title('Type II Error')