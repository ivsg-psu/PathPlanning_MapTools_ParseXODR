%% script_test_fcn_ParseXODR_extractFromLaneSection_St
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromLaneSection_St
%
% This script was written by S. Brennan 
% Questions or comments? sbrennan@psu.edu
%
% Revision history:
%     2024_03_18
%     -- wrote the code

close all


%% workzone_100m_Lane_Offset
fig_num = 1;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);

assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==3);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==2);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% Ex_Complex_Lane_Offset
fig_num = 2;
figure(fig_num)
clf

example_file = 'Ex_Complex_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);

assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==4);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==4);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% Ex_Simple_Lane_Offset_Reversed
fig_num = 3;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset_Reversed.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);

assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==3);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==3);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% Ex_Simple_Lane_Offset
fig_num = 4;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);

assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==3);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==3);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% Ex_Simple_Lane_Gains
fig_num = 5;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Gains.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);

assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==3);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==3);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


%% workzone_50m_curve_barrels
fig_num = 6;
figure(fig_num)
clf

example_file = 'workzone_50m_curve_barrels.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);


assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==2);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==2);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% testTrack_outerTrack
fig_num = 7;
figure(fig_num)
clf

example_file = 'testTrack_outerTrack.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(current_road,0.1,fig_num*100);


assert(length(stationPoints(:,1))>1);
assert(length(stationPoints(1,:))==1);
assert(length(tLeft(:,1))>1);
assert(length(tLeft(1,:))==2);
assert(length(transverseCenterOffsets(:,1))>1);
assert(length(transverseCenterOffsets(1,:))==1);
assert(length(tRight(:,1))>1);
assert(length(tRight(1,:))==2);
% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');