function cases = StatSignificanceTestCases(dims, nr_pictures, cases, alpha, max_nr_noise, max_sigma)

% Load library of morphological operations:
MO = MorphologicalOperations;

% Define structuring element:
SE = strel('square', 3);

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Display progress:
        disp([dims(i) j])
        
        % Load image:
        fname = strcat('f', num2str(j));
        ROI_Picture = cases.(dim_name).(fname);
        
        % Load top left and bottom right coordinates of the ROI:
        tlcname = strcat('tlc', num2str(j));
        brcname = strcat('brc', num2str(j));
        tlc = cases.(dim_name).(tlcname);
        brc = cases.(dim_name).(brcname);
        
        % Determine correct ROI:
        ROI = zeros(dims(i), dims(i));
        ROI(tlc(1) : brc(1), tlc(2) : brc(2)) = 255;
        
        % Count total number of foreground and background pixels:
        t = [sum(sum(ROI == 255)), sum(sum(ROI == 0))];
        
        % Initialize counters for type I and II errors:
        err_FDR = zeros(150, 2);
        err_Bon = zeros(150, 2);
        err_Hoc = zeros(150, 2);
        err_FDR_o = zeros(150, 2);
        err_Bon_o = zeros(150, 2);
        err_Hoc_o = zeros(150, 2);
        
        % Repeat for multiple different randomly generated noises:
        for nr_noise = 1 : max_nr_noise
            
            % Create standard normally distributed noise:
            noise = randn(dims(i), dims(i));
            
            % Loop over a range of standard deviations:
            for sigma = 1 : max_sigma
                
                % Add noise to the image:
                ROI_noisy = ROI_Picture + sigma * noise;
                
                % Extract ROI:
                ROI_FDR = ROI_Detection(ROI_noisy, sigma, alpha, 'FDR');
                ROI_Bon = ROI_Detection(ROI_noisy, sigma, alpha, 'Bonferroni');
                ROI_Hoc = ROI_Detection(ROI_noisy, sigma, alpha, 'Hochberg');
                
                % Count type I and II errors:
                err_FDR(sigma, :) = err_FDR(sigma, :) + [sum(sum(ROI == 0 & ROI_FDR == 255)), sum(sum(ROI == 255 & ROI_FDR == 0))];
                err_Bon(sigma, :) = err_Bon(sigma, :) + [sum(sum(ROI == 0 & ROI_Bon == 255)), sum(sum(ROI == 255 & ROI_Bon == 0))];
                err_Hoc(sigma, :) = err_Hoc(sigma, :) + [sum(sum(ROI == 0 & ROI_Hoc == 255)), sum(sum(ROI == 255 & ROI_Hoc == 0))];
                
                % Perform binary opening:
%                 ROI_FDR_o = MO.BinOpening(ROI_FDR / 255) * 255;
%                 ROI_Bon_o = MO.BinOpening(ROI_Bon / 255) * 255;
%                 ROI_Hoc_o = MO.BinOpening(ROI_Hoc / 255) * 255;
                ROI_FDR_o = imopen(ROI_FDR / 255, SE) * 255;
                ROI_Bon_o = imopen(ROI_Bon / 255, SE) * 255;
                ROI_Hoc_o = imopen(ROI_Hoc / 255, SE) * 255;
                
                % Count type I and II errors:
                err_FDR_o(sigma, :) = err_FDR_o(sigma, :) + [sum(sum(ROI == 0 & ROI_FDR_o == 255)), sum(sum(ROI == 255 & ROI_FDR_o == 0))];
                err_Bon_o(sigma, :) = err_Bon_o(sigma, :) + [sum(sum(ROI == 0 & ROI_Bon_o == 255)), sum(sum(ROI == 255 & ROI_Bon_o == 0))];
                err_Hoc_o(sigma, :) = err_Hoc_o(sigma, :) + [sum(sum(ROI == 0 & ROI_Hoc_o == 255)), sum(sum(ROI == 255 & ROI_Hoc_o == 0))];
                
            end
        end
        
        % Save results:
        cases.(dim_name).(strcat('t', num2str(j))) = t * nr_noise * sigma;
        cases.(dim_name).(strcat('err_FDR', num2str(j))) = err_FDR;
        cases.(dim_name).(strcat('err_Bon', num2str(j))) = err_Bon;
        cases.(dim_name).(strcat('err_Hoc', num2str(j))) = err_Hoc;
        cases.(dim_name).(strcat('err_FDR_o', num2str(j))) = err_FDR_o;
        cases.(dim_name).(strcat('err_Bon_o', num2str(j))) = err_Bon_o;
        cases.(dim_name).(strcat('err_Hoc_o', num2str(j))) = err_Hoc_o;
        
    end
end

end