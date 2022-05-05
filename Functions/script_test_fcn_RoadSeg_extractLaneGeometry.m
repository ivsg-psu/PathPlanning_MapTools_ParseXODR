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
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/ODRViewerEx.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/workzone_150m_double_curve_barrels_repeat.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/workzone_50m_curve_objects.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Complex_Lane_Offset.xodr');
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/workzone_100m_Lane_Offset.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Add the path for the XODR plotting library
addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR'));

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[sPts,tLeft,tCenter,tRight] = fcn_RoadSeg_extractLaneGeometry(ODRStruct.OpenDRIVE.road{1},0.2);

% Create a centerline for the road
figure(1)
clf
hold on
grid on
axis equal
fcn_RoadSeg_plotODRRoadGeometry(ODRStruct,0.1,1);
xlabel('East (m)')
ylabel('North (m)')

% Convert the path coordinates to obtain the (X,Y) coordinates of each of
% the calculated lane boundaries
[xCenter,yCenter] = fcn_RoadSeg_findXYfromST('arc',0,0,0,0,100,sPts,tCenter,1/500);
for laneIdx = 1:size(tLeft,2)
  [xLeft(:,laneIdx),yLeft(:,laneIdx)] = fcn_RoadSeg_findXYfromST('arc',0,0,0,0,100,sPts,tLeft(:,laneIdx),1/500);
end
for laneIdx = 1:size(tRight,2)
  [xRight(:,laneIdx),yRight(:,laneIdx)] = fcn_RoadSeg_findXYfromST('arc',0,0,0,0,100,sPts,tRight(:,laneIdx),1/500);
end

% Plot all of the lane lines
figure(2)
clf
hold on
grid on
plot(sPts,tCenter,'k--')
plot(sPts,tLeft,'r--')
plot(sPts,tRight,'b--')
xlabel('s coordinate')
ylabel('t coordinate')

% Overplot the lane lines 
figure(1)
axis auto
plot(xCenter,yCenter,'k');
plot(xLeft,yLeft,'r');
plot(xRight,yRight,'b');
axis equal