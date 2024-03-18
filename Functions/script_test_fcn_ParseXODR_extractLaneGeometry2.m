% script_test_fcn_ParseXODR_extractLaneGeometry2
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractLaneGeometry
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" written by C. Beal Questions or comments?
% sbrennan@psu.edu
%
% Revision history:
%     2024_03_18
%     -- wrote the code

close all

%% Load an example file from a static file path
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');


%% Check the structure

%% Basic demo 
fig_num = 1;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[sPts,tLeft,tCenter,tRight] = fcn_ParseXODR_extractLaneGeometry(current_road,0.1,fig_num*100);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% Basic demo 
fig_num = 2;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Gains.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[sPts,tLeft,tCenter,tRight] = fcn_ParseXODR_extractLaneGeometry(current_road,0.1,fig_num*100);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');

%% workzone_100m_Lane_Offset
fig_num = 2;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);


% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the export function
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[sPts,tLeft,tCenter,tRight] = fcn_ParseXODR_extractLaneGeometry(current_road,0.1,fig_num*100);

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');