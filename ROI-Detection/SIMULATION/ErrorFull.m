function [err, err_o, err_oc, total] = ErrorFull(m, n, alpha, max_nr_noise, max_sigma, min_size, c_bg)
%ERRORFULL Loop through all possible ROI to test error probabilities
% INPUT
% -----
% m: height/vertical size of the images to be tested
% n: width/horizontal size of the images to be tested
% alpha: statistical significance
% max_nr_noise: amount of noises to test
% max_sigma: up to which standard deviation to test the errors
% min_size: minimal size of the ROI (optional)
% c_bg: grayscale value for the image background (optional)

% Define side length of structuring element:
phi = 3;

% Define structuring element:
SE = strel('square', phi);

% Check whether a minimal size was given:
if (~exist('min_size', 'var'))
    min_size = phi;
end

% Check whether an alternative background grayvalue was given:
if (~exist('c_bg', 'var'))
    c_bg = 127.5;
end

% Set increment size for threshold algorithm:
increment = 0.0001;

% Calculate threshold based on alpha:
[t_alpha, alpha_real] = Threshold(alpha, increment);

% Initialize counters for type I and II errors:
err = zeros(max_sigma, 2);
err_o = zeros(max_sigma, 2);
err_oc = zeros(max_sigma, 2);

% Initialize counters for total number of foreground and background pixels:
total = zeros(1, 2);

% Loop through all possible ROI with at least 1 pixel margin:
for tlc1 = 2 : m-1
    for tlc2 = 2 : n-1
        
        % Display progress:
        disp([tlc1 tlc2])
        
        % Loop through all ROI with the given minimal size:
        for brc1 = tlc1 + min_size : m-1
            for brc2 = tlc2 + min_size : n-1
                
                % Initialize the picture with constant background:
                V = ones(m, n) * c_bg;
                
                % Generate ROI pattern:
                for i = tlc1 : brc1
                    for j = tlc2 : brc2
                        if mod(i+j, 2) == 0
                            V(i, j) = 0;
                        elseif mod(i+j, 2) == 1
                            V(i, j) = 255;
                        end
                    end
                end
                
                % Determine correct ROI picture:
                R = zeros(m, n);
                R(tlc1 : brc1, tlc2 : brc2) = 1;
                
                % Count background and foreground pixels:
                total = total + [sum(sum(R == 0)), sum(sum(R == 1))];
                
                % Repeat for multiple different randomly generated noises:
                for nr_noise = 1 : max_nr_noise
                    
                    % Create standard normally distributed noise:
                    eps = randn(m, n);
                    
                    for sigma = 1 : max_sigma
                        
                        % Add noise to the image:
                        F = V + sigma * eps;
                        
                        % Extract ROI:
                        I = ROI_Detection(F, t_alpha, sigma);
                        
                        % Perform binary opening:
                        I_o = imopen(I, SE);
                        
                        % Perform binary closing:
                        I_oc = imclose(I_o, SE);
                        
                        % Count type I and II errors:
                        err(sigma, :) = err(sigma, :) + [sum(sum(R == 0 & I == 1)), sum(sum(R == 1 & I == 0))];
                        err_o(sigma, :) = err_o(sigma, :) + [sum(sum(R == 0 & I_o == 1)), sum(sum(R == 1 & I_o == 0))];
                        err_oc(sigma, :) = err_oc(sigma, :) + [sum(sum(R == 0 & I_oc == 1)), sum(sum(R == 1 & I_oc == 0))];
                        
                    end
                end
            end
        end
    end
end

% Adjust total number of pixels for the amount of different noises:
total = total * max_nr_noise;

end
