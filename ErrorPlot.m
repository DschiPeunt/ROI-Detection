% Specify dimensions, number of pictures and maximum standard deviation:
dims = [128, 256, 512];
nr_pictures = 5;
max_sigma = 150;

% Load results:
load('ROI_TestCases.mat');

% Specify results to be compared and displayed:
res1 = 'o';
res2 = 'oc';

% ------------------------------------------------------------------------
max_sigma = 150;
sigma_range = 1:max_sigma;
% Initialize counters for the errors and total number of pixels:
err_Bon_res1 = zeros(max_sigma, 2);
err_FDR_res1 = zeros(max_sigma, 2);
err_Hoc_res1 = zeros(max_sigma, 2);
err_Bon_res2 = zeros(max_sigma, 2);
err_FDR_res2 = zeros(max_sigma, 2);
err_Hoc_res2 = zeros(max_sigma, 2);
t = zeros(1, 2);

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Add results to the counters results:
        t = t + cases.(dim_name).(strcat('t', num2str(j))) / 100;
        err_FDR_res1 = err_FDR_res1 + cases.(dim_name).(strcat('err_FDR', num2str(j)));
        err_Bon_res1 = err_Bon_res1 + cases.(dim_name).(strcat('err_Bon', num2str(j)));
        err_Hoc_res1 = err_Hoc_res1 + cases.(dim_name).(strcat('err_Hoc', num2str(j)));
        err_FDR_res2 = err_FDR_res2 + cases.(dim_name).(strcat('err_FDR_o', num2str(j)));
        err_Bon_res2 = err_Bon_res2 + cases.(dim_name).(strcat('err_Bon_o', num2str(j)));
        err_Hoc_res2 = err_Hoc_res2 + cases.(dim_name).(strcat('err_Hoc_o', num2str(j)));
        
    end
end

% ------------------------------------------------------------------------

% Type I error plot
figure(1)
hold on
plot(sigma_range, err_Bon_res1(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_res2(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res1(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res2(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res1(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res2(:, 1) / t(2), 'Linewidth', 2.0)
hold off
legend(strcat('Bonferroni_{', res1, '}'), strcat('Bonferroni_{', res2, '}'), strcat('FDR_{', res1, '}'), strcat('FDR_{', res2, '}'), strcat('Hochberg_{', res1, '}'), strcat('Hochberg_{', res2, '}'), 'Location', 'southeast')
title('Type I error')

% Type II error plot
figure(2)
hold on
plot(sigma_range, err_Bon_res1(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Bon_res2(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res1(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_FDR_res2(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res1(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_Hoc_res2(:, 2) / t(1), 'Linewidth', 2.0)
hold off
legend(strcat('Bonferroni_{', res1, '}'), strcat('Bonferroni_{', res2, '}'), strcat('FDR_{', res1, '}'), strcat('FDR_{', res2, '}'), strcat('Hochberg_{', res1, '}'), strcat('Hochberg_{', res2, '}'), 'Location', 'southeast')
title('Type II error')