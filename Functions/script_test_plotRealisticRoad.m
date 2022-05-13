% Script to plot a realistic road environment defined in an XODR file
%
% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu
%
% Revision history:
%     2022_05_10
%     -- wrote the code

clearvars

% Load an example file from a static file path
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset.xodr');
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Gains.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset_Reversed.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Complex_Lane_Offset.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/ODRViewerEx.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Create a blank figure in which to plot the roads
figure(1)
clf
hold on
grid on
axis equal
xlabel('East (m)')
ylabel('North (m)')

% Determine how many roads are defined in the XODR file
Nroads = length(ODRStruct.OpenDRIVE.road);

% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

% Iterate through each of the roads in the XODR file and obtain all of the
% geometry for plotting
for roadInd = 1:Nroads
  % First, extract the lane geometry in order to determine the extents of
  % the road
  [sPts,tLeft,tCenter,tRight] = fcn_RoadSeg_extractLaneGeometry(ODRStruct.OpenDRIVE.road{roadInd},minPlotGap);
  % First, find the extents of the road as the maximum t-coordinate on the
  % left side of the road and the minimum t-coordinate on the right side of
  % the road, then add just a tiny bit of
  if isempty(tLeft)
    leftExtents = tCenter;
  else
    leftExtents = max(tLeft,[],2,'omitnan');
  end
  if isempty(tRight)
    rightExtents = tCenter;
  else
    rightExtents = min(tRight,[],2,'omitnan');
  end
  % Determine the (E,N) coordinates associated with each of the road
  % extents
  [eLeftExtents,nLeftExtents] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{roadInd},sPts,leftExtents);
  [eRightExtents,nRightExtents] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{roadInd},sPts,rightExtents);
  % Plot a dark gray patch to represent the road surface
  patch([eLeftExtents; flipud(eRightExtents)],[nLeftExtents; flipud(nRightExtents)],[0.2 0.2 0.2]);
  
  % Now, plot the center lane as a double-yellow line, by offsetting the
  % center lane by 10 cm each direction from the center lane definition
  [eCenterLaneL,nCenterLaneL] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{roadInd},sPts,tCenter+0.1);
  [eCenterLaneR,nCenterLaneR] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{roadInd},sPts,tCenter-0.1);
  plot(eCenterLaneL,nCenterLaneL,'-','linewidth',3,'color',[0.8 0.6 0.1])
  plot(eCenterLaneR,nCenterLaneR,'-','linewidth',3,'color',[0.8 0.6 0.1])
  
  % Finally, determine the outer lines of the driving lanes, assuming that
  % the outside lanes are the shoulder
  if ~isempty(tLeft)
    [~,inds] = sort(tLeft,2,'descend','MissingPlacement','last');
    for laneIdx = 2:size(tLeft,2)
      for i = 1:length(sPts)
        tLeftDrivingBoundary(i,1) = tLeft(i,[inds(i,laneIdx)]);
      end
      [eLeftLane,nLeftLane] = ...
        fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{roadInd},sPts,tLeftDrivingBoundary);
      if laneIdx == 2
        plot(eLeftLane,nLeftLane,'-','linewidth',3,'color','white');
      else
        plot(eLeftLane,nLeftLane,'--','linewidth',3,'color','white');
      end
    end
  end
  
  % Right side
  if ~isempty(tRight)
    [~,inds] = sort(tRight,2,'ascend','MissingPlacement','last');
    for laneIdx = 2:size(tRight,2)
      for i = 1:length(sPts)
        tRightDrivingBoundary(i,1) = tRight(i,[inds(i,laneIdx)]);
      end
      [eRightLane,nRightLane] = ...
        fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{roadInd},sPts,tRightDrivingBoundary);
      if laneIdx == 2
        plot(eRightLane,nRightLane,'-','linewidth',3,'color','white');
      else
        plot(eRightLane,nRightLane,'--','linewidth',3,'color','white');
      end
    end
  end
end