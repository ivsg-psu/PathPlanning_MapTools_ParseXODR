function [x,y,h] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,varargin)
% fcn_RoadSeg_findXYfromST
% Script to determine the X,Y and heading coordinates along a segment of a
% road defined in the XODR standard. Unlike the arc and spiral specific
% functions in this library, this function accommodates t coordinate inputs
% to calculate coordinates for points where the locations are offset from
% the path center line
%
% FORMAT:
%
%       [x,y,h] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,varargin)
%
% INPUTS:
%
%       geomtype: a string containing 'line', 'arc', or 'spiral' to denote
%         the type of path and therefore the appropriate computation
%       x0: a scalar parameter denoting the x-coordinate of the path at
%         the s = 0 point
%       y0: a scalar parameter denoting the y-coordinate of the path at
%         the s = 0 point
%       h0: a scalar parameter denoting the heading of the path at the
%         s = 0 point
%       s0: a scalar parameter denoting the start point of the path in s
%         coordinates
%       l0: a scalar parameter denoting the maximum extent of the path, in
%         station coordinates, relative to s = 0
%       s: a vector of station coordinates along the path at which to
%         compute the x,y coordinates. s is NOT assumed to start at zero.
%       t: a vector of station coordinates perpendicular to the path at
%         which to compute the x,y coordinates.
%
%       (VARIABLE INPUTS):
%       K0: a scalar parameter denoting the curvature of the arc or the
%         curvature at the start of a spiral
%       KF: a scalar parameter denoting the curvature of the arc or the
%         curvature at the end of a spiral
%
% OUTPUTS:
%
%       x: a vector of x-coordinates corresponding to points along the
%         path at each of the s-coordinates
%       y: a vector of y-coordinates corresponding to points along the
%         path at each of the s-coordinates
%       h: a vector of headings corresponding to points along the
%         path at each of the s-coordinates
%
% DEPENDENCIES:
%
%      fcn_RoadSeg_findXYfromXODRSpiral
%      fcn_RoadSeg_findXYfromXODRArc
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_findXYfromST.m for
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
  switch geomType
    case 'line'
      if flag_check_inputs && nargin > 8
        warning('Ignoring extra arguments for line geometry')
      end
    case 'arc'
      if nargin < 9
        error('Not enough input arguments to define arc geometry')
      elseif nargin > 9
        warning('Ignoring extra arguments for arc geometry')
      end
      % Extract the curvature of the arc
      K0 = varargin{1};
    case 'spiral'
      if nargin < 10
        error('Not enough input arguments to define spiral geometry')
      elseif nargin > 10
        warning('Ignoring extra arguments for spiral geometry')
      end
      % Extract the initial and final curvatures for the spiral
      K0 = varargin{1};
      KF = varargin{2};
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

switch geomType
  case 'line'
    % Add together the contribution to the x position of the initial x,y
    % coordinate, the travel down the road line, and the offset from the
    % centerline of the line (defined as the heading + pi/2) given the s,t
    % coordinate system
    x = (s(:)-s0).*cos(h0) + t(:).*cos(h0+pi/2) + x0;
    y = (s(:)-s0).*sin(h0) + t(:).*sin(h0+pi/2) + y0;
    % The heading stays the same along all points of a line segment, so
    % return a vector of the same size as x and y, populated with h0
    h = h0*ones(length(s),1);
    
  case 'arc'
    % Find the points along the path assuming t = 0
    [x,y] = fcn_RoadSeg_findXYfromXODRArc(s(:)-s0,h0,x0,y0,K0);
    % Compute the heading at the specified points
    h = K0*(s(:)-s0) + h0;
    % Offset the x and y coordinates by the projection along t (which is
    % aligned at the heading plus pi/2)
    x = x + t(:).*cos(h+pi/2);
    y = y + t(:).*sin(h+pi/2);
    
  case 'spiral'
    % Find the point along the path with t = 0
    [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s(:)-s0,l0,h0,x0,y0,K0,KF);
    % Compute the heading at the specified points
    h = (KF-K0)/l0*(s(:)-s0).^2/2 + K0*s + h0;
    % Offset the x and y coordinates by the projection along t (which is
    % aligned at the heading plus pi/2)
    x = x + t(:).*cos(h+pi/2);
    y = y + t(:).*sin(h+pi/2);
end