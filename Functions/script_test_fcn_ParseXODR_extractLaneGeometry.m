%% script_test_fcn_ParseXODR_extractLaneGeometry
% Script to test the parsing of lane geometries from an xODR structure,
% using the various functions from this library as well as the PSU path
% library (for converting to traversals and plotting)

% This script was written by C. Beal and maintained by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
%     2022_04_01
%     -- wrote the code
%     2022-05-07
%     -- revised the code to use newly created functions for parsing lanes
%     as well as existing functions within the PSU path library
%     2024_03_09 - S. Brennan
%     -- renamed function from fcn_ParseXODR_extractLaneGeometry

clearvars
close all



% Load an example file from a static file path
% Ex_Simple_Lane_Offset
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');

% Ex_Simple_Lane_Offset_Reversed
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');

% Ex_Complex_Lane_Offset
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');

% workzone_100m_Lane_Offset
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');

% ODR Viewer Example File
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Set up a plot for the lane lines in (E,N) coordinates
figure(1)
clf
hold on
grid on
axis equal
xlabel('East (m)')
ylabel('North (m)')
title('XY view')

Nroads = length(ODRStruct.OpenDRIVE.road);
for roadInd = 1:Nroads
    current_road = ODRStruct.OpenDRIVE.road{roadInd};

    % Extract the path coordinate lane information from the XODR file for the
    % first road in the specified XODR file
    [sPts,tLeft,tCenter,tRight] = fcn_ParseXODR_extractLaneGeometry(current_road,0.1);

    % Obtain the reference line for the road by converting a line with
    % t-coordinate of zero for each of the test station points into (E,N)
    % coordinates
    [xRef,yRef] = fcn_RoadSeg_findXYfromSTandODRRoad(current_road,sPts,zeros(size(sPts)));

    % Determine the number of lanes in the given road
    NlanesL = size(tLeft,2);
    NlanesR = size(tRight,2);

    % Now convert each of the paths (a two-column matrix of (X,Y) points) into
    % a traversal structure consistent with the PSU path library
    roadRef.traversal{1} = fcn_Path_convertPathToTraversalStructure([xRef yRef]);
    [xCenter,yCenter] = fcn_RoadSeg_findXYfromSTandODRRoad(current_road,sPts,tCenter);
    laneDataCenter.traversal{1} = fcn_Path_convertPathToTraversalStructure([xCenter yCenter]);

    % Use the PSU path traversals plotting utility to plot the reference line and the center lane
    hRef = fcn_Path_plotTraversalsXY(roadRef,1);
    hCenter = fcn_Path_plotTraversalsXY(laneDataCenter,1);
    % Set the line properties of the plotted lines
    set(hRef,'linewidth',2,'linestyle',':','marker','none','color',[0.6 0.6 0.6]);
    set(hCenter,'linewidth',2,'linestyle','-.','marker','none','color','k');


    if NlanesL > 0
        % Preallocate the (X,Y) lane boundary matrices for speed
        xLeft = nan(size(tLeft));
        yLeft = nan(size(tLeft));
        % Now convert each of the paths (a two-column matrix of (X,Y) points) into
        % a traversal structure consistent with the PSU path library
        for laneIdx = 1:NlanesL
            [xLeft(:,laneIdx),yLeft(:,laneIdx)] = fcn_RoadSeg_findXYfromSTandODRRoad(current_road,sPts,tLeft(:,laneIdx));
            laneDataLeft.traversal{laneIdx} = fcn_Path_convertPathToTraversalStructure([xLeft(:,laneIdx) yLeft(:,laneIdx)]);
        end
        % Use the PSU path traversals plotting utility to plot the lane boundaries
        hLeft = fcn_Path_plotTraversalsXY(laneDataLeft,1);
        % Set the line properties of the plotted line
        set(hLeft,'linewidth',1,'linestyle','-','marker','.');
    end

    if NlanesR > 0
        % Preallocate the (X,Y) lane boundary matrices for speed
        xRight = nan(size(tRight));
        yRight = nan(size(tRight));
        % Now convert each of the paths (a two-column matrix of (X,Y) points) into
        % a traversal structure consistent with the PSU path library
        for laneIdx = 1:NlanesR
            [xRight(:,laneIdx),yRight(:,laneIdx)] = fcn_RoadSeg_findXYfromSTandODRRoad(current_road,sPts,tRight(:,laneIdx));
            laneDataRight.traversal{laneIdx} = fcn_Path_convertPathToTraversalStructure([xRight(:,laneIdx) yRight(:,laneIdx)]);
        end
        % Use the PSU path traversals plotting utility to plot the lane boundaries
        hRight = fcn_Path_plotTraversalsXY(laneDataRight,1);
        % Set the line properties of the plotted line
        set(hRight,'linewidth',1,'linestyle','-','marker','.');
    end



    if 1 == roadInd
        % For the first road, plot the lane lines in (s,t) coordinates for illustrative/debugging
        % purposes
        figure(2)
        clf
        hold on
        grid on

        title('Road 1 St coordinate view');
        hC = plot(sPts,tCenter,'k--','linewidth',1.5);
        plotHandles = hC;
        plotLabels = {'Center Lane'};
        if NlanesL > 0
            hL = plot(sPts,tLeft,'r--','linewidth',1.5);
            plotHandles = [plotHandles; hL];
            plotLabels{end+1} = 'Left Lanes';
        end
        if NlanesR > 0
            hR = plot(sPts,tRight,'b--','linewidth',1.5);
            plotHandles = [plotHandles; hR];
            plotLabels{end+1} = 'Right Lanes';
        end
        xlabel('s coordinate')
        ylabel('t coordinate')
        legend(plotHandles,plotLabels)
    else
        figure(2)
        hC = plot(sPts,tCenter,'k--','linewidth',1.5);
        if NlanesL > 0
            hL = plot(sPts,tLeft,'r--','linewidth',1.5);
        end
        if NlanesR > 0
            hR = plot(sPts,tRight,'b--','linewidth',1.5);
        end
    end
end