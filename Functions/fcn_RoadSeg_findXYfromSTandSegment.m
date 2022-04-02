function [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromSTandSegment(geomElement,sPts,tPts)
% fcn_RoadSeg_findXYfromSTandSegment 
% Wrapper function to call the findXYfromST function with the appropriate
% arguments based on the XODR road geometry element being referenced
%
% FORMAT:
%
%       [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromSTandSegment(geomElement,sPts,tPts)
%
% INPUTS:
%
%       geomElement: a portion of an XODR map containing a single road
%         geometry element and all of its child elements
%       sPts: a vector of s coordinates for points at which to determine
%         the X,Y coordinates
%       tPts: a vector of t coordinates for points at which to determine
%         the X,Y coordinates
%
% OUTPUTS:
%
%       xPts: a vector of x coordinates for points at which the s and t
%         coordinates are provided as input
%       yPts: a vector of y coordinates for points at which the s and t
%         coordinates are provided as input
%       hPts: a vector of headings for points at which the s and t
%         coordinates are provided as input
%
%
% DEPENDENCIES:
%
%      fcn_RoadSeg_findXYfromST
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_parsingProcess.m for
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

if nargin > 0
  if ~ischar(varargin{1})
    error('Input argument is not a string.');
  else
    fullPath = varargin{1};
  end
else
  [filename,pathname] = uigetfile('.xodr','Choose an ASAM OpenDrive XML file to parse.');
  fullPath = fullfile(pathname,filename);
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

% Enumerate some constants for later convenience and code readability
E = 1; N = 2;

% Get the geometry information for the geometry segment within which the
% object is located
p0 = [str2double(geomElement.Attributes.x), str2double(geomElement.Attributes.y)];
h0 = str2double(geomElement.Attributes.hdg);
l0 = str2double(geomElement.Attributes.length);
s0 = str2double(geomElement.Attributes.s);

% Determine the type of road geometry element is being referenced, and call
% the function to determine the X,Y coordinates from the S,T coordinates
% with the proper arguments
if isfield(geomElement,'line')
  [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromST('line',p0(E),p0(N),h0,s0,l0,sPts,tPts);
elseif isfield(geomElement,'arc')
  K0 = str2double(geomElement.arc.Attributes.curvature);
  [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromST('arc',p0(E),p0(N),h0,s0,l0,sPts,tPts,K0);
elseif isfield(geomElement,'spiral')
  K0 = str2double(geomElement.spiral.Attributes.curvStart);
  KF = str2double(geomElement.spiral.Attributes.curvEnd);
  [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromST('spiral',p0(E),p0(N),h0,s0,l0,sPts,tPts,K0,KF);
else
  fprintf(1,'Road segment type not handled by fcn_RoadSeg_findXYfromSTandSegment()\n');
end