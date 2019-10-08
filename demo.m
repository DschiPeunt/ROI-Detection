% Set image size, standard deviation of noise and statistical significance:
M = 8;
N = 16;
sigma = 7;
alpha = 0.05;

% Generate ROI picture:
% f = ROI_Generator(M, N);

% Add noise to the picture:
% f = f + + sigma * randn(size(f));

% Extract ROI:
f_ROI_FDR = ROI_Detection(f, sigma, alpha, 'FDR');
f_ROI_Bon = ROI_Detection(f, sigma, alpha, 'Bonferroni');
f_ROI_Hoc = ROI_Detection(f, sigma, alpha, 'Hochberg');

% Plot ROI_Picture and ROI:
figure,
subplot(2,2,1), imshow(uint8(f));
subplot(2,2,2), imshow(uint8(f_ROI_FDR));
subplot(2,2,3), imshow(uint8(f_ROI_Bon));
subplot(2,2,4), imshow(uint8(f_ROI_Hoc));