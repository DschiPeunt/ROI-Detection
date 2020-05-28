function cases = ErrorTestCases(dims, nr_pictures, cases, alpha, max_nr_noise, max_sigma)

% Define side length of structuring element:
phi = 3;

% Define structuring element:
SE = strel('square', phi);

% Set increment size for threshold algorithm:
increment = 0.0001;

% Calculate threshold based on alpha:
t_alpha = Threshold(alpha, increment);

% Determine relaxed significance:
% alpha_rel_o = power(alpha / phi, 2 / (phi - 1));
% alpha_rel_oc = power(alpha / phi^3, 2 / (phi - 1));

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
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
        
        % Count total number of foreground and background pixels:
        total = [sum(sum(R == 1)), sum(sum(R == 0))];
        
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
        cases.(dim_name).(strcat('total', num2str(j))) = total * nr_noise;
        cases.(dim_name).(strcat('err', num2str(j))) = err;
        cases.(dim_name).(strcat('err_o', num2str(j))) = err_o;
        cases.(dim_name).(strcat('err_oc', num2str(j))) = err_oc;
        
    end
end

end