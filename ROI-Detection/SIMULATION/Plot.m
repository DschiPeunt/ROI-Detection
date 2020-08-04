% Specify range of standard deviations:
sigma_range = 1 : 150;

% Define array to loop over background and foreground pixels:
pixelType = 'foreground';

% Define array to loop over different positions of the pixels:
pixelPositions = {'corner', 'edge', 'free'};

% ------------------------------------------------------------------------

% Loop over different positions of the pixels:
for p = 1 : size(pixelPositions, 2)
    
    % Determine what pixel position to plot:
    pixelPos = pixelPositions{p};
    
    % Load .csv file:
    err = csvread(strcat(pixelType, '_', pixelPos, '_add8.csv'));
    
    % ------------------------------------------------------------------------
    
    % Type I error plot
    figure
    hold on
    plot(sigma_range, err(:, 2), 'Linewidth', 2.0)
    plot(sigma_range, err(:, 3), 'Linewidth', 2.0)
    plot(sigma_range, err(:, 4), 'Linewidth', 2.0)
    hold off
    legend('Binarization', 'Opening', 'Opening & Closing', 'Location', 'southeast')
    axis([0 150 0 1])
    title(strcat(pixelType, pixelPos))
    
end

% Clear workspace:
clear
