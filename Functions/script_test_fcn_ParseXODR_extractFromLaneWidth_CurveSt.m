%% script_test_fcn_ParseXODR_extractFromLaneWidth_CurveSt
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromLaneWidth_CurveSt
%
% This script was written by S. Brennan 
% Questions or comments? sbrennan@psu.edu
%
% Revision history:
% 2024_03_18 - S. Brennan
% -- wrote the code
% 2024_03_30 - S. Brennan
% -- fixed assertions
close all


%% workzone_100m_Lane_Offset
fig_num = 1;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};


 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));


%% Ex_Complex_Lane_Offset
fig_num = 2;
figure(fig_num)
clf

example_file = 'Ex_Complex_Lane_Offset.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};




 



 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));

%% Ex_Simple_Lane_Offset_Reversed
fig_num = 3;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset_Reversed.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};




 



 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));

%% Ex_Simple_Lane_Offset
fig_num = 4;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};




 



 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));
%% Ex_Simple_Lane_Gains
fig_num = 5;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Gains.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};




 



 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));

%% workzone_50m_curve_barrels
fig_num = 6;

example_file = 'workzone_50m_curve_barrels.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};




 



 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));

%% testTrack_outerTrack
fig_num = 7;
figure(fig_num)
clf

example_file = 'testTrack_outerTrack.xodr';

% Call the export function
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Grab road info
ODRRoad = ODRStruct.OpenDRIVE.road{1};
[lengthOfRoad,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);
minPlotGap = 0.2; % (m)

% Set up the station points to calculate results
Npts = ceil(lengthOfRoad/minPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Grab lane info
lanesStructure = ODRRoad.lanes;
% transverseCenterLaneOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);




% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

 % Get the t-coordinates of this particular lane
 sideString = 'left';
 current_lane = currentLaneSection.(sideString).lane{1};




 



 % Get the current width structure
 current_width = current_lane.width;

 % Use width structure to calculate the lane edge transverse
 % position
 [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationsInThisLaneSection, laneSectionStations(1,:), fig_num);

% Check results
% Do the lengths make sense?
assert(length(tLaneEdge(:,1))==length(stationsInThisLaneSection));
assert(length(tLaneEdge(:,1))==length(outputStationIndices));
assert(length(tLaneEdge(1,:))==1);
assert(length(outputStationIndices(1,:))==1);
assert(min(outputStationIndices)>=1);
assert(max(outputStationIndices)<=length(stationPoints));