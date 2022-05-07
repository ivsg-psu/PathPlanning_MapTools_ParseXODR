function [sPts,tLeft,tCenter,tRight] = fcn_RoadSeg_extractLaneGeometry(ODRRoad,maxPlotGap)
% fcn_RoadSeg_extractLaneGeometry
% Extracts the lane geometry defined in an XODR file
%
% FORMAT:
%
%       fcn_RoadSeg_extractLaneGeometry(ODRStruct,maxPlotGap)
%
% INPUTS:
%
%      ODRStruct: a nested structure containing the XDOR map elements
%      maxPlotGap: a scalar parameter defining the maximum distance (in
%         meters) between adjacent plot points (to make sure that any
%         curves have sufficient definition)
%
% OUTPUTS:
%
%      tLeft: a matrix of t coordinates associated with lane boundaries to
%         the left of the center lane line of the road
%      tCenter: a vector of t coordinates associated with the center lane
%         line of the road
%      tRight: a matrix of t coordinates associated with lane boundaries to
%         the right of the center lane line of the road
%
% DEPENDENCIES:
%
%      fcn_RoadSeg_findXYfromSTandSegment from the ParseXODR library
%      fcn_RoadSeg_findXYfromST from the ParseXODR library (second-level)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_extractLaneGeometry.m for a
%       full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu

% Revision history:
%     2022-05-04
%     -- wrote the code
%     2022-05-07
%     -- debugged the cumsum approach at the end to take into account the
%     unsorted lanes that occur when lanes disappear/appear

flag_do_debug = 1; % Flag to plot the results for debugging
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
  if nargin < 2 || nargin > 2
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

% Create a series of points for plotting, taking into account the
% maximum gap allowed in the series of points. This is the set of station
% points on the reference line for which the reference line geometry as
% well as all of the lanes will be calculated. Note that these
% s-coordinates form a grid in the s,t space upon which all of the x,y
% points for continuous features such as lanes, etc. will be calculated
lRoad = str2double(ODRRoad.Attributes.length);
Npts = ceil(lRoad/maxPlotGap);
sPts = linspace(0,lRoad,Npts)';

% Preallocate a t-coordinate vector for the center lane (which is
% different than the reference line). This will be zero when the center
% lane is not offset, but offsets may shift it. All other lane positions
% are referenced to this position
tCenter = zeros(Npts,1);
% Preallocate some left and right width matrices with NaNs. These will be
% filled with widths of lanes (in sequence, building away from the
% center lane)
tLeft = nan(length(sPts),10);
tRight = nan(length(sPts),10);

% Set up a cell array to store the indices of the station points associated
% with each lane segment
stationIndices = {};

if flag_do_debug
  fprintf(1,'Starting lane extraction routine for road %s\n',ODRRoad.Attributes.id);
end

% Determine whether there are any offsets to the center lane in the
% current road
if isfield(ODRRoad.lanes,'laneOffset')
  % Determine the number of offset descriptors in the road
  Noffsets = length(ODRRoad.lanes.laneOffset);
  % Iterate through all of the offset descriptors
  for laneOffsetIdx = 1:Noffsets
    % Determine the start point of the offset descriptor
    offsetStart = str2double(ODRRoad.lanes.laneOffset{laneOffsetIdx}.Attributes.s);
    % Determine the end point of the offset descriptor
    if laneOffsetIdx == Noffsets
      % If this is the last offset, it must run to the end of the road
      offsetEnd = str2double(ODRRoad.Attributes.length);
    else
      % If this is not the last offset, it runs until the next offset
      % descriptor
      offsetEnd = str2double(ODRRoad.lanes.laneOffset{laneOffsetIdx+1}.Attributes.s);
    end
    % Determine which of the indices in the s-direction are affected by
    % this offset descriptor
    affectedIdxs = find(sPts >= offsetStart & sPts <= offsetEnd);
    % Grab the properties of the offset
    a = str2double(ODRRoad.lanes.laneOffset{laneOffsetIdx}.Attributes.a);
    b = str2double(ODRRoad.lanes.laneOffset{laneOffsetIdx}.Attributes.b);
    c = str2double(ODRRoad.lanes.laneOffset{laneOffsetIdx}.Attributes.c);
    d = str2double(ODRRoad.lanes.laneOffset{laneOffsetIdx}.Attributes.d);
    % Now calculate the t coordinate of the center line at each of the
    % affected points
    ds = sPts(affectedIdxs)-offsetStart;
    tCenter(affectedIdxs) = a + b*ds + c*ds.^2 + d*ds.^3;
    if flag_do_debug
      fprintf(1,'Offset center lane from stations %d to %d\n',offsetStart,offsetEnd);
    end
  end
