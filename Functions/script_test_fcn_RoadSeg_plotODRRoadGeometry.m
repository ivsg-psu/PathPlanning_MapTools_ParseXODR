% Script to test the plotting of objects from an xODR structure
clearvars
close all

% Make sure that the xml to structure dependency file is available
% addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Functions'));
string_path = which("fcn_ParseXODR_convertXODRtoMATLABStruct");
if isempty(string_path) % ~exist('fcn_ParseXODR_convertXODRtoMATLABStruct','file')
    error('Path not correctly set for fcn_ParseXODR_convertXODRtoMATLABStruct');
    % addpath(uigetdir('.','Provide missing path to fcn_ParseXODR_convertXODRtoMATLABStruct'));
end

% Load an example file with a file selection dialog
%ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct;

% Load an example file from a static file path
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_objects.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack_noReferenceRoad.xodr');
% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Define the max gap between plot points on the road, in meters
maxRoadGap = 0.1; 
% Plot the road segment in figure 1 (figure specification optional)
[xPts,yPts] = fcn_RoadSeg_plotODRRoadGeometry(ODRStruct,maxRoadGap);

