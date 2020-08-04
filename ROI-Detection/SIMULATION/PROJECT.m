% Set parent folder to store the .csv files:
folder = 'C:\Users\Domin\Dropbox\Masterarbeit\ROI-Detection\SIMULATION\CSV_SinglePixel\';

% Reset RNG seed:
rng('default')

% ------------------------------------------------------------------------

% Set number of noises to generate:
nr_noise = 100;

% Set statistical significances to consider:
alpha = 0.05;

% Set side length of the structuring element to consider:
phi = 5;

% Set maximal standard deviation of the noise:
max_sigma = 150;

% Set background grayscale value:
c_bg = 127.5;

% ------------------------------------------------------------------------

% Define array to loop over normal and relaxed statistical significances:
alphaMode = 'normal';

% Define array to loop over background and foreground pixels:
pixelTypes = {'background', 'foreground'};

% Define array to loop over different positions of the pixels:
pixelPositions = {'corner', 'edge', 'free'};

% ------------------------------------------------------------------------

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% Define structuring element for opening:
SE_opening = strel('square', phi);

% Increase phi and define structuring element for closing:
phi = phi + 8;
SE_closing = strel('square', phi);

% Loop over background and foreground pixels:
for t = 1 : size(pixelTypes, 2)
    
    % Loop over different positions of the pixels:
    for p = 1 : size(pixelPositions, 2)
        
        % Determine what pixel type and position to simulate:
        pixelType = pixelTypes{t};
        pixelPos = pixelPositions{p};

        % Determine correct value based on pixel type:
        switch pixelType
            case 'background'
                correct_val = 0;
            case 'foreground'
                correct_val = 1;
        end
        
        % Combine type and position of pixel to simulate:
        pixelMode = strcat(pixelType, pixelPos);
        
        % Display progress:
        disp({alphaMode pixelMode})
        
        % Initialize image around the pixel:
        V = ones(2 * phi + 3, 2 * phi + 3) * c_bg;
        
        % Set top left corner of the ROI based position of the
        % pixel to simulate (Simulated pixel is [phi + 2 phi + 2]):
        switch pixelMode
            case 'backgroundcorner'
                tlc = [phi + 3 phi + 3];
            case 'backgroundedge'
                tlc = [1 phi + 3];
            case 'backgroundfree'
                tlc = [2 * phi + 3 2 * phi + 3];
            case 'foregroundcorner'
                tlc = [phi + 2 phi + 2];
            case 'foregroundedge'
                tlc = [1 phi + 2];
            case 'foregroundfree'
                tlc = [1 1];
        end
        
        % Set bottom right corner of the ROI (always
        % [2 * phi + 3, 2 * phi + 3]):
        brc = [2 * phi + 3 2 * phi + 3];
        
        % Determine modulus of the top left corner of the ROI:
        mod_tlc = mod(tlc(1) + tlc(2), 2);
        
        % Generate ROI pattern:
        for i = tlc(1) : brc(1)
            for j = tlc(2) : brc(2)
                if mod(i + j, 2) == mod_tlc
                    V(i, j) = 2 * c_bg;
                elseif mod(i + j, 2) ~= mod_tlc
                    V(i, j) = 0;
                end
            end
        end
        
        % Determine if normal or relaxed statistical significance is used:
        switch alphaMode
            case 'normal'
                alpha_use = alpha;
            case 'relaxed'
                alpha_use = power(alpha / phi^3, 2 / (phi + 1));
        end
        
        % Set increment size for threshold algorithm:
        increment = 0.0001;
        
        % Calculate threshold based on alpha:
        [t_alpha, alpha_real] = Threshold(alpha_use, increment);
        
        % Initialize counter for errors:
        err = zeros(max_sigma, 3);
        
        % Repeat for multiple different randomly generated noises:
        for k = 1 : nr_noise
            
            % Create standard normally distributed noise:
            eps = randn(2 * phi + 3, 2 * phi + 3);
            
            % Loop over a range of standard deviations:
            for sigma = 1 : max_sigma
                
                % Add noise to the image:
                F = V + sigma * eps;
                
                % Extract ROI:
                I = ROI_Detection(F, t_alpha, sigma);
                
                % Perform binary opening:
                I_o = imopen(I, SE_opening);
                
                % Perform binary closing:
                I_oc = imclose(I_o, SE_closing);
                
                % Count errors:
                err(sigma, 1) = err(sigma, 1) + (I(phi + 2, phi + 2) ~= correct_val);
                err(sigma, 2) = err(sigma, 2) + (I_o(phi + 2, phi + 2) ~= correct_val);
                err(sigma, 3) = err(sigma, 3) + (I_oc(phi + 2, phi + 2) ~= correct_val);
                
            end
        end
        
        % ------------------------------------------------------------------------
        
        % Write to .csv file:
        csvwrite(strcat(pixelType, '_', pixelPos, '_add8.csv'), [sigma_range' (err(:, 1) / nr_noise) (err(:, 2) / nr_noise) (err(:, 3) / nr_noise)])
        
    end
end

% Clear workspace:
clear