end

% Determine the number of lane sections in the current road (there should
% always be at least one)
NlaneSegs = length(ODRRoad.lanes.laneSection);
% Initialize a flag to determine when the first definition of a left lane
% has been reached
leftLanesStarted = 0;
% Initialize a flag to determine when the first definition of a right lane
% has been reached
rightLanesStarted = 0;
% Iterate through all of the lane sections to gather the lane linkage
% information
for laneSecIdx = 1:NlaneSegs
  if isfield(ODRRoad.lanes.laneSection{laneSecIdx},'left')
    % Determine the number of left lanes there are in the current section
    NleftLanes = length(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane);
    % Initialize the current row of the laneSecIdx matrix with
    % incrementally counting lane IDs
    if ~leftLanesStarted
      leftLanesStarted = 1;
      % Initialize first with NaNs for all of the sections where there were
      % no left lane definitions
      laneLinksLeft = nan(laneSecIdx,NleftLanes);
      % Initialize the current section with incrementally increasing lane
      % IDs, working from smallest to largest (from center lane outward)
      laneLinksLeft(laneSecIdx,:) = 1:NleftLanes;
      % Code to run only for lane segments following the first definition of
      % left lanes
    else
      % Initialize any new rows with NaN values, including the one for the
      % current section
      laneLinksLeft = [laneLinksLeft;...
        nan(laneSecIdx - size(laneLinksLeft,1),size(laneLinksLeft,2))];
      % Do a double-check to make sure that the right number of NaNs were
      % added
      if size(laneLinksLeft,1) ~= laneSecIdx
        error('Addition of NaN rows did not produce consistent matrix size');
      end
      % Iterate through each of the left lanes in the current section,
      for leftLaneIdx = 1:NleftLanes
        % Grab the current lane ID
        currLane = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.Attributes.id);
        % Check to see if this lane has a predecessor
        if isfield(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx},'link')  && isfield(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.link,'predecessor')
          % Get the predecessor of the current lane
          currPred = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.link.predecessor.Attributes.id);
          % Insert the current lane ID into the column matching that of its
          % predecessor
          laneLinksLeft(laneSecIdx,currPred == laneLinksLeft(laneSecIdx-1,:)) = currLane;
        else
          % This is a new lane starting, so handle as such by adding a new
          % column on the end of the matrix and adding the current lane ID
          % as the first entry, starting in the current row
          laneLinksLeft = [laneLinksLeft nan(laneSecIdx,1)];
          laneLinksLeft(end,end) = currLane;
        end
      end
    end
  end
  if isfield(ODRRoad.lanes.laneSection{laneSecIdx},'right')
    % Determine the number of right lanes there are in the current section
    NrightLanes = length(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane);
    % Initialize the current row of the laneSecIdx matrix with
    % incrementally counting lane IDs
    if ~rightLanesStarted
      rightLanesStarted = 1;
      % Initialize first with NaNs for all of the sections where there were
      % no right lane definitions
      laneLinksRight = nan(laneSecIdx,NrightLanes);
      % Initialize the current section with incrementally increasing lane
      % IDs, working from smallest to largest (from center lane outward)
      laneLinksRight(laneSecIdx,:) = 1:NrightLanes;
      % Code to run only for lane segments following the first definition of
      % right lanes
    else
      % Initialize any new rows with NaN values, including the one for the
      % current section
      laneLinksRight = [laneLinksRight;...
        nan(laneSecIdx - size(laneLinksRight,1),size(laneLinksRight,2))];
      if size(laneLinksRight,1) ~= laneSecIdx
        error('Addition of NaN rows did not produce consistent matrix size');
      end
      % Iterate through each of the right lanes in the current section,
      for rightLaneIdx = 1:NrightLanes
        % Grab the current lane ID
        currLane = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.Attributes.id);
        % Check to see if this lane has a predecessor
        if isfield(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx},'link')  && isfield(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.link,'predecessor')
          % Get the predecessor of the current lane
          currPred = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.link.predecessor.Attributes.id);
          % Insert the current lane ID into the column matching that of its
          % predecessor
          laneLinksRight(laneSecIdx,-currPred == laneLinksRight(laneSecIdx-1,:)) = -currLane;  % negative due to right lane ID convention
        else
          % This is a new lane starting, so handle as such by adding a new
          % column on the end of the matrix and adding the current lane ID
          % as the first entry, starting in the current row
          laneLinksRight = [laneLinksRight nan(laneSecIdx,1)];
          laneLinksRight(end,end) = -currLane; % negative due to right lane ID convention
        end
      end
    end
  end
