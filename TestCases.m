function cases = TestCases(type, dims, nr_pictures, min_size)

% Check for missing input and set, if necessary:
if (~exist('dims', 'var'))
    dims = [128, 256, 512];
end
if (~exist('nr_pictures', 'var'))
    nr_pictures = 5;
end
if (~exist('min_size', 'var'))
    min_size = 20;
end

switch type
    case 'create'
        % Create randomly generated ROI images:
        cases = createTestCases(dims, nr_pictures, min_size);
        
        % Plot ROI images:
        showTestCases(dims, nr_pictures, cases, 'f', 1);
    case 'load'
        % Load input parameters and randomly generated ROI images:
        load('ROI_TestCases.mat');
        
        % Perform statistical significance analysis for test cases:
        cases = statSignificanceTestCases(dims, nr_pictures, cases, 0.05);
end

end

function cases = createTestCases(dims, nr_pictures, min_size)

% Initialize structure to store images and coordinates of the ROI:
cases = struct;a

% Loop over dimensions to create:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Generate names of the image and coordinates:
        fname = strcat('f', num2str(j));
        tlcname = strcat('tlc', num2str(j));
        brcname = strcat('brc', num2str(j));
        
        % Randomly generate ROI:
        [ROI_Picture, tlc, brc] = ROI_Generator(dims(i), dims(i), min_size);
        
        % Store image and coordinates:
        cases.(dim_name).(fname) = ROI_Picture;
        cases.(dim_name).(tlcname) = tlc;
        cases.(dim_name).(brcname) = brc;
        
    end
end

end

function cases = statSignificanceTestCases(dims, nr_pictures, cases, alpha)

% Load library of morphological operations:
MO = MorphologicalOperations;

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
        for nr_noise = 1 : 1
            
            % Create standard normally distributed noise:
            noise = randn(dims(i), dims(i));
            
            % Loop over a range of standard deviations:
            for sigma = 1 : 1
                
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
                ROI_FDR_o = MO.BinOpening(ROI_FDR / 255) * 255;
                ROI_Bon_o = MO.BinOpening(ROI_Bon / 255) * 255;
                ROI_Hoc_o = MO.BinOpening(ROI_Hoc / 255) * 255;
                
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

function [] = showTestCases(dims, nr_pictures, cases, name, row)

% Loop over dimensions:
for i = 1 : size(dims, 2)
    
    % Start plot for dimension:
    figure(i)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Generate name of the image:
        fname = strcat(name, num2str(j));
        
        % Plot the image:
        subplot(row, nr_pictures, j), imshow(uint8(cases.(dim_name).(fname)));
        
    end
end

end