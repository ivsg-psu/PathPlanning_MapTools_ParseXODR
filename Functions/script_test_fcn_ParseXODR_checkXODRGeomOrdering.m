% script_test_fcn_ParseXODR_checkXODRGeomOrdering
% Script to test XODR structure compliance
% Tests function fcn_ParseXODR_checkXODRGeomOrdering
%
% Revision history:
% 2024_03_23 - S. Brennan
% -- wrote the code

close all

% Make sure that the xml to structure dependency file is available
% addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Functions'));
string_path = which("fcn_ParseXODR_convertXODRtoMATLABStruct");
if isempty(string_path) % ~exist('fcn_ParseXODR_convertXODRtoMATLABStruct','file')
    error('Path not correctly set for fcn_ParseXODR_convertXODRtoMATLABStruct');
    % addpath(uigetdir('.','Provide missing path to fcn_ParseXODR_convertXODRtoMATLABStruct'));
end

%% BASIC test, not verbose

% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack_noReferenceRoad.xodr');


% Check the structure
[ODRStruct, flag_warnings_were_found] = fcn_ParseXODR_checkXODRGeomOrdering(ODRStruct);

% Make sure we get a structure back
assert(isstruct(ODRStruct));
assert(isequal(flag_warnings_were_found,0));

%% BASIC test, verbose
fig_num = 1;

% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack_noReferenceRoad.xodr');


% Check the structure
[ODRStruct, flag_warnings_were_found] = fcn_ParseXODR_checkXODRGeomOrdering(ODRStruct, fig_num);

% Make sure we get a structure back
assert(isstruct(ODRStruct));
assert(isequal(flag_warnings_were_found,0));

%% BASIC test, verbose, bad geometric ordering
fig_num = 2;
figure(fig_num);
clf;

% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)
flag_plot_road_geometry = [];


% Load an example file from a static file path
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack_noReferenceRoad.xodr');

% Force the geometry elements to be out of order
ODRStruct_BAD = ODRStruct;
ODRStruct_BAD.OpenDRIVE.road{1}.planView.geometry{1} = ODRStruct.OpenDRIVE.road{1}.planView.geometry{2};
ODRStruct_BAD.OpenDRIVE.road{1}.planView.geometry{2} = ODRStruct.OpenDRIVE.road{1}.planView.geometry{1};

% Call the plotting function with a BAD structure
subplot(1,2,1);
fcn_ParseXODR_plotXODRinENU(ODRStruct_BAD,minPlotGap,1,fig_num);


% Check and fix the structure
[ODRStruct_fixed, flag_warnings_were_found] = fcn_ParseXODR_checkXODRGeomOrdering(ODRStruct_BAD);

% Make sure we get a structure back
assert(isstruct(ODRStruct_fixed));
assert(isequal(flag_warnings_were_found,1));

% Check that the new structure is fixed
[~, flag_warnings_were_found] = fcn_ParseXODR_checkXODRGeomOrdering(ODRStruct_fixed);

% Make sure we get a structure back
assert(isequal(flag_warnings_were_found,0));

% Call the plotting function with a FIXED structure
subplot(1,2,2);
fcn_ParseXODR_plotXODRinENU(ODRStruct_fixed,minPlotGap,1,fig_num);

