% Load results:
load('simulation_rel.mat');

% ------------------------------------------------------------------------

% Initialize counters for the errors and total number of pixels:
err = zeros(max_sigma, 2);
err_o = zeros(max_sigma, 2);
err_oc = zeros(max_sigma, 2);
t = zeros(1, 2);

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Add results to the counters results:
        t = t + cases.(dim_name).(strcat('t', num2str(j)));
        err = err + cases.(dim_name).(strcat('err', num2str(j)));
        err_o = err_o + cases.(dim_name).(strcat('err_o', num2str(j)));
        err_oc = err_oc + cases.(dim_name).(strcat('err_oc', num2str(j)));
        
    end
end

% ------------------------------------------------------------------------

sigma_range = 1 : max_sigma;

% Type I error plot
figure(1)
hold on
plot(sigma_range, err(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_o(:, 1) / t(2), 'Linewidth', 2.0)
plot(sigma_range, err_oc(:, 1) / t(2), 'Linewidth', 2.0)
legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
title('Type I error')
xlabel('sigma')
ylabel('% of type I errors')
axis([0 max_sigma 0 1])
hold off

% Type II error plot
figure(2)
hold on
plot(sigma_range, err(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_o(:, 2) / t(1), 'Linewidth', 2.0)
plot(sigma_range, err_oc(:, 2) / t(1), 'Linewidth', 2.0)
legend('binarization', 'opening', 'opening & closing', 'Location', 'southeast')
title('Type II error')
xlabel('sigma')
ylabel('% of type II errors')
axis([0 max_sigma 0 1])
hold off