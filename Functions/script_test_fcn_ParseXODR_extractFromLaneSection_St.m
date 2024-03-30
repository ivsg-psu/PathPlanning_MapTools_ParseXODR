%% script_test_fcn_ParseXODR_extractFromLaneSection_St
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromLaneSection_St
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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');

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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');

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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');

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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');

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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');

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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2);
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');

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
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Grab lane section info
currentLaneSection = lanesStructure.laneSection{1};
% What are the station limits for this lane section?
laneSectionStationLimits = laneSectionStations(1,:);

% Determine which of the indices in the s-direction are affected by
% this lane section, and update the station coordinates for this lane
% section
currentLaneSectionStationIndicies = find(stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2));
stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

% Gather the transverse coordinates for this lane section
tCurrentLaneSection = ...
    fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinkages(1,:), laneSectionStationLimits, fig_num);

% Check results
% Do the lengths make sense?
assert(length(tCurrentLaneSection(:,1))==length(stationsInThisLaneSection));
assert(length(tCurrentLaneSection(1,:))==length(laneLinkages(1,:)));

% Call the plotting function
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');