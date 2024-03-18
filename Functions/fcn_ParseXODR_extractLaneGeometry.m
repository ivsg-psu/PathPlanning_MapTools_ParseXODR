function [stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractLaneGeometry(ODRRoad,maxPlotGap, varargin)
%% fcn_ParseXODR_extractLaneGeometry
% Extracts the lane geometry defined in an XODR file
%
% FORMAT:
%
%       [stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractLaneGeometry(ODRRoad,maxPlotGap, (fig_num))
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
%      fcn_RoadSeg_findXYfromSTandSegment from the ParseXODR library
%      fcn_RoadSeg_findXYfromST from the ParseXODR library (second-level)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_extractLaneGeometry.m for a
%       full test suite.
%
% This function was written by C. Beal and is maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
%     2022_05_04 - C. Beal
%     -- wrote the code
%     2022_05_07
%     -- debugged the cumsum approach at the end to take into account the
%     unsorted lanes that occur when lanes disappear/appear
%     2024_03_09 - S. Brennan
%     -- renamed function from fcn_ParseXODR_extractLaneGeometry

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

flag_do_debug = 1;

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
lengthOfRoad = str2double(ODRRoad.Attributes.length);

Npts = ceil(lengthOfRoad/maxPlotGap);
stationPoints = linspace(0,lengthOfRoad,Npts)';

% Preallocate some left and right width matrices with NaNs. These will be
% filled with widths of lanes (in sequence, building away from the
% center lane)
tLeft = nan(length(stationPoints),10);
tRight = nan(length(stationPoints),10);


% Show what we are doing in the workspze
if flag_do_debug
    fprintf(1,'Starting lane extraction routine for road ID: %s\n',ODRRoad.Attributes.id);
end

% Using the lane offset structure, determine whether there are any offsets
% to the center lane in the current road
if isfield(ODRRoad.lanes,'laneOffset')
    laneOffsetStructure = ODRRoad.lanes.laneOffset;
    transverseCenterOffsets = fcn_INTERNAL_extractLaneOffset(laneOffsetStructure, stationPoints, flag_do_debug);
else
    transverseCenterOffsets = 0*stationPoints;
end

% Get the lane linkages between sections. This loops through all the
% laneSections and in each laneSection, finds which lane IDs in one section
% are connected to which lane IDs in other sections. This produces two
% matricies wherein the rows indicate the presence and ordering of lanes in
% a section, and the column numbering indicates the ID of lanes that are
% active.
[laneLinksLeft, laneLinksRight] = fcn_INTERNAL_extractLaneLinkagesFromLanes(ODRRoad.lanes);

if flag_do_debug
    fprintf(1,'LaneLinksLeft: \n');
    disp(laneLinksLeft);
    fprintf(1,'LaneLinksRight: \n');
    disp(laneLinksRight);
end

% Set up a cell array to store the indices of the station points associated
% with each lane segment
stationIndices = {};

% Iterate through all of the lane sections
NlaneSections = length(ODRRoad.lanes.laneSection);
for laneSectionIndex = 1:NlaneSections

    % Check for child lanes not in a left, center, or right container
    expected_fields = {'left','center','right','Attributes'};

    %%% FUNCTIONALIZE START HERE
    current_fields = fieldnames(ODRRoad.lanes.laneSection{laneSectionIndex});
    [~,in_expected,in_tested] = setxor(expected_fields,current_fields);
    if ~isempty(in_tested)
        if flag_do_debug
            for ith_field = 1:length(in_tested)
                bad_index = in_tested(ith_field);
                unexpected_fieldName = current_fields{bad_index};
                fprintf(1,'In road ID: %s, lane segment %d contains a lane or field outside of the expected <left>,<center>, and <right> containers, called: %s. Ignoring it.\n',...
                    ODRRoad.Attributes.id,laneSectionIndex, unexpected_fieldName);
            end
        end
    end
    % Now check if any are missing
    if ~isempty(in_expected)
        if flag_do_debug
            for ith_field = 1:length(in_expected)
                bad_index = in_expected(ith_field);
                unexpected_fieldName = current_fields{bad_index};
                fprintf(1,'In road ID: %s, lane segment %d is missing a lane within the expected <left>,<center>, and <right> containers, specifically: %s. Ignoring it.\n',...
                    ODRRoad.Attributes.id,laneSectionIndex, unexpected_fieldName);
            end
        end
    end
    %%% END FUNCTIONALIZE

    %%% MOVE INTO FUNCTION
    % Determine the start and end points of the lane section
    laneSecStart = str2double(ODRRoad.lanes.laneSection{laneSectionIndex}.Attributes.s);

    % The station coordinate of the lane section end will be the start of
    % the next lane section, unless it's the last lane section. If that's
    % the case, use the station coordinate of the end of the road (the
    % length) to determine the end of the section
    if laneSectionIndex == NlaneSections
        laneSecEnd = str2double(ODRRoad.Attributes.length);
    else
        laneSecEnd = str2double(ODRRoad.lanes.laneSection{laneSectionIndex+1}.Attributes.s);
    end
    %%% END MOVE

    % Calculate the transverse coordinates of the outside (away from
    % center) lane position for each of the lanes
    [tLeft, stationIndices]  = fcn_INTERNAL_extractLaneBoundariesFromLaneSection(tLeft,  ODRRoad.lanes.laneSection{laneSectionIndex},  'left', laneLinksLeft,  laneSectionIndex, NlaneSections, laneSecStart, laneSecEnd,  stationPoints, stationIndices, 1, flag_do_debug);
    [tRight, stationIndices] = fcn_INTERNAL_extractLaneBoundariesFromLaneSection(tRight, ODRRoad.lanes.laneSection{laneSectionIndex}, 'right', laneLinksRight, laneSectionIndex, NlaneSections, laneSecStart, laneSecEnd,  stationPoints, stationIndices, -1, flag_do_debug);

end

% Trim away any columns of the lane data matrices where there is no lane
% geometry at all
tLeft = tLeft(:,any(~isnan(tLeft)));
tRight = tRight(:,any(~isnan(tRight)));

% Do the cumulative sum in the columns, not by left to right but by
% lane order, without including nan values (which get sorted to the end of
% the temporary vector that is being summed anyway)
for i = 1:length(stationIndices)
    [~,sortInds] = sort(laneLinksLeft(i,:));
    if ~isempty(tLeft)
        tLeft(stationIndices{i},sortInds) = cumsum(tLeft(stationIndices{i},sortInds),2,'includenan');
    end
    [~,sortInds] = sort(laneLinksRight(i,:));
    if ~isempty(tRight)
        tRight(stationIndices{i},sortInds) = cumsum(tRight(stationIndices{i},sortInds),2,'includenan');
    end
end

% Add any centerline offset that exists for the lanes
tLeft = tLeft   + transverseCenterOffsets;
tRight = tRight + transverseCenterOffsets;

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
    [xRef,yRef] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,stationPoints,zeros(size(stationPoints)));
    % Now convert each of the paths (a two-column matrix of (X,Y) points) into
    % a traversal structure consistent with the PSU path library
    roadRef.traversal{1} = fcn_Path_convertPathToTraversalStructure([xRef yRef]);
    % Use the PSU path traversals plotting utility to plot the reference line and the center lane
    hRef = fcn_Path_plotTraversalsXY(roadRef,fig_num);
    % Set the line properties of the plotted lines
    set(hRef,'linewidth',2,'linestyle',':','marker','none','color',[0.6 0.6 0.6]);


    % Plot the center line using same process
    [xCenter,yCenter] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,stationPoints,transverseCenterOffsets);
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
        [xSide(:,laneIdx),ySide(:,laneIdx)] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,stationPoints,tSide(:,laneIdx));
        laneDataLeft.traversal{laneIdx} = fcn_Path_convertPathToTraversalStructure([xSide(:,laneIdx) ySide(:,laneIdx)]);

        % Find the location where to number the lane
        % TO do this, find where lanes appear using the NaN values. Any
        % place changing from NaN to a numeric value is where a lane is
        % appearing
        locations_nan = [1; isnan(laneDataLeft.traversal{laneIdx}.X)];
        indicies_changing_from_nan_to_numeric = find(diff(locations_nan)<0);

        station_points_for_text = stationPoints(indicies_changing_from_nan_to_numeric) + station_nudge;
        transverse_points_for_text = tSide(indicies_changing_from_nan_to_numeric,laneIdx) - multiplier_for_side*transverse_nudge;
        [xText{laneIdx},yText{laneIdx}] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRRoad,station_points_for_text,transverse_points_for_text);
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


