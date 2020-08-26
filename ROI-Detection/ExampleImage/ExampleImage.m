% Set parent folder to store the .csv files:
folder = 'C:\Users\Domin\Dropbox\Masterarbeit\ROI-Detection\ExampleImage\Example\';

% Reset RNG seed:
rng('default')

% ------------------------------------------------------------------------

% Set variables:
alpha = 0.05;
phi = 5;
dim = 16;
min_size = 2 * phi + 1;
sigma = 55;
increment = 0.0001;

% ------------------------------------------------------------------------

% Randomly generate ROI image:
[V, tlc, brc] = ROI_Generator(dim, dim, min_size);

% Randomly generate noise:
eps = randn(dim, dim);

% Add noise to the image:
F = V + sigma * eps;

% ------------------------------------------------------------------------

% Calculate threshold based on target statistical significance:
[t_alpha, alpha_real] = Threshold(alpha, increment);

% Define structuring element:
SE = strel('square', phi);

% Perform statistical test:
I = ROI_Detection(F, t_alpha, sigma);

% Perform morphological opening:
I_o = imopen(I, SE);

% Perform morphological closing:
I_oc = imclose(I_o, SE);

% ------------------------------------------------------------------------

imwrite(uint8(kron(V, ones(512 / dim))), strcat(folder, 'exampleV.png'))
imwrite(uint8(kron(F, ones(512 / dim))), strcat(folder, 'exampleF.png'))
imwrite(kron(1 - I, ones(512 / dim)), strcat(folder, 'exampleI.png'))
imwrite(kron(1 - I_o, ones(512 / dim)), strcat(folder, 'exampleI_o.png'))
imwrite(kron(1 - I_oc, ones(512 / dim)), strcat(folder, 'exampleI_oc.png'))
