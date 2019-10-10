function [err_FDR, err_Bon, err_Hoc, t] = StatSignificance(M, N, sigma_range, noise, alpha, min_size, c_bg)
%STATSIGNIFICANCE Loop through all possible ROI to test significance
% INPUT
% -----
% M: height/vertical size of the images to be tested
% N: width/horizontal size of the images to be tested
% sigma_range: vector with standard deviations of the noise to test
% noise: M-by-N standard normally distributed noise matrix
% alpha: statistical significance
% min_size: minimal size of the ROI (optional)
% c_bg: greyscale value for the image background (optional)


% [err_FDR, err_Bon, err_Hoc, t] = StatSignificance(M, N, sigma_range, noise, alpha, 3);


% Check whether a minimal size was given:
if (~exist('min_size', 'var'))
    min_size = 0;
end

% Check whether an alternative background greyvalue was given:
if (~exist('c_bg', 'var'))
    c_bg = 127.5;
end

% Initialize counters for type I and II errors:
err_FDR = zeros(size(sigma_range, 2), 2);
err_Bon = zeros(size(sigma_range, 2), 2);
err_Hoc = zeros(size(sigma_range, 2), 2);

% Initialize counters for total number of foreground and background pixels:
t = zeros(1, 2);

% Loop through all possible ROI with at least 1 pixel margin:
for tlc1 = 2 : M-1
    for tlc2 = 2 : N-1
        
        % Display progress:
        disp([tlc1 tlc2])
        
        % Loop through all ROI with the given minimal size:
        for brc1 = tlc1 + min_size : M-1
            for brc2 = tlc2 + min_size : N-1
                % Initialize the picture with constant background:
                ROI_Picture = ones(M, N) * c_bg;
                
                % Generate ROI pattern:
                for i = tlc1 : brc1
                    for j = tlc2 : brc2
                        if mod(i+j, 2) == 0
                            ROI_Picture(i, j) = 0;
                        elseif mod(i+j, 2) == 1
                            ROI_Picture(i, j) = 255;
                        end
                    end
                end
                
                % Determine correct ROI picture:
                ROI = zeros(M, N);
                ROI(tlc1:brc1, tlc2:brc2) = 255;
%                 ROI(tlc1-1:brc1, tlc2:brc2) = 255;
%                 ROI(tlc1:brc1, tlc2-1:brc2) = 255;
                
                % Count foreground and background pixels:
                t = t + [sum(sum(ROI == 255)), sum(sum(ROI == 0))];
                
                % Initialize index counter:
                ind = 1;
                for sigma = sigma_range
                    % Add noise to the image:
                    ROI_noisy = ROI_Picture + sigma * noise;
                    
                    % Extract ROI:
                    ROI_FDR = ROI_Detection(ROI_noisy, sigma, alpha, 'FDR');
                    ROI_Bon = ROI_Detection(ROI_noisy, sigma, alpha, 'Bonferroni');
                    ROI_Hoc = ROI_Detection(ROI_noisy, sigma, alpha, 'Hochberg');
                    
                    % Perform morphological operations:
                    ROI_FDR = MorphologicalProcessing(ROI_FDR / 255) * 255;
                    ROI_Bon = MorphologicalProcessing(ROI_Bon / 255) * 255;
                    ROI_Hoc = MorphologicalProcessing(ROI_Hoc / 255) * 255;
                    
                    % Count type I and II errors:
                    err_FDR(ind, :) = err_FDR(ind, :) + [sum(sum(ROI == 0 & ROI_FDR == 255)), sum(sum(ROI == 255 & ROI_FDR == 0))];
                    err_Bon(ind, :) = err_Bon(ind, :) + [sum(sum(ROI == 0 & ROI_Bon == 255)), sum(sum(ROI == 255 & ROI_Bon == 0))];
                    err_Hoc(ind, :) = err_Hoc(ind, :) + [sum(sum(ROI == 0 & ROI_Hoc == 255)), sum(sum(ROI == 255 & ROI_Hoc == 0))];
                    
                    % Increase index counter:
                    ind = ind + 1;
                end
            end
        end
    end
end

end
