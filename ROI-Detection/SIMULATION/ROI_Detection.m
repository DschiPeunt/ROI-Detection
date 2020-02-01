function f_ROI = ROI_Detection(f, sigma, alpha)
%ROI_DETECTION Extract ROI from a matrix
% INPUT
% -----
% f: square input image that contains a rectangular ROI
% sigma: standard deviation of the noise
% alpha: statistical significance

% Determine height and width of the input picture:
[M, N] = size(f);

% Calculate the euclidean norm of the vertical and horizontal discrete
% derivatives:
d_plus = discreteDerivative(f, M, N, 'plus');
d_minus = discreteDerivative(f, M, N, 'minus');

% Calculate test statistic:
d = min(d_plus, d_minus);

% Calculate p-values based on d:
p = exp( - d .^2 / (4 * sigma^2) );

% Calculate threshold based on statistical significance:
[t_alpha, alpha_real] = Threshold(alpha, 0.01);

% Create background indicator map:
bgMap = d < t_alpha * sigma;

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

function [t, alpha_real] = Threshold(alpha, increment)
% Calculate threshold based on target statistical significance
t = 0;

while CDF(t, 1) < 1 - alpha
    t = t + increment;
end

alpha_real = CDF(t, 1);

end

function y = CDF(x, sigma)
% Calculate CDF at x:
y = (1 / sqrt(3)) * ( 3 / 2 - (3 / 2) * exp(-x^2 / (3 * sigma^2)) * besseli(0, x^2 / (6 * sigma^2)) ) - sqrt(3)...
    - ((2 - sqrt(3)) / 2) * marcumq(((2 - sqrt(3)) / 2) * sqrt(x / sigma), ((2 + sqrt(3)) / 2) * sqrt(x / sigma))...
    + ((2 + sqrt(3)) / 2) * marcumq(((2 + sqrt(3)) / 2) * sqrt(x / sigma), ((2 - sqrt(3)) / 2) * sqrt(x / sigma));

end