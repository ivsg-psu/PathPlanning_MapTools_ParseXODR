function fHand = fcn_RoadSeg_plotRealisticRoad(ODRRoad,minPlotGap,varargin)
% Script to plot a realistic road environment defined in an XODR file
%
% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu
%
% Revision history:
%     2022_05_11
%     -- wrote the code

if nargin > 1
  fHand = figure(varargin{1})
else
  % Create a blank figure in which to plot the roads
  fHand = figure;
  clf
  hold on
  grid on
  axis equal
  xlabel('East (m)')
  ylabel('North (m)')
end

% First, extract the lane geometry in order to determine the extents of
% the road
[sPts,tLeft,tCenter,tRight] = fcn_RoadSeg_extractLaneGeometry(ODRRoad,minPlotGap);
% First, find the extents of the road as the maximum t-coordinate on the
% left side of the road and the minimum t-coordinate on the right side of
% the road, then add just a tiny bit of
leftExtents = max(tLeft,[],2,'omitnan');
rightExtents = min(tRight,[],2,'omitnan');
% Determine the (E,N) coordinates associated with each of the road
% extents
[eLeftExtents,nLeftExtents] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,leftExtents);
[eRightExtents,nRightExtents] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,rightExtents);
% Plot a dark gray patch to represent the road surface
patch([eLeftExtents; flipud(eRightExtents)],...
  [nLeftExtents; flipud(nRightExtents)],[0.2 0.2 0.2]);

% Now, plot the center lane as a double-yellow line, by offsetting the
% center lane by 10 cm each direction from the center lane definition
[eCenterLaneL,nCenterLaneL] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,tCenter+0.1);
[eCenterLaneR,nCenterLaneR] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,tCenter-0.1);
plot(eCenterLaneL,nCenterLaneL,'-','linewidth',3,'color',[0.8 0.6 0.1])
plot(eCenterLaneR,nCenterLaneR,'-','linewidth',3,'color',[0.8 0.6 0.1])

% Finally, determine the outer lines of the driving lanes, assuming that
% the outside lanes are the shoulder
[~,inds] = sort(tLeft,2,'descend','MissingPlacement','last');
for laneIdx = 2:size(tLeft,2)
  for i = 1:length(sPts)
    tLeftDrivingBoundary(i,1) = tLeft(i,[inds(i,laneIdx)]);
  end
  [eLeftLane,nLeftLane] = ...
    fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,tLeftDrivingBoundary);
  if laneIdx == 2
    plot(eLeftLane,nLeftLane,'-','linewidth',3,'color','white');
  else
    plot(eLeftLane,nLeftLane,'--','linewidth',3,'color','white');
  end
end

% Right side
[~,inds] = sort(tRight,2,'ascend','MissingPlacement','last');
for laneIdx = 2:size(tRight,2)
  for i = 1:length(sPts)
    tRightDrivingBoundary(i,1) = tRight(i,[inds(i,laneIdx)]);
  end
  [eRightLane,nRightLane] = ...
    fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,sPts,tRightDrivingBoundary);
  if laneIdx == 2
    plot(eRightLane,nRightLane,'-','linewidth',3,'color','white');
  else
    plot(eRightLane,nRightLane,'--','linewidth',3,'color','white');
  end
end