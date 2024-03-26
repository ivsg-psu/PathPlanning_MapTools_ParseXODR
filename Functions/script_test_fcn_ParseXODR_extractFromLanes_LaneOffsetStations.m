%% script_test_fcn_ParseXODR_extractFromLanes_LaneOffsetStations
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromLanes_LaneOffsetStations
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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 5 lane offset segments
assert(length(laneOffsetStations(:,1))==5);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));

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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 3 lane offset segments
assert(length(laneOffsetStations(:,1))==3);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));

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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 3 lane offset segments
assert(length(laneOffsetStations(:,1))==3);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));

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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 3 lane offset segments
assert(length(laneOffsetStations(:,1))==3);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));

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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 1 lane offset segments
assert(length(laneOffsetStations(:,1))==1);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));


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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');




% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 1 lane offset segments
assert(length(laneOffsetStations(:,1))==1);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));

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
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');




% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};
road_length = str2double(current_road.Attributes.length);
current_lanes = current_road.lanes;


% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(current_lanes, road_length, fig_num);

% Check lengths - this example has 1 lane offset segments
assert(length(laneOffsetStations(:,1))==1);
assert(length(laneOffsetStations(1,:))==2);

% Check values - segments should start at 0 and end at road length
assert(isequal(round(laneOffsetStations(1,1),4),round(0,4)));
assert(isequal(round(laneOffsetStations(end,2),4),round(road_length,4)));
