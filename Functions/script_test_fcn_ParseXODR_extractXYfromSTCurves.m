%% script_test_fcn_ParseXODR_extractXYfromSTCurves.m
% A script to test the execution of fcn_ParseXODR_extractXYfromSTCurves

% This script was originally written by C. Beal, maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_04_02 - C. Beal
% -- wrote the code
% 2022_04_02 - S. Brennan
% -- wrote the code

close all;

%% Test the line functionality
fig_num = 1;
figure(fig_num);
clf;


% Create a test arc for the function

x0 = 5;
y0 = 0;
h0 = pi/2;
s0 = 0; % Not used
l0 = 0; % Not used
N_points = 20;
stationPoints = linspace(0,10,N_points)';
t = linspace(-3,0,length(stationPoints))';


initial_values = [x0 y0 h0 s0 l0];
St_coordinates = [stationPoints, t];

[x_line,y_line] = fcn_ParseXODR_extractXYfromSTCurves('line',initial_values, St_coordinates, [], fig_num);

assert(length(x_line(:,1))==length(stationPoints(:,1)));
assert(length(y_line(:,1))==length(stationPoints(:,1)));
assert(length(x_line(1,:))==1);
assert(length(y_line(1,:))==1);

% Check start point
assert(isequal(round(x_line(1,1),4),round(x0+3,4)));
assert(isequal(round(y_line(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_line(end,1),4),round(5,4)));
assert(isequal(round(y_line(end,1),4),round(10,4)));


%% Test the arc functionality
fig_num = 2;
figure(fig_num);
clf;

% Create a test arc for the function
radius = 20;
x0 = radius;
y0 = radius/2;
h0 = pi/2;
s0 = 0; % Not used
l0 = 0; % Not used
K0 = 1/radius;
KF = 0; % Not used
N_points = 20;
stationPoints = linspace(0,((2*pi - h0)*radius),N_points)';
t = linspace(-3,0,length(stationPoints))';


initial_values = [x0 y0 h0 s0 l0];
St_coordinates = [stationPoints, t];
curve_parameters = [K0 KF];

[x_arc,y_arc] = fcn_ParseXODR_extractXYfromSTCurves('arc',initial_values, St_coordinates, curve_parameters, fig_num);

assert(length(x_arc(:,1))==length(stationPoints(:,1)));
assert(length(y_arc(:,1))==length(stationPoints(:,1)));
assert(length(x_arc(1,:))==1);
assert(length(y_arc(1,:))==1);

% Check start point
assert(isequal(round(x_arc(1,1),4),round(x0+3,4)));
assert(isequal(round(y_arc(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_arc(end,1),4),round(0,4)));
assert(isequal(round(y_arc(end,1),4),round(y0-radius,4)));


%% Test the spiral functionality
fig_num = 3;
figure(fig_num);
clf;

% Create a test arc for the function
radius = 20;
x0 = radius;
y0 = radius/2;
h0 = pi/2;
s0 = 0;
l0 = 100;

K0 = 0;
KF = 1/radius;

N_points = 20;
stationPoints = linspace(0,((2*pi - h0)*radius),N_points)';
t = linspace(-3,0,length(stationPoints))';


initial_values = [x0 y0 h0 s0 l0];
St_coordinates = [stationPoints, t];
curve_parameters = [K0 KF];

[x_spiral,y_spiral] = fcn_ParseXODR_extractXYfromSTCurves('spiral',initial_values, St_coordinates, curve_parameters, fig_num);

assert(length(x_spiral(:,1))==length(stationPoints(:,1)));
assert(length(y_spiral(:,1))==length(stationPoints(:,1)));
assert(length(x_spiral(1,:))==1);
assert(length(y_spiral(1,:))==1);

% Check start point
assert(isequal(round(x_spiral(1,1),4),round(23.0000,4)));
assert(isequal(round(y_spiral(1,1),4),round(y0,4)));

% Check end point
assert(isequal(round(x_spiral(end,1),4),round(-28.7316,4)));
assert(isequal(round(y_spiral(end,1),4),round(67.2521,4)));


