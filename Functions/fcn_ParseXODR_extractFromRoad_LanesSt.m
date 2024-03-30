function [stationPoints, tLeft, transverseCenterOffsets, tRight] = fcn_ParseXODR_extractFromRoad_LanesSt(ODRRoad, maxPlotGap, varargin)
%% fcn_ParseXODR_extractFromRoad_LanesSt
% Extracts the station and transverse coordinates for the center, left and
% right lanes in a given road.
%
% FORMAT:
%
%       [stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromRoad_LanesSt(ODRRoad, maxPlotGap, (fig_num))
%
% INPUTS:
%
%      ODRRoad: a nested structure containing the XDOR road element
%         structure
%
%      maxPlotGap: a scalar parameter defining the maximum distance (in
%         meters) between adjacent plot points (to make sure that any
%         curves have sufficient definition)
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      stationPoints: a vector of s coordinates that define the spacing for the
%         matrices of t coordinates, taking into account the specified
%         maximum plotting gap
%      tLeft: a matrix of t coordinates associated with lane boundaries to
%         the left of the center lane line of the road
%      transverseCenterOffsets: a vector of t coordinates associated with the center lane
%         line of the road
%      tRight: a matrix of t coordinates associated with lane boundaries to
%         the right of the center lane line of the road
%
% DEPENDENCIES:
%
%      fcn_ParseXODR_extractXYfromSTandGeometries
%      fcn_ParseXODR_extractXYfromSTCurves (second-level)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_extractFromRoad_LanesSt.m for a
%       full test suite.
%
% This function was written by C. Beal and is maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_05_04 - C. Beal
% -- wrote the code
% 2022_05_07
% -- debugged the cumsum approach at the end to take into account the
% unsorted lanes that occur when lanes disappear/appear
% 2024_03_09 - S. Brennan
% -- renamed function from fcn_ParseXODR_extractLaneGeometry to
% fcn_ParseXODR_extractFromRoad_LanesSt 

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS");
    MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG = getenv("MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS);
    end
end

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 34838; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
end



%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0==flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(2,3);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end

% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (3<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end


%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a series of points for plotting, taking into account the
% maximum gap allowed in the series of points. This is the set of station
% points on the reference line for which the reference line geometry as
% well as all of the lanes will be calculated. Note that these
% s-coordinates form a grid in the s,t space upon which all of the x,y
% points for continuous features such as lanes, etc. will be calculated
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(ODRRoad, -1);

% Show what we are doing in the workspze
if flag_do_debug
    fprintf(1,'Starting lane extraction routine for road ID: %s\n',IDofRoad);
end

Npts = ceil(lengthOfRoad/maxPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';



% Using the lane offset structure, determine whether there are any offsets
% to the center lane in the current road
lanesStructure = ODRRoad.lanes;
transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, lengthOfRoad, stationPoints, -1);

% Find the stations where each lane section starts and ends
laneSectionStations = fcn_ParseXODR_extractFromLanes_LaneSectionStations(lanesStructure, lengthOfRoad, -1);

% Get the lane linkages between sections. 
[laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, -1);
laneLinksRight = -1*laneLinksRight; % Indicate the right side by making all the results negative
laneLinkages = [laneLinksLeft, laneLinksRight];

% Iterate through all of the lane sections
NlaneSections = length(laneSectionStations(:,1));

% Set up a cell array to store the indices of the station points associated
% with each lane segment
stationIndices = cell(NlaneSections,1);

% Preallocate some left and right width matrices with NaNs. These will be
% filled with widths of lanes (in sequence, building away from the
% center lane). Each column represents the incremental increase in lane
% width for that respective lane.

tRawIncrements = nan(length(stationPoints),length(laneLinkages(1,:)) );


for laneSectionIndex = 1:NlaneSections
    currentLaneSection = lanesStructure.laneSection{laneSectionIndex};

    laneSectionStationLimits = laneSectionStations(laneSectionIndex,:);

    % Determine which of the indices in the s-direction are affected by
    % this lane section
    currentLaneSectionStationIndicies = find(stationPoints >= laneSectionStationLimits(1) & stationPoints <= laneSectionStationLimits(2));
    stationIndices{laneSectionIndex}  = currentLaneSectionStationIndicies;
    stationsInThisLaneSection = stationPoints(currentLaneSectionStationIndicies);

    % Gather the transverse coordinates for this lane section

    % URHERE 
    % then merge both laneLinksLeft laneLinksRight side-by-side
    tCurrentLaneSection = ...
        fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationsInThisLaneSection, laneLinksLeft(laneSectionIndex,:), -1*laneLinksRight(laneSectionIndex,:),laneSectionStationLimits);
    tRawIncrements(currentLaneSectionStationIndicies,:) = tCurrentLaneSection;

end % Ends looping through lane sections

% Trim away any columns of the lane data matrices where there is no lane
% geometry at all
tIncrements_NoNanColumns = tRawIncrements(:,any(~isnan(tRawIncrements)));

% Add up all the increments to determine the total tranverse distances from
% the centerline
[tLeftTotalOffsets, tRightTotalOffsets] = fcn_INTERNAL_addLaneIncrements(stationPoints, stationIndices, tIncrements_NoNanColumns, laneLinkages);

% Add any centerline offset that exists for the lanes
% This shifts the centerline relative to the road geometric center, if necessary
tLeft  = tLeftTotalOffsets   + transverseCenterOffsets;
tRight = tRightTotalOffsets  + transverseCenterOffsets;

% Provide some indication of completion
if flag_do_debug
    fprintf(1,'Completed lane extraction routine\n');
end


%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_plots
    temp_h = figure(fig_num);
    flag_rescale_axis = 0;
    if isempty(get(temp_h,'Children'))
        flag_rescale_axis = 1;
    end

    hold on;
    grid on;
    axis equal


    % Set up labels and title
    xlabel('East (m)')
    ylabel('North (m)')
    title('XY view')


    % Plot the reference line:
    % Obtain the reference line for the road by converting a line with
    % t-coordinate of zero for each of the test station points into (E,N)
    % coordinates
    % [xRef,yRef] = fcn_ParseXODR_extractFromRoadPlanView_STtoXY(ODRRoad.planView.geometry, stationPoints,zeros(size(stationPoints)));
    [xRef,yRef] = fcn_ParseXODR_extractFromRoadPlanView_STtoXY(ODRRoad.planView.geometry, stationPoints);

    % Now convert each of the paths (a two-column matrix of (X,Y) points) into
    % a traversal structure consistent with the PSU path library
    roadRef.traversal{1} = fcn_Path_convertPathToTraversalStructure([xRef yRef]);
    % Use the PSU path traversals plotting utility to plot the reference line and the center lane
    hRef = fcn_Path_plotTraversalsXY(roadRef,fig_num);
    % Set the line properties of the plotted lines
    set(hRef,'linewidth',2,'linestyle',':','marker','none','color',[0.6 0.6 0.6]);


    % Plot the center line using same process
    [xCenter,yCenter] = fcn_ParseXODR_extractFromRoadPlanView_STtoXY(ODRRoad.planView.geometry, stationPoints,transverseCenterOffsets);
    laneDataCenter.traversal{1} = fcn_Path_convertPathToTraversalStructure([xCenter yCenter]);
    hCenter = fcn_Path_plotTraversalsXY(laneDataCenter,fig_num);
    set(hCenter,'linewidth',2,'linestyle','-.','marker','none','color','k');

    % Plot the left and right side lanes
    fcn_INTERNAL_plotLaneSidesXY(ODRRoad, stationPoints, tLeft,   1, fig_num);
    fcn_INTERNAL_plotLaneSidesXY(ODRRoad, stationPoints, tRight, -1, fig_num);

    % Make axis slightly larger?
    if flag_rescale_axis
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_x = temp(2)-temp(1);
        axis_range_y = temp(4)-temp(3);
        percent_larger = 0.3;
        axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    end

    %% St coordinates plotting
    % Plot the lane lines in (s,t) coordinates for illustrative/debugging
    % purposes
    figure(fig_num+1)
    clf
    hold on
    grid on

    title('St coordinate view');
    xlabel('S coordinate [m]')
    ylabel('t coordinate [m]')

    % Plot the centerline
    hC = plot(stationPoints,transverseCenterOffsets,'k--','linewidth',1.5);
    plotHandles = hC;
    plotLabels = {'Center Lane'};

    % Plot the left side
    [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tLeft, 1, plotHandles, plotLabels);

    % Plot the right side
    [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tRight, -1, plotHandles, plotLabels);

    legend(plotHandles,plotLabels)


    % Make axis slightly larger?
    if flag_rescale_axis
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_x = temp(2)-temp(1);
        axis_range_y = temp(4)-temp(3);
        percent_larger = 0.3;
        axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    end

end % Ends check if plotting

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function

%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
%% fcn_INTERNAL_addLaneIncrements
function [tLeftTotalOffsets, tRightTotalOffsets] = fcn_INTERNAL_addLaneIncrements(stations, stationIndices, tIncrements_NoNanColumns, laneLinkages)

laneLinksLeftcolumns = find(sum(laneLinkages>0,1)>0);
laneLinksRightcolumns = find(sum(laneLinkages<0,1)>0);

% Make sure there is no overlap
bothRightLeft = intersect(laneLinksLeftcolumns,laneLinksRightcolumns);
if ~isempty(bothRightLeft)
    disp(laneLinkages);
    error('lane linkages found where both left and right lanes overlap!');
end

% Pull out the left and right side linkages
laneLinksLeft  = laneLinkages(:,laneLinksLeftcolumns);
laneLinksRight = laneLinkages(:,laneLinksRightcolumns);

%% Find cumulative transverse offsets
% Do the cumulative sum in the columns, not by left to right but by
% lane order, without including nan values (which get sorted to the end of
% the temporary vector that is being summed anyway)

% Initialize the output matricies
tLeftTotalOffsets  = nan(length(stations(:,1)),length(laneLinksLeft(1,:)));
tRightTotalOffsets = nan(length(stations(:,1)),length(laneLinksRight(1,:)));

% Separate out the right and left side transverse increments
tLeftIncrements_NoNanColumns  = tIncrements_NoNanColumns(:,laneLinksLeftcolumns);
tRightIncrements_NoNanColumns = tIncrements_NoNanColumns(:,laneLinksRightcolumns);

% Loop through each lane section, sorting for each section from the inside
% lane to the outside, adding up all the increments to find the total
% offsets in the transverse direction
for ith_row = 1:length(stationIndices)
    % Do the left side
    [~,sortInds] = sort(laneLinksLeft(ith_row,:));
    if ~isempty(tLeftIncrements_NoNanColumns)
        tLeftTotalOffsets(stationIndices{ith_row},sortInds) = cumsum(tLeftIncrements_NoNanColumns(stationIndices{ith_row},sortInds),2,'includenan');
    end

    % Do the right side. Because the laneLinksRight must make them
    % positive, so that it sorts from inside outward.
    [~,sortInds] = sort(-1*laneLinksRight(ith_row,:));
    if ~isempty(tRightIncrements_NoNanColumns)
        tRightTotalOffsets(stationIndices{ith_row},sortInds) = cumsum(tRightIncrements_NoNanColumns(stationIndices{ith_row},sortInds),2,'includenan');
    end
end
end

%% fcn_INTERNAL_plotLaneSidesXY
function fcn_INTERNAL_plotLaneSidesXY(ODRRoad, stationPoints, tSide, multiplier_for_side, fig_num)

transverse_nudge = 1; % Units are meters
station_nudge = 1; % Units are meters

NlanesSide = size(tSide,2);
if NlanesSide > 0
    % Preallocate the (X,Y) lane boundary matrices for speed
    xSide = nan(size(tSide));
    ySide = nan(size(tSide));

    % Now convert each of the paths (a two-column matrix of (X,Y) points) into
    % a traversal structure consistent with the PSU path library
    xText = cell(NlanesSide,1);
    yText = cell(NlanesSide,1);
    for laneIdx = 1:NlanesSide
        % Calculate the side positions in XY
        [xSide(:,laneIdx),ySide(:,laneIdx)] = fcn_ParseXODR_extractFromRoadPlanView_STtoXY(ODRRoad.planView.geometry, stationPoints,tSide(:,laneIdx));

        % Convert results to a traversal type
        laneDataLeft.traversal{laneIdx} = fcn_Path_convertPathToTraversalStructure([xSide(:,laneIdx) ySide(:,laneIdx)]);

        % Find the location where to number the lane
        % TO do this, find where lanes appear using the NaN values. Any
        % place changing from NaN to a numeric value is where a lane is
        % appearing
        locations_nan = [1; isnan(laneDataLeft.traversal{laneIdx}.X)];
        indicies_changing_from_nan_to_numeric = find(diff(locations_nan)<0);

        station_points_for_text = stationPoints(indicies_changing_from_nan_to_numeric) + station_nudge;
        transverse_points_for_text = tSide(indicies_changing_from_nan_to_numeric,laneIdx) - multiplier_for_side*transverse_nudge;
        % Find the XY coordinates
        [xText{laneIdx},yText{laneIdx}] = fcn_ParseXODR_extractFromRoadPlanView_STtoXY(ODRRoad.planView.geometry, station_points_for_text,transverse_points_for_text);        
    end

    % Use the PSU path traversals plotting utility to plot the lane boundaries
    hLeft = fcn_Path_plotTraversalsXY(laneDataLeft,fig_num);
    % Set the line properties of the plotted line
    set(hLeft,'linewidth',1,'linestyle','-','marker','.');

    % Add text labels 
    for laneIdx = 1:NlanesSide
        if multiplier_for_side==1
            text(xText{laneIdx},yText{laneIdx},sprintf('L%.0d',laneIdx));
        else
            text(xText{laneIdx},yText{laneIdx},sprintf('R%.0d',laneIdx));
        end
    end

end
end % Ends fcn_INTERNAL_plotLaneSidesXY

%% fcn_INTERNAL_plotLaneSidesSt
function [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tSide, multiplier_for_side, plotHandles, plotLabels)

transverse_nudge = 1; % Units are meters
station_nudge = 1; % Units are meters

if multiplier_for_side==1
    color_type = 'b--'; % Left
    legend_label = 'Left Lanes';
else
    color_type = 'r--'; % Right
    legend_label = 'Right Lanes';
end

NlanesSide = size(tSide,2);
if NlanesSide > 0    
    hPlot = plot(stationPoints,tSide,color_type,'linewidth',1.5);
    plotHandles = [plotHandles; hPlot(1)];
    plotLabels{end+1} = legend_label;


    for laneIdx = 1:NlanesSide
        % Find the location where to number the lane
        % TO do this, find where lanes appear using the NaN values. Any
        % place changing from NaN to a numeric value is where a lane is
        % appearing
        locations_nan = [1; isnan(tSide(:,laneIdx))];
        indicies_changing_from_nan_to_numeric = find(diff(locations_nan)<0);

        station_points_for_text = stationPoints(indicies_changing_from_nan_to_numeric) + station_nudge;
        transverse_points_for_text = tSide(indicies_changing_from_nan_to_numeric,laneIdx) - multiplier_for_side*transverse_nudge;

        if multiplier_for_side==1
            text(station_points_for_text,transverse_points_for_text,sprintf('L%.0d',laneIdx));
        else
            text(station_points_for_text,transverse_points_for_text,sprintf('R%.0d',laneIdx));
        end
    end

end
end % Ends fcn_INTERNAL_plotLaneSidesSt




