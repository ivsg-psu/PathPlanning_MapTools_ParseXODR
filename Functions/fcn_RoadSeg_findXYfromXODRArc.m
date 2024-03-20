function [x,y] = fcn_RoadSeg_findXYfromXODRArc(s,h0,x0,y0,K0,varargin)
% fcn_RoadSeg_findXYfromXODRArc
% Script to determine the X,Y coordinates along a segment of a road defined
% as an "arc" segment in the XODR standard. The arc is plotted if a figure
% handle is provided

% The path can be expressed in parametric integral form:
% x = int_0^s cos(K0*s + h0) ds + x0
% y = int_0^s sin(K0*s + h0) ds + y0
% where K0*s is the included angle of the arc length s, h0 is the initial
% angle. These integral expressions can be solved explicitly and a
% vectorized implementation of the calculations is easily formed.
%
% FORMAT: 
%
%       [x,y] = fcn_RoadSeg_findXYfromXODRArc(s,h0,x0,y0,K0,{fig_num})
%
% INPUTS:
%
%       s: a vector of station coordinates along the arc path at which to
%         compute the x,y coordinates. s is assumed to start at zero.
%       l0: a scalar parameter denoting the maximum extent of the arc, in
%         station coordinates, relative to s = 0
%       h0: a scalar parameter denoting the heading of the arc at the
%         s = 0 point
%       x0: a scalar parameter denoting the x-coordinate of the arc at
%         the s = 0 point
%       y0: a scalar parameter denoting the y-coordinate of the arc at
%         the s = 0 point
%       K0: a scalar parameter denoting the curvature of the arc
%
%       (OPTIONAL INPUTS): 
%       fig_num: a figure handle to plot the results into
%
% OUTPUTS:
%
%       x: a vector of x-coordinates corresponding to points along the
%         arc at each of the s-coordinates
%       y: a vector of y-coordinates corresponding to points along the
%         arc at each of the s-coordinates
%
% DEPENDENCIES:
%
%      None
%
% EXAMPLES:
%      
%       See the script: script_test_fcn_RoadSeg_findXYfromXODRArc.m for
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
  if nargin < 5
    error('Not enough input arguments to determine the arc segment geometry');
  elseif nargin > 6
    warning('Extra arguments ignored in determining arc segment geometry');
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

% Compute the x and y coordinates from the provided vector of s coordinates
x = ( sin(K0*s(:) + h0) - sin(h0))/K0 + x0;
y = (-cos(K0*s(:) + h0) + cos(h0))/K0 + y0;

% const double angle_at_s = (s - s0) * curvature - M_PI / 2;
% const double r = 1 / curvature;
% const double xs = r * (std::cos(hdg0 + angle_at_s) - std::sin(hdg0)) + x0;
% const double ys = r * (std::sin(hdg0 + angle_at_s) + std::cos(hdg0)) + y0;

% Check to see if the user has provided a figure handle to plot into. If
% so, add the X,Y points to the plot
if 6 == nargin && isgraphics(varargin{1})
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