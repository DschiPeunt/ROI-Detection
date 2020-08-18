function cases = CreateTestCases(dims, nr_pictures, min_size)

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

% Create randomly generated ROI images:
cases = createTestCases(dims, nr_pictures, min_size);

% Plot generated ROI images:
showTestCases(dims, nr_pictures, cases, 'F', 1);

end

function cases = createTestCases(dims, nr_pictures, min_size)

% Initialize structure to store images and coordinates of the ROI:
cases = struct;

% Loop over dimensions to create:
for i = 1 : size(dims, 2)
    
    % Generate name of the substructure of the dimension:
    dim_name = strcat('pxl', num2str(dims(i)), 'x', num2str(dims(i)));
    
    for j = 1 : nr_pictures
        
        % Generate names of the image and coordinates:
        fname = strcat('F', num2str(j));
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