function cases = CalculateErrorTestCases(dims, nr_pictures, cases, alpha, phi, max_nr_noise, max_sigma)
% dims: vector with different sizes of the test cases
% nr_pictures: number of pictures for each entry in dims
% cases: structure with test cases
% alpha: statistical significance
% phi: side length of structuring element
% max_nr_noise: amount of noises to test
% max_sigma: up to which standard deviation to test the errors

% Define structuring element:
SE = strel('square', phi);

% Set increment size for threshold algorithm:
increment = 0.0001;

% Calculate threshold based on alpha:
[t_alpha, alpha_real] = Threshold(alpha, increment);

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    % Initialize variables to save results:
    cases.(dim_name).('total') = 0;
    cases.(dim_name).('err') = 0;
    cases.(dim_name).('err_o') = 0;
    cases.(dim_name).('err_oc') = 0;
    
    for j = 1 : nr_pictures
        
        % Display progress:
        disp([dims(i) j])
        
        % Load image:
        Fname = strcat('F', num2str(j));
        V = cases.(dim_name).(Fname);
        
        % Load top left and bottom right coordinates of the ROI:
        tlcname = strcat('tlc', num2str(j));
        brcname = strcat('brc', num2str(j));
        tlc = cases.(dim_name).(tlcname);
        brc = cases.(dim_name).(brcname);
        
        % Determine correct ROI:
        R = zeros(dims(i), dims(i));
        R(tlc(1) : brc(1), tlc(2) : brc(2)) = 1;
        
        % Count total number of background and foreground pixels:
        total = [sum(sum(R == 0)), sum(sum(R == 1))];
        
        % Initialize counters for type I and II errors:
        err = zeros(max_sigma, 2);
        err_o = zeros(max_sigma, 2);
        err_oc = zeros(max_sigma, 2);
        
        % Repeat for multiple different randomly generated noises:
        for nr_noise = 1 : max_nr_noise
            
            % Create standard normally distributed noise:
            eps = randn(dims(i), dims(i));
            
            % Loop over a range of standard deviations:
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
        
        % Save results:
        cases.(dim_name).('total') = cases.(dim_name).('total') + total * max_nr_noise;
        cases.(dim_name).('err') = cases.(dim_name).('err') + err;
        cases.(dim_name).('err_o') = cases.(dim_name).('err_o') + err_o;
        cases.(dim_name).('err_oc') = cases.(dim_name).('err_oc') + err_oc;
        
    end
end

end