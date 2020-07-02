% Load results:
load('resultsErrorTestCases_relaxed.mat');

% ------------------------------------------------------------------------

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% ------------------------------------------------------------------------

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Initialize counters for the errors and total number of pixels:
    err = zeros(max_sigma, 2);
    err_o = zeros(max_sigma, 2);
    err_oc = zeros(max_sigma, 2);
    total = zeros(1, 2);
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Add results to the counters results:
        total = total + cases.(dim_name).(strcat('total', num2str(j)));
        err = err + cases.(dim_name).(strcat('err', num2str(j)));
        err_o = err_o + cases.(dim_name).(strcat('err_o', num2str(j)));
        err_oc = err_oc + cases.(dim_name).(strcat('err_oc', num2str(j)));
        
    end
    
    % ------------------------------------------------------------------------
    
    % Type I error plot
    figure
    hold on
    plot(sigma_range, err(:, 1) / total(1), 'Linewidth', 2.0)
    plot(sigma_range, err_o(:, 1) / total(1), 'Linewidth', 2.0)
    plot(sigma_range, err_oc(:, 1) / total(1), 'Linewidth', 2.0)
    legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
    title(strcat('Type I error (', num2str(dims(i)), 'x', num2str(dims(i)), ')'))
    xlabel('sigma')
    ylabel('% of type I errors')
    axis([0 max_sigma 0 1])
    hold off
    
    % Type II error plot
    figure
    hold on
    plot(sigma_range, err(:, 2) / total(2), 'Linewidth', 2.0)
    plot(sigma_range, err_o(:, 2) / total(2), 'Linewidth', 2.0)
    plot(sigma_range, err_oc(:, 2) / total(2), 'Linewidth', 2.0)
    legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
    title(strcat('Type II error (', num2str(dims(i)), 'x', num2str(dims(i)), ')'))
    xlabel('sigma')
    ylabel('% of type II errors')
    axis([0 max_sigma 0 1])
    hold off
    
    % ------------------------------------------------------------------------
    
    % Write to .csv file:
    csvwrite(strcat('resultsErrorTestCasesTypeI_', num2str(dims(i)), 'x', num2str(dims(i)), '_relaxed.csv'), [sigma_range' (err(:, 1) / total(1))])
    csvwrite(strcat('resultsErrorTestCasesTypeI_', num2str(dims(i)), 'x', num2str(dims(i)), '_o_relaxed.csv'), [sigma_range' (err_o(:, 1) / total(1))])
    csvwrite(strcat('resultsErrorTestCasesTypeI_', num2str(dims(i)), 'x', num2str(dims(i)), '_oc_relaxed.csv'), [sigma_range' (err_oc(:, 1) / total(1))])
    csvwrite(strcat('resultsErrorTestCasesTypeII_', num2str(dims(i)), 'x', num2str(dims(i)), '_relaxed.csv'), [sigma_range' (err(:, 2) / total(2))])
    csvwrite(strcat('resultsErrorTestCasesTypeII_', num2str(dims(i)), 'x', num2str(dims(i)), '_o_relaxed.csv'), [sigma_range' (err_o(:, 2) / total(2))])
    csvwrite(strcat('resultsErrorTestCasesTypeII_', num2str(dims(i)), 'x', num2str(dims(i)), '_oc_relaxed.csv'), [sigma_range' (err_oc(:, 2) / total(2))])
    
end