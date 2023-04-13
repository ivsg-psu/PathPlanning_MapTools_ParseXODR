% A script to test the execution of fcn_RoadSeg_findXYfromST

% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu 

% Revision history:
%     2022_04_02
%     -- wrote the code

%% Create a test arc for the function
h0 = 3*pi/4;
x0 = 9;
y0 = 2;
l0 = 100;
K0 = 1/25;
s0 = 0;
s = (s0:0.5:l0)';
t = linspace(-3,0,length(s));

% Create a new figure into which to plot the spiral results
fHand = figure;
clf
hold on
grid on
axis equal

% Run the function with the plotting enabled by sending in the figure
% handle
[x1,y1,h1] = fcn_RoadSeg_findXYfromST('arc',x0,y0,h0,s0,l0,s,0,K0);
 
% Plot the results returned from the function
figure(fHand)
plot(x1,y1,'k*-.')

%% Create a test spiral for the function
h0 = -3*pi/4;
x0 = 9;
y0 = 2;
l0 = 100;
K0 = -1/25;
KF = 0;
s0 = 0;
s = (s0:0.5:l0)';
t = linspace(1,4,length(s));

% Run the function without plotting
[x2,y2,h2] = fcn_RoadSeg_findXYfromST('spiral',x0,y0,h0,s0,l0,s,t,K0,KF);

% Plot the results returned from the function
figure(fHand)
plot(x2,y2,'r*-.')