function cases = StatSignificanceTestCases(dims, nr_pictures, cases, alpha, max_nr_noise, max_sigma)

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
        ROI(tlc(1) : brc(1), tlc(2) : brc(2)) = 1;
        
        % Count total number of foreground and background pixels:
        t = [sum(sum(ROI == 1)), sum(sum(ROI == 0))];
        
        % Initialize counters for type I and II errors:
        err = zeros(max_sigma, 2);
        err_o = zeros(max_sigma, 2);
        err_oc = zeros(max_sigma, 2);
        
        % Repeat for multiple different randomly generated noises:
        for nr_noise = 1 : max_nr_noise
            
            % Create standard normally distributed noise:
            noise = randn(dims(i), dims(i));
            
            % Loop over a range of standard deviations:
            for sigma = 1 : max_sigma
                
                % Add noise to the image:
                ROI_noisy = ROI_Picture + sigma * noise;
                
                % Extract ROI:
                ROI_bin = ROI_Detection(ROI_noisy, sigma, alpha) / 255;
                
                % Count type I and II errors:
                err(sigma, :) = err(sigma, :) + [sum(sum(ROI == 0 & ROI_bin == 1)), sum(sum(ROI == 1 & ROI_bin == 0))];
                
                % Perform binary opening:
                ROI_FDR_o = imopen(ROI_bin, SE);
                
                % Count type I and II errors:
                err_o(sigma, :) = err_o(sigma, :) + [sum(sum(ROI == 0 & ROI_FDR_o == 1)), sum(sum(ROI == 1 & ROI_FDR_o == 0))];
                
                % Perform binary closing:
                ROI_FDR_oc = imclose(ROI_FDR_o, SE);
                
                % Count type I and II errors:
                err_oc(sigma, :) = err_oc(sigma, :) + [sum(sum(ROI == 0 & ROI_FDR_oc == 1)), sum(sum(ROI == 1 & ROI_FDR_oc == 0))];
                
            end
        end
        
        % Save results:
        cases.(dim_name).(strcat('t', num2str(j))) = t * nr_noise;
        cases.(dim_name).(strcat('err', num2str(j))) = err;
        cases.(dim_name).(strcat('err_o', num2str(j))) = err_o;
        cases.(dim_name).(strcat('err_oc', num2str(j))) = err_oc;
        
    end
end

end