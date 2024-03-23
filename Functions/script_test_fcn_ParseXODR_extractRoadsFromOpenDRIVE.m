% script_test_fcn_ParseXODR_extractRoadsFromOpenDRIVE
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractRoadsFromOpenDRIVE
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" written by C. Beal Questions or comments?
% sbrennan@psu.edu
%
% Revision history:
%     2024_03_18
%     -- wrote the code

close all

%% workzone_100m_Lane_Offset, NOT verbose

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==1);

%% workzone_100m_Lane_Offset, verbose
fig_num = 2;
% figure(fig_num)
% clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE,fig_num);

assert(iscell(roads));
assert(length(roads)==1);

%% Ex_Complex_Lane_Offset
% fig_num = 2;
% figure(fig_num)
% clf

example_file = 'Ex_Complex_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==1);


%% Ex_Simple_Lane_Offset_Reversed
% fig_num = 3;
% figure(fig_num)
% clf

example_file = 'Ex_Simple_Lane_Offset_Reversed.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==1);


%% Ex_Simple_Lane_Offset
% fig_num = 4;
% figure(fig_num)
% clf

example_file = 'Ex_Simple_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==1);


%% Ex_Simple_Lane_Gains
% fig_num = 5;
% figure(fig_num)
% clf

example_file = 'Ex_Simple_Lane_Gains.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==1);



%% workzone_50m_curve_barrels
% fig_num = 6;
% figure(fig_num)
% clf

example_file = 'workzone_50m_curve_barrels.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==1);


%% testTrack_outerTrack
% fig_num = 7;
% figure(fig_num)
% clf

example_file = 'testTrack_outerTrack.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

assert(iscell(roads));
assert(length(roads)==2);

% % Call the plotting function
% fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
% title(sprintf('%s',example_file),'Interpreter','none');