% Set parent folder to store the .csv files:
folder = '/space/fbms/dblank';

% Reset RNG seed:
rng('default')

% Set number of noises to generate:
nr_noise = 1000;

% Set statistical significances to consider:
alphas = [0.01 0.05];

% Set side lengths of the structuring element to consider:
phis = [3 5 7 99];

% Set maximal standard deviation of the noise:
max_sigma = 150;

% Set background grayscale value:
c_bg = 127.5;

% Set increment size for threshold algorithm:
increment = 0.0001;

% Define array to loop over different positions of the pixels:
pixelPositions = {'background_corner', 'background_edge', 'background_free', 'foreground_corner', 'foreground_edge', 'foreground_free'};
correctVals = [0 0 0 1 1 1];

% Determine range of standard deviations:
sigma_range = 1 : max_sigma;

% Loop over background and foreground pixels:
parfor p = 1 : size(pixelPositions, 2)
	
    % Determine what pixel position simulate:
    pixelPos = pixelPositions{p};
    
    % Determine correct value based on pixel position:
    correctVal = correctVals(p);
    
    % Loop over side lenghts of the structuring element:
    for phi = phis
        
        % Define structuring element:
        SE = strel('square', phi);
        
        % Initialize image around the pixel:
        V = ones(2 * phi + 3, 2 * phi + 3) * c_bg;
        
        % Set top left corner of the ROI based position of the
        % pixel to simulate (Simulated pixel is
        % [phi + 2 phi + 2]):
        switch pixelPos
            case 'background_corner'
                tlc = [phi + 3 phi + 3];
            case 'background_edge'
                tlc = [1 phi + 3];
            case 'background_free'
                tlc = [2 * phi + 3 2 * phi + 3];
            case 'foreground_corner'
                tlc = [phi + 2 phi + 2];
            case 'foreground_edge'
                tlc = [1 phi + 2];
            case 'foreground_free'
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
        
        % Loop over statistical significances:
        for alpha = alphas
            
            % Calculate different statistical significances:
            alpha_bin = alpha;
            alpha_o = power(alpha / phi, 2 / (phi + 1));
            alpha_c = alpha / phi^2;
            alpha_oc = power(alpha / phi^3, 2 / (phi + 1));
            
            % Calculate thresholds based on alphas:
            [t_bin, alpha_bin] = Threshold(alpha_bin, increment);
            [t_o, alpha_o] = Threshold(alpha_o, increment);
            [t_c, alpha_c] = Threshold(alpha_c, increment);
            [t_oc, alpha_oc] = Threshold(alpha_oc, increment);
            
            % Initialize counter for errors:
            err = zeros(max_sigma, 4);
            err_test = zeros(max_sigma, 1);
            
            % Repeat for multiple different randomly generated
            % noises:
            for k = 1 : nr_noise
                
                % Create standard normally distributed noise:
                eps = randn(2 * phi + 3, 2 * phi + 3);
                
                % Loop over a range of standard deviations:
                for sigma = 1 : max_sigma
                    
                    % Add noise to the image:
                    F = V + sigma * eps;
                    
                    % Perform binarization:
                    I_bin = ROI_Detection(F, t_bin, sigma);
                    
                    % Perform binary opening:
                    I_o = ROI_Detection(F, t_o, sigma);
                    I_o = imopen(I_o, SE);
                    
                    % Perform binary closing:
                    I_c = ROI_Detection(F, t_c, sigma);
                    I_c = imclose(I_c, SE);
                    
                    % Perform binary opening & closing:
                    I_oc = ROI_Detection(F, t_oc, sigma);
                    I_oc = imopen(I_oc, SE);
                    I_oc = imclose(I_oc, SE);
                    
                    % Count errors:
                    err(sigma, 1) = err(sigma, 1) + (I_bin(phi + 2, phi + 2) ~= correctVal);
                    err(sigma, 2) = err(sigma, 2) + (I_o(phi + 2, phi + 2) ~= correctVal);
                    err(sigma, 3) = err(sigma, 3) + (I_c(phi + 2, phi + 2) ~= correctVal);
                    err(sigma, 4) = err(sigma, 4) + (I_oc(phi + 2, phi + 2) ~= correctVal);
                    
                    % Try test procedure (t_o for I_oc):
                    I_test = imclose(I_o, SE);
                    err_test(sigma, 1) = err_test(sigma, 1) + (I_test(phi + 2, phi + 2) ~= correctVal);
                    
                end
            end
            
            % Write to .csv file:
            csvwrite(strcat(folder, '/alpha', num2str(alpha), '/phi', num2str(phi), '/', pixelPos, '.csv'), [sigma_range' (err(:, 1) / nr_noise) (err(:, 2) / nr_noise) (err(:, 3) / nr_noise) (err(:, 4) / nr_noise)])
            csvwrite(strcat(folder, '/alpha', num2str(alpha), '/phi', num2str(phi), '/', pixelPos, '_test.csv'), [sigma_range' (err_test(:, 1) / nr_noise)])
            
        end
    end
end