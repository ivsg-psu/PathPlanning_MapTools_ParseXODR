function [RoadSegmentStations,LaneOffsetStations,LaneSectionStations] = ...
  fcn_RoadSeg_extractXODRSegments(ODRRoad)
% fcn_RoadSeg_extractXODRSegments
% A function to extract the various sizes of the OpenDRIVE XODR road system
% description as well as the station coordinates of various changes in the
% road geometries
%
% FORMAT:
%
%       [RoadSegmentStations,LaneOffsetStations,LaneSectionStations] = ...
%            fcn_RoadSeg_extractXODRSegments(ODRRoad)
%
% INPUTS:
%
%       ODRRoad: a nested structure containing a single XDOR road element
%
% OUTPUTS:
%
%       RoadSegmentStations: a vector of all of the start/end s-coordinates
%           of the geometry elements defined for the given road in the XODR
%           file
%       LaneOffsetStations: a vector of all of the start/end s-coordinates
%           of the lane offset elements defined for the given road in the
%           XODR file
%       LaneSectionStations: a vector of all of the start/end s-coordinates
%           of the lane section elements defined for the given road in the
%           XODR file
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_extractXODRSegments.m for
%       a full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu

% Revision history:
%     2022_05_10
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
  if nargin < 1
    error('Incorrect number of input arguments');
  end
  if ~isfield(ODRRoad,'planView')
    error('OpenDRIVE road structure malformed, does not contain any geometry elements');
  end
  if ~isfield(ODRRoad,'lanes')
    error('OpenDRIVE road structure malformed, does not contain any lane elements');
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

% Determine the end point of the road
RoadEndStation = str2double(ODRRoad.Attributes.length);
% Determine the number of geometry elements in the reference line of the
% current road
NgeomElems = length(ODRRoad.planView.geometry);
% Preallocate a vector for the stations of the geometry element bounds
RoadSegmentStations = zeros(NgeomElems+1,1);
% Set the end station
RoadSegmentStations(end) = RoadEndStation;
% Iterate through the geometry and pull out the start station
for geomInd = 1:NgeomElems
  RoadSegmentStations(geomInd) = str2double(ODRRoad.planView.geometry{geomInd}.Attributes.s);
end

% Determine whether there are any offsets to the center lane in the
% current road
if isfield(ODRRoad.lanes,'laneOffset')
  % Determine the number of lane offset descriptors in the road
  NlaneOffsets = length(ODRRoad.lanes.laneOffset);
  % Preallocate a vector for the stations of the geometry element bounds
  LaneOffsetStations = zeros(NlaneOffsets+1,1);
  % Set the end station
  LaneOffsetStations(end) = RoadEndStation;
  % Iterate through all of the offset descriptors
  for laneOffsetInd = 1:NlaneOffsets
    % Determine the start point of the offset descriptor
    LaneOffsetStations(laneOffsetInd) = str2double(ODRRoad.lanes.laneOffset{laneOffsetInd}.Attributes.s);
  end
else
  LaneOffsetStations = [0; RoadEndStation];
end

% Determine the number of lane offset descriptors in the road
NlaneSections = length(ODRRoad.lanes.laneSection);
% Preallocate a vector for the stations of the geometry element bounds
LaneSectionStations = zeros(NlaneSections+1,1);
% Set the end station
LaneSectionStations(end) = RoadEndStation;
% Iterate through all of the offset descriptors
for laneSectionInd = 1:NlaneSections
  % Determine the start point of the offset descriptor
  LaneSectionStations(laneSectionInd) = str2double(ODRRoad.lanes.laneSection{laneSectionInd}.Attributes.s);
end

if flag_do_debug
  fprintf(1,'Section determination complete\n');
end