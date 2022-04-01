% Script to test the plotting of objects from an xODR structure
clear all
close all

% Enumerate some constants for later convenience and code readability
E = 1; N = 2;

% Load an example file with just one arc road segment and some objects
% along the road
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/workzone_150m_double_curve_barrels_repeat.xodr');

% Plot the road segment
fcn_RoadSeg_plotODRRoadGeometry(ODRStruct);
hRoad = gcf;

objectArray = fcn_RoadSeg_convertXODRObjectsToPatchObjects(ODRStruct,0.05);

% Plot the objects on top of the roadway figure
fcn_Patch_plotPatch(objectArray,hRoad);