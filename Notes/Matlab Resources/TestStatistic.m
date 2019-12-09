function [] = TestStatistic

close all

% Specify vertical and horizontal size of the grid:
height = 5;
width = 5;

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

% Mark specific boxes:
fill(xCoord(0), yCoord(0), 'm')
fill(xCoord(0), yCoord(1), 'r')
fill(xCoord(1), yCoord(0), 'b')
fill(xCoord(0), yCoord(-1), 'b')
fill(xCoord(-1), yCoord(0), 'r')

% Label points:
text(-0.2, 0, '(i, j)', 'color', 'w', 'Fontsize', 14)
text(-0.4, 1, '(i - 1, j)', 'color', 'w', 'Fontsize', 14)
text(0.55, 0, '(i, j + 1)', 'color', 'w', 'Fontsize', 14)
text(-0.45, -1, '(i + 1, j)', 'color', 'w', 'Fontsize', 14)
text(-1.4, 0, '(i, j - 1)', 'color', 'w', 'Fontsize', 14)

hold off
axis off

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