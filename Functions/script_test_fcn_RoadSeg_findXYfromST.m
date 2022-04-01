% Script to test the plotting of objects from an xODR structure
clearvars
close all

% Enumerate some constants for later convenience and code readability
E = 1; N = 2;

% Load an example file with just one arc road segment and some objects
% along the road
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/workzone_50m_curve_objects.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Plot the road segment
fcn_RoadSeg_plotODRRoadGeometry(ODRStruct);
hRoad = gcf;

% Convert the XODR objects to patch objects in an array
maxObjectVertexGap = 0.05;
objectArray = fcn_RoadSeg_convertXODRObjectsToPatchObjects(ODRStruct,maxObjectVertexGap);

% Plot the patch objects on top of the (previously plotted) roadway figure
fcn_Patch_plotPatch(objectArray,hRoad);