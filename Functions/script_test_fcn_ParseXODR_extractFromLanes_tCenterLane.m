%% script_test_fcn_ParseXODR_extractFromLanes_tCenterLane
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromLanes_tCenterLane
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" written by C. Beal Questions or comments?
% sbrennan@psu.edu

% Revision history:
% 2024_03_21 - S. Brennan
% -- wrote the code

close all


%% workzone_100m_Lane_Offset
fig_num = 1;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);


%% Ex_Complex_Lane_Offset - 100 meters
fig_num = 2;
figure(fig_num)
clf

example_file = 'Ex_Complex_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);

%% Ex_Simple_Lane_Offset_Reversed - 100 meters
fig_num = 3;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset_Reversed.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);

%% Ex_Simple_Lane_Offset - 100 meters
fig_num = 4;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);

%% Ex_Simple_Lane_Gains
fig_num = 5;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Gains.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);


%% workzone_50m_curve_barrels
fig_num = 6;
figure(fig_num)
clf

example_file = 'workzone_50m_curve_barrels.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');




% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);

%% testTrack_outerTrack
fig_num = 7;
figure(fig_num)
clf

example_file = 'testTrack_outerTrack.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');




% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
[roadEndStation,~] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, -1);
lanesStructure = current_road.lanes;
stationPoints = (0:0.1:roadEndStation)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, fig_num);

% Check lengths - should have same length as stationPoints and 1 column
assert(length(transverseCenterOffsets(:,1))==length(stationPoints));
assert(length(transverseCenterOffsets(1,:))==1);