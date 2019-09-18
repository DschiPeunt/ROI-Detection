function f_ROI = ROI_Detection_direct_approach(f, sigma, alpha, type, c_bg)
%ROI_DETECTION Extract ROI from a matrix
% INPUT
% -----
% f: square input image that contains a rectangular ROI
% sigma: standard deviation of the noise
% alpha: statistical significance
% type: type of the thresholding procedure

% Determine height and width of the input picture:
[M, N] = size(f);

% Calculate the total number of pixels in f:
nr_pxl = M * N;

% Calculate the euclidean norm of the vertical and horizontal discrete
% derivatives:
d = f - c_bg;

% Calculate p-values based on d:
p = 2 * (1 - normcdf(abs(d), 0, sigma));

% Determine threshold probability:
switch type
    case 'FDR'
        % Perform FDR thresholding approach:
        p_lambda = FDRThresholding(nr_pxl, p, alpha);
    case 'Bonferroni'
        % Perform Bonferroni thresholding approach:
        p_lambda = BonferroniThresholding(nr_pxl, p, alpha);
    case 'Hochberg'
        % Perform Hochberg thresholding approach:
        p_lambda = HochbergThresholding(nr_pxl, p, alpha);
end

% Calculate threshold based on threshold probability:
lambda = sigma * norminv(1 - p_lambda / 2);

% Create background indicator map:
bgMap = abs(d) < lambda;

% Create ROI indicator image f_ROI:
f_ROI = (1 - bgMap) * 255;

end


function p_lambda = FDRThresholding(nr_pxl, p, alpha)
% Order the p-values according their magnitude:
p_sort = sort(reshape(p, [nr_pxl, 1]));

% Find largest index k, such that p_sort(k) <= k * alpha / nr_pxl:
for k = nr_pxl:-1:1
    if p_sort(k) <= k * alpha / nr_pxl
        break
    end
end

% Determine threshold probability:
p_lambda = p_sort(k);

end


function p_lambda = BonferroniThresholding(nr_pxl, p, alpha)
% Determine threshold probability:
p_lambda = alpha / nr_pxl;

end


function p_lambda = HochbergThresholding(nr_pxl, p, alpha)
% Order the p-values according their magnitude:
p_sort = sort(reshape(p, [nr_pxl, 1]));

% Find largest index k, such that p_sort(k) <= alpha / (nr_pxl - k + 1):
for k = nr_pxl:-1:1
    if p_sort(k) <= alpha / (nr_pxl - k + 1)
        break
    end
end

% Determine threshold probability:
p_lambda = p_sort(k);

end