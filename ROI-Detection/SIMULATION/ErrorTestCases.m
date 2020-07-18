% Set mode for normal or relaxed statistical significance approach:
mode = 'relaxed';

% Set parent folder to store the .csv files:
folder = 'C:\Users\Domin\Dropbox\Masterarbeit\ROI-Detection\SIMULATION\CSV_TestCases\';

% Reset RNG seed:
rng('default')

% Load input:
load('inputErrorTestCases.mat');

% ------------------------------------------------------------------------

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% Loop over statistical significances:
for alpha = alphas
    
    % Loop over side lenghts of the structuring element:
    for phi = phis
        
        % Determine if normal or relaxed statistical significance is used:
        switch mode
            case 'normal'
                alpha_use = alpha;
            case 'relaxed'
                alpha_use = power(alpha / phi^3, 2 / (phi + 1));
        end
        
        % Calculate total number of pixels and errors:
        cases = CalculateErrorTestCases(dims, nr_pictures, cases, alpha_use, phi, max_nr_noise, max_sigma);
        
        % Loop over dimensions:
        for i = 1 : size(dims, 2)
            
            % Generate name of the substructure of the dimension:
            dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
            
            % Extract total number of pixels and errors:
            total = cases.(dim_name).('total');
            err = cases.(dim_name).('err');
            err_o = cases.(dim_name).('err_o');
            err_oc = cases.(dim_name).('err_oc');
            
            % ------------------------------------------------------------------------
            
            % Write to .csv file:
            csvwrite(strcat(folder, mode, '\alpha', num2str(alpha), '\phi', num2str(phi), '\dim', num2str(dims(i)), '\resultsErrorTestCasesTypeI.csv'), [sigma_range' (err(:, 1) / total(1))])
            csvwrite(strcat(folder, mode, '\alpha', num2str(alpha), '\phi', num2str(phi), '\dim', num2str(dims(i)), '\resultsErrorTestCasesTypeI_o.csv'), [sigma_range' (err_o(:, 1) / total(1))])
            csvwrite(strcat(folder, mode, '\alpha', num2str(alpha), '\phi', num2str(phi), '\dim', num2str(dims(i)), '\resultsErrorTestCasesTypeI_oc.csv'), [sigma_range' (err_oc(:, 1) / total(1))])
            csvwrite(strcat(folder, mode, '\alpha', num2str(alpha), '\phi', num2str(phi), '\dim', num2str(dims(i)), '\resultsErrorTestCasesTypeII.csv'), [sigma_range' (err(:, 2) / total(2))])
            csvwrite(strcat(folder, mode, '\alpha', num2str(alpha), '\phi', num2str(phi), '\dim', num2str(dims(i)), '\resultsErrorTestCasesTypeII_o.csv'), [sigma_range' (err_o(:, 2) / total(2))])
            csvwrite(strcat(folder, mode, '\alpha', num2str(alpha), '\phi', num2str(phi), '\dim', num2str(dims(i)), '\resultsErrorTestCasesTypeII_oc.csv'), [sigma_range' (err_oc(:, 2) / total(2))])
            
        end
    end
end