%% fcn_INTERNAL_extractLaneOffset
function tCenter = fcn_INTERNAL_extractLaneOffset(laneOffsetStructure, stationPoints, flag_do_debug)

% Preallocate a t-coordinate vector for the center lane (which is
% different than the reference line). This will be zero when the center
% lane is not offset, but offsets may shift it. All other lane positions
% are referenced to this position
tCenter = zeros(length(stationPoints(:,1)),1);

% Determine the number of offset descriptors in the road
Noffsets = length(laneOffsetStructure);
% Iterate through all of the offset descriptors
for laneOffsetIdx = 1:Noffsets
    % Determine the start point of the offset descriptor
    offsetStart = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.s);
    % Determine the end point of the offset descriptor
    if laneOffsetIdx == Noffsets
        % If this is the last offset, it must run to the end of the road
        offsetEnd = stationPoints(end);
    else
        % If this is not the last offset, it runs until the next offset
        % descriptor
        offsetEnd = str2double(laneOffsetStructure{laneOffsetIdx+1}.Attributes.s);
    end

    % Determine which of the indices in the s-direction are affected by
    % this offset descriptor
    affectedIdxs = find(stationPoints >= offsetStart & stationPoints <= offsetEnd);

    % Grab the properties of the offset
    a = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.a);
    b = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.b);
    c = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.c);
    d = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.d);

    % Now calculate the t coordinate of the center line at each of the
    % affected points
    ds = stationPoints(affectedIdxs)-offsetStart;
    tCenter(affectedIdxs) = a + b*ds + c*ds.^2 + d*ds.^3;

    if flag_do_debug
        fprintf(1,'Offset center lane from stations %d to %d\n',offsetStart,offsetEnd);
    end
