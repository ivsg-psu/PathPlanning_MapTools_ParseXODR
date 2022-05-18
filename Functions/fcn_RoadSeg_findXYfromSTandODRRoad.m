function [xPts,yPts] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,tPts)
% fcn_RoadSeg_findXYfromSTandODRRoad Wrapper function to call the
% findXYfromSTandSegment function with the appropriate arguments based on
% the XODR road being referenced
%
% FORMAT:
%
%       [xPts,yPts] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,tPts)
%
% INPUTS:
%
%       ODRRoad: a portion of an XODR map containing a single road and all
%         of its child elements
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
%
%
% DEPENDENCIES:
%
%      fcn_RoadSeg_findXYfromSTandSegment
%      fcn_RoadSeg_findXYfromST (second-level)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_findXYfromSTandODRRoad.m
%       for a full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu

% Revision history:
%     2022_05_07
%     -- wrote the code

flag_do_debug = 0; % Flag to plot the results for debugging
flag_check_inputs = 0; % Flag to perform input checking

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

if flag_check_inputs
  if nargin < 3 || nargin > 3
    error('Wrong number of input arguments to fcn_RoadSeg_findXYfromSTandODRRoad.m.');
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

xPts = nan(size(sPts));
yPts = nan(size(sPts));

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(ODRRoad.planView.geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
  % Determine the starting and ending points of the current road segment in
  % s coordinates
  segStart = str2double(ODRRoad.planView.geometry{segIdx}.Attributes.s);
  segEnd = segStart + str2double(ODRRoad.planView.geometry{segIdx}.Attributes.length);
  
  % Determine the indices of the lane station points that lie within each
  % road geometry segment
  if segIdx == Nsegments
    sInds = find(sPts >= segStart & sPts <= segEnd);
  else
    sInds = find(sPts >= segStart & sPts < segEnd);
  end
  
  % Convert the path coordinates to obtain the (X,Y) coordinates of each of
  % the calculated lane boundaries
  [xPts(sInds),yPts(sInds)] = fcn_RoadSeg_findXYfromSTandSegment(ODRRoad.planView.geometry{segIdx},sPts(sInds),tPts(sInds));
end