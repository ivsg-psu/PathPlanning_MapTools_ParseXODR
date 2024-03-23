%% script_test_fcn_ParseXODR_extractXYfromSTSpiral
% A script to test the execution of fcn_ParseXODR_extractXYfromSTSpiral
% This script was originally written by C. Beal, updated by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2022_04_02 - C. Beal
% -- wrote the code
% 2022_04_02 - C. Beal
% -- updated to add assertions

%% Basic test - no figure

% Create a test arc for the function
radius = 20;
l0 = 100;
h0 = pi/2;
x0 = radius;
y0 = radius/2;
K0 = 0;
KF = 1/radius;
N_points = 20;
stationPoints = linspace(0,((2*pi - h0)*radius),N_points)';



% Run the function with the plotting enabled by sending in the figure
% handle
[x_spiral,y_spiral] = fcn_ParseXODR_extractXYfromSTSpiral(stationPoints, l0, h0,x0,y0,K0, KF);

assert(length(x_spiral(:,1))==length(stationPoints(:,1)));
assert(length(y_spiral(:,1))==length(stationPoints(:,1)));
assert(length(x_spiral(1,:))==1);
assert(length(y_spiral(1,:))==1);

% Check start point
assert(isequal(round(x_spiral(1,1),4),round(x0,4)));
assert(isequal(round(y_spiral(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_spiral(end,1),4),round(-28.7316,4)));
assert(isequal(round(y_spiral(end,1),4),round(67.2521,4)));


%% Basic test - with figure
fig_num = 1;

% Create a new figure into which to plot the spiral results
figure(fig_num);
clf

% Create a test arc for the function
radius = 20;
l0 = 100;
h0 = pi/2;
x0 = radius;
y0 = radius/2;
K0 = 0;
KF = 1/radius;
N_points = 20;
stationPoints = linspace(0,((2*pi - h0)*radius),N_points)';



% Run the function with the plotting enabled by sending in the figure
% handle
[x_spiral,y_spiral] = fcn_ParseXODR_extractXYfromSTSpiral(stationPoints, l0, h0,x0,y0,K0, KF, fig_num);

assert(length(x_spiral(:,1))==length(stationPoints(:,1)));
assert(length(y_spiral(:,1))==length(stationPoints(:,1)));
assert(length(x_spiral(1,:))==1);
assert(length(y_spiral(1,:))==1);

% Check start point
assert(isequal(round(x_spiral(1,1),4),round(x0,4)));
assert(isequal(round(y_spiral(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_spiral(end,1),4),round(-28.7316,4)));
assert(isequal(round(y_spiral(end,1),4),round(67.2521,4)));

