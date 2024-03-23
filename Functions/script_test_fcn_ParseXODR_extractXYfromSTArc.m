%% script_test_fcn_ParseXODR_extractXYfromSTArc
% A script to test the execution of fcn_ParseXODR_extractXYfromSTArc
% This script was originally written by C. Beal, updated by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2022_04_02 - C. Beal
% -- wrote the code
% 2024_03_22 - S. Brennan
% -- updated to add assertions

%% Basic test - no figure

% Create a test arc for the function
radius = 20;
h0 = pi/2;
x0 = radius;
y0 = radius/2;
K0 = 1/radius;
N_points = 20;
stationPoints = linspace(0,((2*pi - h0)*radius),N_points)';



% Run the function with the plotting enabled by sending in the figure
% handle
[x_arc,y_arc] = fcn_ParseXODR_extractXYfromSTArc(stationPoints,h0,x0,y0,K0);

assert(length(x_arc(:,1))==length(stationPoints(:,1)));
assert(length(y_arc(:,1))==length(stationPoints(:,1)));
assert(length(x_arc(1,:))==1);
assert(length(y_arc(1,:))==1);

% Check start point
assert(isequal(round(x_arc(1,1),4),round(x0,4)));
assert(isequal(round(y_arc(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_arc(end,1),4),round(0,4)));
assert(isequal(round(y_arc(end,1),4),round(y0-radius,4)));


%% Basic test - with figure
fig_num = 1;

% Create a new figure into which to plot the spiral results
figure(fig_num);
clf

% Create a test arc for the function
radius = 20;
h0 = pi/2;
x0 = radius;
y0 = radius/2;

K0 = 1/radius;
N_points = 20;
stationPoints = linspace(0,((2*pi - h0)*radius),N_points)';



% Run the function with the plotting enabled by sending in the figure
% handle
[x_arc,y_arc] = fcn_ParseXODR_extractXYfromSTArc(stationPoints,h0,x0,y0,K0,fig_num);

assert(length(x_arc(:,1))==length(stationPoints(:,1)));
assert(length(y_arc(:,1))==length(stationPoints(:,1)));
assert(length(x_arc(1,:))==1);
assert(length(y_arc(1,:))==1);

% Check start point
assert(isequal(round(x_arc(1,1),4),round(x0,4)));
assert(isequal(round(y_arc(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_arc(end,1),4),round(0,4)));
assert(isequal(round(y_arc(end,1),4),round(y0-radius,4)));