end
end % Ends fcn_INTERNAL_extractLaneOffset


%% fcn_INTERNAL_extractLaneLinkagesFromLanes
function [laneLinksLeft, laneLinksRight] = fcn_INTERNAL_extractLaneLinkagesFromLanes(lanes)
% Determine the number of lane sections in the current road (there should
% always be at least one)
NlaneSections = length(lanes.laneSection);

% Initialize a flag to determine when the first definition of a left lane
% has been reached
leftLanesStarted = 0;
laneLinksLeft = [];

% Initialize a flag to determine when the first definition of a right lane
% has been reached
rightLanesStarted = 0;
laneLinksRight = [];

% Iterate through all of the lane sections to gather the lane linkage
% information
for laneSectionIndex = 1:NlaneSections
    % Get the lane linkages between sections
    [laneLinksLeft,  leftLanesStarted]  = fcn_INTERNAL_extractLaneLinkageFromSide(lanes.laneSection{laneSectionIndex}, laneSectionIndex, 'left', leftLanesStarted, laneLinksLeft);
    [laneLinksRight, rightLanesStarted] = fcn_INTERNAL_extractLaneLinkageFromSide(lanes.laneSection{laneSectionIndex}, laneSectionIndex, 'right', rightLanesStarted, laneLinksRight);
end % ends looping through laneSections

end  % ends fcn_INTERNAL_extractLaneLinkagesFromLanes

%% fcn_INTERNAL_extractLaneLinkageFromSide
function [updatedLaneLinks, flagLanesStarted] = fcn_INTERNAL_extractLaneLinkageFromSide(laneSection, laneSectionIndex, sideString, flagLanesStartedPreviously, laneLinksPreviously)

% Change the multiplier if right or left
switch lower(sideString)
    case {'left'}
        multiplier = 1;
    case 'right'
        multiplier = -1;
    otherwise
        error('Unknown side type given.')
end

% Pass the flag through - this is the default unless it is changed in the
% code that follows
flagLanesStarted = flagLanesStartedPreviously;

if isfield(laneSection,sideString)
    % Determine the number of side lanes there are in the current section
    NsideLanesInCurrentLaneSection = length(laneSection.(sideString).lane);
    if ~flagLanesStartedPreviously
        % Code to run only for lane segments following the first definition of
        % side lanes

        flagLanesStarted = 1; % Set the flag that side lanes have started

        % Initialize the current section with incrementally increasing lane
        % IDs, working from smallest to largest (from center lane outward)
        updatedLaneLinks(laneSectionIndex,:) = 1:NsideLanesInCurrentLaneSection;

    else

        % Initialize any new rows with NaN values, including the one for the
        % current section
        updatedLaneLinks = [laneLinksPreviously;...
            nan(laneSectionIndex - size(laneLinksPreviously,1),size(laneLinksPreviously,2))];

        % Do a double-check to make sure that the right number of NaNs were
        % added
        if size(updatedLaneLinks,1) ~= laneSectionIndex
            error('Addition of NaN rows did not produce consistent matrix size');
        end

        % Iterate through each of the side lanes in the current section,
        for sideLaneIndex = 1:NsideLanesInCurrentLaneSection
            % Grab the current lane ID
            currLane = str2double(laneSection.(sideString).lane{sideLaneIndex}.Attributes.id);

            % Check to see if this lane has a predecessor
            if isfield(laneSection.(sideString).lane{sideLaneIndex},'link')  && isfield(laneSection.(sideString).lane{sideLaneIndex}.link,'predecessor')
                % Get the predecessor of the current lane
                currPred = str2double(laneSection.(sideString).lane{sideLaneIndex}.link.predecessor.Attributes.id);

                % Insert the current lane ID into the column matching that of its
                % predecessor
                updatedLaneLinks(laneSectionIndex,multiplier*currPred == updatedLaneLinks(laneSectionIndex-1,:)) = multiplier*currLane;
            else
                % This is a new lane starting, so handle as such by adding a new
                % column on the end of the matrix and adding the current lane ID
                % as the first entry, starting in the current row
                updatedLaneLinks = [updatedLaneLinks nan(laneSectionIndex,1)]; %#ok<AGROW>
                updatedLaneLinks(end,end) = multiplier*currLane;
            end
        end
    end
