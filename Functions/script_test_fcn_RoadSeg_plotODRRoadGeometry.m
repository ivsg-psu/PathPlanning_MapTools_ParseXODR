% Script to test the plotting of objects from an xODR structure
clearvars
close all

% Make sure that the xml to structure dependency file is available
addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Functions'));
if ~exist('fcn_RoadSeg_convertXODRtoMATLABStruct','file')
  addpath(uigetdir('.','Provide missing path to fcn_RoadSeg_convertXODRtoMATLABStruct'));
end

% Load an example file with a file selection dialog
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct;

% Load an example file from a static file path
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/workzone_50m_curve_objects.xodr');
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/Ex_Simple-LaneOffset.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Define the max gap between plot points on the road, in meters
maxRoadGap = 0.1; 
% Plot the road segment in figure 1 (figure specification optional)
fcn_RoadSeg_plotODRRoadGeometry(ODRStruct,maxRoadGap);