end

% Iterate through all of the lane sections
for laneSecIdx = 1:NlaneSegs
  % Determine the start and end points of the lane section
  laneSecStart = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.Attributes.s);
  % The station coordinate of the lane section end will be the start of
  % the next lane section, unless it's the last lane section. If that's
  % the case, use the station coordinate of the end of the road (the
  % length) to determine the end of the section
  if laneSecIdx == NlaneSegs
    laneSecEnd = str2double(ODRRoad.Attributes.length);
  else
    laneSecEnd = str2double(ODRRoad.lanes.laneSection{laneSecIdx+1}.Attributes.s);
  end
  % Check for child lanes not in a left, center, or right container
  if isfield(ODRRoad.lanes.laneSection{laneSecIdx},'lane')
    if flag_do_debug
      fprintf(1,'In road %s, lane segment %d contains a lane outside of the <left>,<center>, and <right> containers, ignoring it.\n',...
        ODRRoad.Attributes.id,laneSecIdx)
    end
  end

  if isfield(ODRRoad.lanes.laneSection{laneSecIdx},'left')
    % Iterate through all of the left lane elements
    NleftLanes = length(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane);
    for leftLaneIdx = 1:NleftLanes
      % Get the lane index from the XODR structure
      laneID = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.Attributes.id);
      laneDataIndex = find(laneLinksLeft(laneSecIdx,:) == laneID);
      if isempty(laneDataIndex)
        error('Lane index not found');
      end
      if flag_do_debug
        fprintf(1,'   Processing lane number %d in lane section %d\n',laneID,laneSecIdx);
      end
      Nwidths = length(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width);
      if ~iscell(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width)
        ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width = {ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width};
      end
      for widthIdx = 1:Nwidths
        a = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width{widthIdx}.Attributes.a);
        b = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width{widthIdx}.Attributes.b);
        c = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width{widthIdx}.Attributes.c);
        d = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width{widthIdx}.Attributes.d);
        sOffset = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width{widthIdx}.Attributes.sOffset);
        widthStart = laneSecStart + sOffset;
        if widthIdx == Nwidths
          widthEnd = laneSecEnd;
        else
          widthEnd = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.left.lane{leftLaneIdx}.width{widthIdx+1}.Attributes.sOffset);
        end
        % Determine which of the indices in the s-direction are affected by
        % this offset descriptor
        stationIndices{laneSecIdx} = find(sPts >= widthStart & sPts <= widthEnd);
        % Now calculate the t coordinate of the left line at each of the
        % affected points
        ds = sPts(stationIndices{laneSecIdx})-widthStart;
        tLeft(stationIndices{laneSecIdx},laneDataIndex) = a + b*ds + c*ds.^2 + d*ds.^3;
        if flag_do_debug
          fprintf(1,'   Determined lane %d edge from stations %d to %d\n',laneID,widthStart,widthEnd);
        end
      end
    end
  end
  if isfield(ODRRoad.lanes.laneSection{laneSecIdx},'right')
    % Iterate through all of the right lane elements
    NrightLanes = length(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane);
    for rightLaneIdx = 1:NrightLanes
      % Get the lane index from the XODR structure
      laneID = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.Attributes.id);
      laneDataIndex = find(laneLinksRight(laneSecIdx,:) == -laneID); % negative here due to the sign of the lanes on the right
      if isempty(laneDataIndex)
        error('Lane index not found');
      end
      if flag_do_debug
        fprintf(1,'   Processing lane number %d in lane section %d\n',laneID,laneSecIdx);
      end
      Nwidths = length(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width);
      if ~iscell(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width)
        ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width = {ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width};
      end
      for widthIdx = 1:Nwidths
        a = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width{widthIdx}.Attributes.a);
        b = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width{widthIdx}.Attributes.b);
        c = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width{widthIdx}.Attributes.c);
        d = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width{widthIdx}.Attributes.d);
        sOffset = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width{widthIdx}.Attributes.sOffset);
        widthStart = laneSecStart + sOffset;
        if widthIdx == Nwidths
          widthEnd = laneSecEnd;
        else
          widthEnd = str2double(ODRRoad.lanes.laneSection{laneSecIdx}.right.lane{rightLaneIdx}.width{widthIdx+1}.Attributes.sOffset);
        end
        % Determine which of the indices in the s-direction are affected by
        % this offset descriptor
        stationIndices{laneSecIdx} = find(sPts >= widthStart & sPts <= widthEnd);
        % Now calculate the t coordinate of the left line at each of the
        % affected points
        ds = sPts(stationIndices{laneSecIdx})-widthStart;
        tRight(stationIndices{laneSecIdx},laneDataIndex) = -(a + b*ds + c*ds.^2 + d*ds.^3);
        if flag_do_debug
          fprintf(1,'   Determined lane %d edge from stations %d to %d\n',laneID,widthStart,widthEnd);
        end
      end
    end
  end
