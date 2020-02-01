function f_ROI = ROI_Detection(f, sigma, alpha, type)
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
d_plus = discreteDerivative(f, M, N, 'plus');
d_minus = discreteDerivative(f, M, N, 'minus');

% Calculate test statistic:
d = min(d_plus, d_minus);

% Calculate p-values based on d:
p = exp( - d .^2 / (4 * sigma^2) );

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
lambda = 2 * sigma * sqrt(- log(p_lambda));

% Create background indicator map:
bgMap = d < lambda;

% Create ROI indicator image f_ROI:
f_ROI = (1 - bgMap) * 255;

end


function d = discreteDerivative(f, M, N, direction)
% Determine direction of discrete derivative:
switch direction
    case 'plus'
        shift = 0;
    case 'minus'
        shift = 1;
end

% Initialize d1, d2:
% d1: vertical discrete derivative
% d2: horizontal discrete derivative
d1 = ones(M, N);
d2 = ones(M, N);

% Calculate d1:
d1(1 + shift : M - 1 + shift, :) = f(2 - shift : M - shift, :) - f(1 + shift : M - 1 + shift, :);
d1((1 - shift) * M + shift, :) = f(shift * M + (1 - shift), :) - f((1 - shift) * M + shift, :);

% Calculate d2:
d2(:, 1 + shift : N - 1 + shift) = f(:, 2 - shift : N - shift) - f(:, 1 + shift : N - 1 + shift);
d2(:, (1 - shift) * N + shift) = f(:, shift * N + (1 - shift)) - f(:, (1 - shift) * N + shift);

% Calculate d as the euclidean norm of d1 and d2:
d = sqrt(d1 .^2 + d2 .^2);

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