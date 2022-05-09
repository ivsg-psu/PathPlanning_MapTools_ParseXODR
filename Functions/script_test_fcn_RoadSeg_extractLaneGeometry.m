% Script to test the parsing of lane geometries from an xODR structure,
% using the various functions from this library as well as the PSU path
% library (for converting to traversals and plotting)

% This script was written by C. Beal
% Questions or comments? sbrennan@psu.edu

% Revision history:
%     2022_04_01
%     -- wrote the code
%     2022-05-07
%     -- revised the code to use newly created functions for parsing lanes
%     as well as existing functions within the PSU path library

clearvars
close all

% Load an example file from a static file path
% Ex_Simple_Lane_Offset
% ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset.xodr');
% Ex_Simple_Lane_Offset_Reversed
% ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset_Reversed.xodr');
% Ex_Complex_Lane_Offset
% ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Complex_Lane_Offset.xodr');
% workzone_100m_Lane_Offset
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/workzone_100m_Lane_Offset.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Add the path for the PSU path library
addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_PathClassLibrary'))

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
[sPts,tLeft,tCenter,tRight] = fcn_RoadSeg_extractLaneGeometry(ODRStruct.OpenDRIVE.road{1},1);

% Obtain the reference line for the road by converting a line with
% t-coordinate of zero for each of the test station points into (E,N)
% coordinates
[xRef,yRef] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},sPts,zeros(size(sPts)));

% Determine the number of lanes in the given road
NlanesL = size(tLeft,2);
NlanesR = size(tRight,2);

% Preallocate the (X,Y) lane boundary matrices for speed
xLeft = nan(size(tLeft));
yLeft = nan(size(tLeft));
xRight = nan(size(tRight));
yRight = nan(size(tRight));

% Now convert each of the paths (a two-column matrix of (X,Y) points) into
% a traversal structure consistent with the PSU path library
roadRef.traversal{1} = fcn_Path_convertPathToTraversalStructure([xRef yRef]);
[xCenter,yCenter] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},sPts,tCenter);
laneDataCenter.traversal{1} = fcn_Path_convertPathToTraversalStructure([xCenter yCenter]);
for laneIdx = 1:NlanesL
  [xLeft(:,laneIdx),yLeft(:,laneIdx)] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},sPts,tLeft(:,laneIdx));
  laneDataLeft.traversal{laneIdx} = fcn_Path_convertPathToTraversalStructure([xLeft(:,laneIdx) yLeft(:,laneIdx)]);
end
for laneIdx = 1:NlanesR
  [xRight(:,laneIdx),yRight(:,laneIdx)] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},sPts,tRight(:,laneIdx));
  laneDataRight.traversal{laneIdx} = fcn_Path_convertPathToTraversalStructure([xRight(:,laneIdx) yRight(:,laneIdx)]);
end

% Plot the lane lines in (E,N) coordinates
figure(1)
clf
hold on
grid on
axis equal
xlabel('East (m)')
ylabel('North (m)')
% Use the PSU path traversals plotting utility to plot the lane boundaries
hRef = fcn_Path_plotTraversalsXY(roadRef,1);
hCenter = fcn_Path_plotTraversalsXY(laneDataCenter,1);
hLeft = fcn_Path_plotTraversalsXY(laneDataLeft,1);
hRight = fcn_Path_plotTraversalsXY(laneDataRight,1);

% Set the line properties of the various lines
set(hRef,'linewidth',2,'linestyle',':','marker','none','color',[0.6 0.6 0.6]);
set(hCenter,'linewidth',2,'linestyle','-.','marker','none','color','k');
set(hLeft,'linewidth',1,'linestyle','-','marker','.');
set(hRight,'linewidth',1,'linestyle','-','marker','.');

% Plot the lane lines in (s,t) coordinates for illustrative/debugging
% purposes
figure(2)
clf
hold on
grid on
hC = plot(sPts,tCenter,'k--','linewidth',1.5);
hL = plot(sPts,tLeft,'r--','linewidth',1.5);
hR = plot(sPts,tRight,'b--','linewidth',1.5);
xlabel('s coordinate')
ylabel('t coordinate')
legend([hC hL(1) hR(1)],{'Center Lane','Left Lanes','Right Lanes'})