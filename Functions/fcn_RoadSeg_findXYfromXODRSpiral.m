function [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s,l0,h0,x0,y0,K0,KF,varargin)
% fcn_RoadSeg_findXYfromXODRSpiral
% Script to determine the X,Y coordinates along a segment of a road defined
% as a "spiral" segment in the XODR standard. The spiral is plotted if a
% figure handle is provided

% The path can be expressed in parametric integral form: 
% x = int_0^s cos((KF-K0)/l0*s^2/2 + K0*s + h0) ds + x0 
% y = int_0^s sin((KF-K0)/l0*s^2/2 + K0*s + h0) ds + y0
% where (KF-K0)/l0*s^2/2 + K0*s is the included angle of the spiral over
% length s, l0 is the final distance along the path, and h0 is the initial
% angle. These integral expressions can be solved explicitly and a
% vectorized implementation of the calculations is formed, though the
% solution does depend on a numerical evaluation of the Fresnel integrals.
%
% FORMAT: 
%
%       [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s,l0,h0,x0,y0,K0,KF,{fig_num})
%
% INPUTS:
%
%       s: a vector of station coordinates along the spiral path at which to
%         compute the x,y coordinates. s is assumed to start at zero.
%       l0: a scalar parameter denoting the maximum extent of the spiral, in
%         station coordinates, relative to s = 0
%       h0: a scalar parameter denoting the heading of the spiral at the
%         s = 0 point
%       x0: a scalar parameter denoting the x-coordinate of the spiral at
%         the s = 0 point
%       y0: a scalar parameter denoting the y-coordinate of the spiral at
%         the s = 0 point
%       K0: a scalar parameter denoting the curvature of the spiral at
%         the s = 0 point
%       KF: a scalar parameter denoting the curvature of the spiral at
%         the s = l0 point
%
%       (OPTIONAL INPUTS): 
%       fig_num: a figure handle to plot the results into
%
% OUTPUTS:
%
%       x: a vector of x-coordinates corresponding to points along the
%         spiral at each of the s-coordinates
%       y: a vector of y-coordinates corresponding to points along the
%         spiral at each of the s-coordinates
%
% DEPENDENCIES:
%
%      None
%
% EXAMPLES:
%      
%       See the script: script_test_fcn_RoadSeg_findXYfromXODRSpiral.m for
%       a full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu 

% Revision history:
%     2022_03_20
%     -- wrote the code

flag_do_debug = 0; % Flag to plot the results for debugging
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _       
%  |_   _|                 | |      
%    | |  _ __  _ __  _   _| |_ ___ 
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |                  
%              |_| 
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 7 || nargin > 8
        error('Incorrect number of input arguments')
    end
end

%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define an intermediate variable that is used several times in the
% following computations to shorten the code and speed things up
z1 = (KF-K0)/(l0*2);
% Evaluate the integrals numerically to determine the x and y coordinates
% at each of the specified s coordinates
x = x0 + (sqrt(pi/2)*(cos(K0^2/(4*z1) - h0)*(fresnelc((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi))) - fresnelc(K0/(sqrt(z1)*sqrt(2*pi)))) + sin(K0^2/(4*z1) - h0)*(fresnels((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi))) - fresnels(K0/(sqrt(z1)*sqrt(2*pi))))))/sqrt(z1);
y = y0 + (sqrt(pi/2)*(sin(K0^2/(4*z1) - h0)*(fresnelc(K0/(sqrt(z1)*sqrt(2*pi))) - fresnelc((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi)))) + cos(K0^2/(4*z1) - h0)*(fresnels((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi))) - fresnels(K0/(sqrt(z1)*sqrt(2*pi))))))/sqrt(z1);

% Check to see if the user has provided a figure handle to plot into. If
% so, add the X,Y points to the plot
if 8 == nargin && isgraphics(varargin{1})
  figure(varargin{1})
  % Determine the hold state of the figure
  holdState = ishold;
  % Turn on hold for the purposes of adding the clothoid segment
  hold on
  % Plot the clothoid segment with a medium gray dotted line
  plot(x,y,'*-.','color',0.4*[1 1 1])
  % Restore the original hold state of the plot as necessary
  if 0 == holdState
    hold off
  end
end