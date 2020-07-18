% Set parent folder to store the .csv files:
folder = 'C:\Users\Domin\Dropbox\Masterarbeit\ROI-Detection\Power\CSV\';

% Reset RNG seed:
rng('default')

% Load input:
load('inputPowerSim.mat');

% ------------------------------------------------------------------------

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% Loop over statistical significances:
for alpha = alphas
    
    % Set increment size for threshold algorithm:
    increment = 0.0001;
    
    % Calculate threshold based on alpha:
    [t_alpha, alpha_real] = Threshold(alpha, increment);
    
    % Initialize vectors to store bounds:
    lowerBound = zeros(1, max_sigma);
    upperBound = zeros(1, max_sigma);
    
    % Simulate random variables and determine empirical bounds:
    [lowerBound, upperBound] = PowerSim(t_alpha, nr_noise, max_sigma, c_bg);
    
    % ------------------------------------------------------------------------
    
    % Write to .csv file:
    csvwrite(strcat(folder, 'resultsPowerSimBounds_alpha', num2str(alpha), '.csv'), [sigma_range' lowerBound' upperBound'])
    
end

% Clear workspace:
clear alpha alpha_real increment t_alpha
