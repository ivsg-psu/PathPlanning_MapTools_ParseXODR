% A script to test the execution of fcn_RoadSeg_findXYfromXODRArc

% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu 

% Revision history:
%     2022_04_02
%     -- wrote the code

% Create a test arc for the function
h0 = 3*pi/4;
x0 = 9;
y0 = 2;
l0 = 100;
K0 = 1/25;
s = 0:0.5:l0;

% Create a new figure into which to plot the spiral results
fHand = figure;
clf
hold on
grid on
axis equal

% Run the function with the plotting enabled by sending in the figure
% handle
[x1,y1] = fcn_RoadSeg_findXYfromXODRArc(s,h0,x0,y0,K0,fHand);

% Create a second test arc for the function
h0 = -3*pi/4;
x0 = 9;
y0 = 2;
l0 = 100;
K0 = -1/25;
s = 0:0.5:l0;

% Run the function without plotting
[x2,y2] = fcn_RoadSeg_findXYfromXODRArc(s,h0,x0,y0,K0);

% Plot the results returned from the function
figure(fHand)
plot(x2,y2,'r*-.')