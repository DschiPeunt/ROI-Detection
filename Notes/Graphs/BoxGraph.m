function [] = BoxGraph

close all

% Specify vertical and horizontal size of the grid:
height = 9;
width = 9;

% Set boxes to be marked for opening:
markedOpeningBefore = [[-3 -1]; [-2 -1]; [-2 0]; [-2 1]; [-1 -2]; [-1 -1]; [-1 0]; [-1 1]; [-1 2]; [0 -2]; [0 -1]; [0 0]; [0 1]; [2 -3]; [2 -2]; [3 -3]; [3 -2]];
markedOpeningErode = [[-1 0]];
markedOpeningOpen = [[-2 -1]; [-2 0]; [-2 1]; [-1 -1]; [-1 0]; [-1 1]; [0 -1]; [0 0]; [0 1]];

% Set boxes to be marked for closing:
markedClosingBefore = [[-2 0]; [-2 2]; [1 1]; [1 -2]];
markedClosingDilate = [[-3 -1]; [-3 0]; [-3 1]; [-3 2]; [-3 3]; [-2 -1]; [-2 0]; [-2 1]; [-2 2]; [-2 3]; [-1 -1]; [-1 0]; [-1 1]; [-1 2]; [-1 3]; [0 -3]; [0 -2]; [0 -1]; [0 0]; [0 1]; [0 2]; [1 -3]; [1 -2]; [1 -1]; [1 0]; [1 1]; [1 2]; [2 -3]; [2 -2]; [2 -1]; [2 0]; [2 1]; [2 2]];
markedClosingClosed = [[-2 0]; [-2 1]; [-2 2]; [-1 0]; [-1 1]; [0 0]; [0 1]; [1 -2]; [1 -1]; [1 0]; [1 1]];

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
for p = 1 : size(markedClosingClosed, 1)
    fill(xCoord(markedClosingClosed(p, 1)), yCoord(markedClosingClosed(p, 2)), 'k')
end

hold off
axis off
title('Closed image')

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