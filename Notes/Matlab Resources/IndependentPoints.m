function [] = IndependentPoints

close all

% Specify vertical and horizontal size of the grid:
height = 11;
width = 11;

% ------------------------------------------------------------------------

figure
hold on

% Plot horizontal lines:
for y = -height / 2 : 1 : height / 2
    plot([-width / 2 width / 2], [y y], 'k', 'linewidth', 2)
end

% Plot vertical lines:
for x = -width / 2 : 1 : width / 2
    plot([x x], [-height / 2 height / 2], 'k', 'linewidth', 2)
end

% Mark ROI:
for p = width / 2 - 5.5 : width / 2 - 0.5
    for q = - 3 : height / 2 - 0.5
        fill(xCoord(p), yCoord(q), 'k')
    end
end

% Mark specific boxes:
fill(xCoord(-1), yCoord(0), 'm')
fill(xCoord(-1), yCoord(1), 'r')
fill(xCoord(-2), yCoord(0), 'r')
fill(xCoord(-1), yCoord(2), 'b')
fill(xCoord(-1), yCoord(3), 'r')
fill(xCoord(-2), yCoord(2), 'r')
fill(xCoord(-1), yCoord(-2), 'b')
fill(xCoord(-1), yCoord(-1), 'r')
fill(xCoord(-2), yCoord(-2), 'r')

% Label points:
text(-1.2, 0, '(i, j)', 'color', 'w', 'Fontsize', 10)
text(-1.4, 2, '(i - 2, j)', 'color', 'w', 'Fontsize', 10)
text(-1.4, -2, '(i + 2, j)', 'color', 'w', 'Fontsize', 10)

hold off
axis off
% title('Test statistic')

end

function x = xCoord(x)
% Set size of the box:
offset = 0.49;

% Calculate x-coordinates of the box around the point (x, y):
x = [x - offset x - offset x + offset x + offset];

end

function y = yCoord(y)
% Set size of the box:
offset = 0.49;

% Calculate y-coordinates of the box around the point (x, y):
y = [y - offset y + offset y + offset y - offset];

end