else % Field is not found
    % This lane section does not contain any side lanes, so fill the
    % updatedLaneLinks variable with nans for this lane section
    if 1 == laneSectionIndex
        updatedLaneLinks = nan;
    else
        updatedLaneLinks(laneSectionIndex,:) = nan(1,size(laneLinksPreviously(laneSectionIndex-1,:)));
    end
end
end % Ends fcn_INTERNAL_extractLaneLinkageFromSide

%% fcn_INTERNAL_extractLaneBoundariesFromLaneSection
function [tLeft, stationIndices] = fcn_INTERNAL_extractLaneBoundariesFromLaneSection(tLeft, laneSection, sideString, laneLinksLeft, laneSectionIndex, NlaneSections, laneSecStart, laneSecEnd, stationPoints, stationIndices, side_multiplier, flag_do_debug)
if isfield(laneSection,sideString)
    % Iterate through all of the left lane elements
    NleftLanesInCurrentLaneSection = length(laneSection.(sideString).lane);
    for leftLaneIdx = 1:NleftLanesInCurrentLaneSection
        % Get the lane index from the XODR structure
        laneID = str2double(laneSection.(sideString).lane{leftLaneIdx}.Attributes.id);
        laneDataIndex = find(laneLinksLeft(laneSectionIndex,:) == side_multiplier*laneID);
        if ~isempty(laneDataIndex)
            if flag_do_debug
                fprintf(1,'   Processing lane number %d in lane section %d\n',laneID,laneSectionIndex);
            end
            Nwidths = length(laneSection.(sideString).lane{leftLaneIdx}.width);
            if ~iscell(laneSection.(sideString).lane{leftLaneIdx}.width)
                laneSection.(sideString).lane{leftLaneIdx}.width = {laneSection.(sideString).lane{leftLaneIdx}.width};
            end
            for widthIdx = 1:Nwidths
                a = str2double(laneSection.(sideString).lane{leftLaneIdx}.width{widthIdx}.Attributes.a);
                b = str2double(laneSection.(sideString).lane{leftLaneIdx}.width{widthIdx}.Attributes.b);
                c = str2double(laneSection.(sideString).lane{leftLaneIdx}.width{widthIdx}.Attributes.c);
                d = str2double(laneSection.(sideString).lane{leftLaneIdx}.width{widthIdx}.Attributes.d);
                sOffset = str2double(laneSection.(sideString).lane{leftLaneIdx}.width{widthIdx}.Attributes.sOffset);
                widthStart = laneSecStart + sOffset;
                if widthIdx == Nwidths
                    widthEnd = laneSecEnd;
                else
                    widthEnd = str2double(laneSection.(sideString).lane{leftLaneIdx}.width{widthIdx+1}.Attributes.sOffset);
                end
                % Determine which of the indices in the s-direction are affected by
                % this offset descriptor
                stationIndices{laneSectionIndex} = find(stationPoints >= widthStart & stationPoints <= widthEnd); %#ok<AGROW>
                % Now calculate the t coordinate of the left line at each of the
                % affected points
                ds = stationPoints(stationIndices{laneSectionIndex})-widthStart;
                tLeft(stationIndices{laneSectionIndex},laneDataIndex) = side_multiplier*(a + b*ds + c*ds.^2 + d*ds.^3);
                if flag_do_debug
                    fprintf(1,'   Determined lane %d edge from stations %d to %d\n',laneID,widthStart,widthEnd);
                end
            end
        end
    end
end

end % Ends fcn_INTERNAL_extractLaneBoundariesFromLaneSection
