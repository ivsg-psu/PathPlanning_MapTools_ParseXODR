% script_test_fcn_ParseXODR_plotXODRinENU
% Script to plot a realistic road environment defined in an XODR file.
% Tests function fcn_ParseXODR_plotXODRinENU
%
% This script was written by S. Brennan from
% "fcn_RoadSeg_plotRealisticRoad" written by C. Beal Questions or comments?
% sbrennan@psu.edu
%
% Revision history:
%     2024_03_08
%     -- wrote the code

clearvars

%% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

%% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

%% Basic demo - no centerline
fig_num = 1;

% Create a blank figure in which to plot the roads
figure(fig_num)
clf

% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);

%% Basic demo - with centerline
fig_num = 2;

% Create a blank figure in which to plot the roads
figure(fig_num)
clf

% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = 1;

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);