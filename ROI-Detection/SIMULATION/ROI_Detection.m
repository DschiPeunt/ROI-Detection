function I = ROI_Detection(F, t_alpha, sigma)
% F: square, noisy input image that contains a rectangular ROI
% t_alpha: threshold based on statistical significance alpha
% sigma: standard deviation of the noise

% Determine height and width of the input picture:
[m, n] = size(F);

% Calculate the euclidean norm of the vertical and horizontal discrete
% derivatives:
D_plus = discreteDerivative(F, m, n, 'plus');
D_minus = discreteDerivative(F, m, n, 'minus');

% Calculate test statistic:
D = min(D_plus, D_minus);

% Create thresholded binary matrix:
I = D >= t_alpha * sigma;

end

function D = discreteDerivative(F, m, n, direction)
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
D1 = ones(m, n);
D2 = ones(m, n);

% Calculate d1:
D1(1 + shift : m - 1 + shift, :) = F(2 - shift : m - shift, :) - F(1 + shift : m - 1 + shift, :);
D1((1 - shift) * m + shift, :) = F(shift * m + (1 - shift), :) - F((1 - shift) * m + shift, :);

% Calculate d2:
D2(:, 1 + shift : n - 1 + shift) = F(:, 2 - shift : n - shift) - F(:, 1 + shift : n - 1 + shift);
D2(:, (1 - shift) * n + shift) = F(:, shift * n + (1 - shift)) - F(:, (1 - shift) * n + shift);

% Calculate d as the euclidean norm of d1 and d2:
D = sqrt(D1 .^2 + D2 .^2);

end