end

% Trim away any columns of the lane data matrices where there is no lane
% geometry at all
tLeft = tLeft(:,1 == any(~isnan(tLeft)));
tRight = tRight(:,1 == any(~isnan(tRight)));

% Sort so that columns always increase in number by swapping columns (is
% there any case where this breaks?)
% OR
% Do the cumulative sum in the columns, but not by left to right but by
% numerical order

% Example, for Ex_Simple-Lane-Offset-Reversed
% tLeft = [tLeft(:,1) tLeft(:,3) tLeft(:,2)];
% tRight = [tRight(:,1) tRight(:,4) tRight(:,2) tRight(:,3)];
for i = 1:length(stationIndices)
  % This doesn't work, need to correlate the laneLinksLeft with the
  % affected indices in the tLeft matrix
  [~,sortInds] = sort(laneLinksLeft(i,:));
  tLeft(stationIndices{i},sortInds) = cumsum(tLeft(stationIndices{i},sortInds),2,'includenan');
  % This doesn't work, need to correlate the laneLinksRight with the
  % affected indices in the tRight matrix
  [~,sortInds] = sort(laneLinksRight(i,:));
  tRight(stationIndices{i},sortInds) = cumsum(tRight(stationIndices{i},sortInds),2,'includenan');
end
tLeft = tLeft + tCenter;
tRight = tRight + tCenter;

% Use a cumulative sum in the outward direction from the center lane to
% determine the position of the outer lane boundary for each lane, adding
% on any shift of the center lane
%tLeft = cumsum(tLeft,2,'omitnan') + tCenter;
%tRight = cumsum(tRight,2,'omitnan') + tCenter;

% Provide some indication of completion
if flag_do_debug
  fprintf(1,'Completed lane extraction routine\n');
end
