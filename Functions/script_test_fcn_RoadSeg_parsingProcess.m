% Script to test the parsing of objects from an xODR structure, using the
% various functions from this library as well as the PlotXODR library and
% the patch object library (for plotting)

% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu 

% Revision history:
%     2022_04_01
%     -- wrote the code

clearvars
close all

% Load an example file with a file selection dialog
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct;

% Load an example file from a static file path
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/workzone_50m_curve_objects.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Define the max gap between plot points on the road, in meters
maxRoadGap = 0.1; 
% Plot the road segment in figure 1 (figure specification optional)
fcn_RoadSeg_plotODRRoadGeometry(ODRStruct,maxRoadGap);
% Grab the figure handle for plotting the objects later
hRoad = gcf;

% Define the max gap between points on the object outline, in meters
maxObjectVertexGap = 0.05;
% Convert the XODR objects to patch objects in an array
objectArray = fcn_RoadSeg_convertXODRObjectsToPatchObjects(ODRStruct,maxObjectVertexGap);

% Plot the patch objects on top of the (previously plotted) roadway figure
fcn_Patch_plotPatch(objectArray,hRoad);