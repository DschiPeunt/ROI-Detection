% Load results:
load('ROI_TestCasesResults.mat');

% ------------------------------------------------------------------------

% Initialize counters for the errors and total number of pixels:
err_Bon = zeros(max_sigma, 2);
err_FDR = zeros(max_sigma, 2);
err_Hoc = zeros(max_sigma, 2);
err_Bon_o = zeros(max_sigma, 2);
err_FDR_o = zeros(max_sigma, 2);
err_Hoc_o = zeros(max_sigma, 2);
err_Bon_oc = zeros(max_sigma, 2);
err_FDR_oc = zeros(max_sigma, 2);
err_Hoc_oc = zeros(max_sigma, 2);
t = zeros(1, 2);

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Add results to the counters results:
        t = t + cases.(dim_name).(strcat('t', num2str(j))) / 100;
        err_Bon = err_Bon + cases.(dim_name).(strcat('err_Bon', num2str(j)));
        err_FDR = err_FDR + cases.(dim_name).(strcat('err_FDR', num2str(j)));
        err_Hoc = err_Hoc + cases.(dim_name).(strcat('err_Hoc', num2str(j)));
        err_Bon_o = err_Bon_o + cases.(dim_name).(strcat('err_Bon_o', num2str(j)));
        err_FDR_o = err_FDR_o + cases.(dim_name).(strcat('err_FDR_o', num2str(j)));
        err_Hoc_o = err_Hoc_o + cases.(dim_name).(strcat('err_Hoc_o', num2str(j)));
        err_Bon_oc = err_Bon_oc + cases.(dim_name).(strcat('err_Bon_oc', num2str(j)));
        err_FDR_oc = err_FDR_oc + cases.(dim_name).(strcat('err_FDR_oc', num2str(j)));
        err_Hoc_oc = err_Hoc_oc + cases.(dim_name).(strcat('err_Hoc_oc', num2str(j)));
        
    end
end

% ------------------------------------------------------------------------

sigma_range = 1 : max_sigma;

% Type I error plot
figure(1)
hold on
plot(sigma_range, err_Bon(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_o(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_o(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_o(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_oc(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_oc(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_oc(:, 1) / t(2), 'Linewidth', 2.0)
hold off
legend('Bonferroni', 'FDR', 'Hochberg', 'Bonferroni_{o}', 'FDR_{o}', 'Hochberg_{o}', 'Bonferroni_{oc}', 'FDR_{oc}', 'Hochberg_{oc}', 'Location', 'southeast')
title('Type I error')

% Type II error plot
figure(2)
hold on
plot(sigma_range, err_Bon(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_o(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_o(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_o(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_oc(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_oc(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_oc(:, 2) / t(1), 'Linewidth', 2.0)
hold off
legend('Bonferroni', 'FDR', 'Hochberg', 'Bonferroni_{o}', 'FDR_{o}', 'Hochberg_{o}', 'Bonferroni_{oc}', 'FDR_{oc}', 'Hochberg_{oc}', 'Location', 'southeast')
title('Type II error')