function tOutput = fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationPoints, laneLinksRow, laneSectionStationLimits, varargin)
%% fcn_ParseXODR_extractFromLaneSection_St
% Extracts the transverse coordinates for lane edges (other
% than the center lane) for the current lane section
%
% FORMAT:
%
%       tOutput = fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationPoints, laneLinksRow, laneSectionStationLimits, (fig_num))
%
% INPUTS:
%
%      currentLaneSection: a nested structure containing the XDOR lane
%      section structure
%
%      stationPoints: a [Nx1] vector of s coordinates that define the
%      spacing for the matrices of t coordinates, where N is the number of
%      stations. Note: stations are assumed to be increasing order.
%
%      laneLinksRow: a [1xM] vector of the lane linkage for this section,
%      where M is the number of lanes. Each entry contains an integer
%      indicating which lane description (for example, 2) should be using
%      in a particular lane.
%
%      laneSectionStationLimits: a [2x1] vector of the maximum and minimum
%      stations allowed in this lane section.
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      tOutput: a [NxM] matrix of t coordinates associated with each of the
%      N stations and each of the M lane boundaries. Positive valued
%      t-coordinates indicate positions to the left of the center lane line
%      of the road. Negative valued t coordinates indicate to the right of
%      the center lane lane of the road.
%
% DEPENDENCIES:
%
%      fcn_ParseXODR_extractFromLaneSection_LaneEdgesSt (internal)
%      fcn_ParseXODR_extractFromLaneWidth_CurveSt 
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_extractFromLaneSection_St.m for a
%       full test suite.
%
% This function was originally written by C. Beal but was completely
% refactored in 2024/03 by S. Brennan. It is maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_05_04 - C. Beal
% -- wrote the code
% 2022_05_07
% -- debugged the cumsum approach at the end to take into account the
% unsorted lanes that occur when lanes disappear/appear
% 2024_03_09 - S. Brennan
% -- renamed function from fcn_ParseXODR_extractLaneGeometry to
% fcn_ParseXODR_extractFromLaneSection_St

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==5 && isequal(varargin{end},-1))
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
        narginchk(4,5);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end

% Does user want to specify fig_num?
fig_num = []; % % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (5<= nargin)
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

% Check for child lanes not in a left, center, or right container
required_fields = {'left','center','right','Attributes'};
optional_fields = {'userData'};
flag_verbose = flag_do_debug;
flag_good_match = fcn_ParseXODR_checkStructureFields(currentLaneSection, required_fields, optional_fields, flag_verbose);
if flag_do_debug && (0==flag_good_match)
    warning('A structure field was found outside of the required or optional fields.');

end

% Calculate the transverse coordinates of the outside (away from
% center) lane position for each of the lanes.
[tOutputRow, stationIndices]  = ...
    fcn_ParseXODR_extractFromLaneSection_LaneEdgesSt(...
    currentLaneSection,...
    laneLinksRow,...
    laneSectionStationLimits,...
    stationPoints);

% Convert cell arrays into matricies
tOutput = nan(length(stationPoints(:,1)),length(laneLinksRow(1,:)));

for columnIndex = 1:length(laneLinksRow(1,:))
    tOutput(stationIndices,columnIndex) = tOutputRow{1,columnIndex}(stationIndices,1);
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


    % St coordinates plotting
    % Plot the lane lines in (s,t) coordinates for illustrative/debugging
    % purposes
    figure(fig_num)
    clf
    hold on
    grid on

    title('St coordinate view of lane section');
    xlabel('S coordinate [m]')
    ylabel('t coordinate [m]')

    % Plot the centerline (default at zero)
    hC = plot(stationPoints,0*stationPoints,'k--','linewidth',1.5);
    plotHandles = hC;
    plotLabels = {'Center Lane'};

    % Trim away any columns of the lane data matrices where there is no lane
    % geometry at all (do not need this step for lane sections)
    % tIncrements_NoNanColumns = tOutput(:,any(~isnan(tOutput)));
    tIncrements_NoNanColumns = tOutput;

    % Add up all the increments to determine the total tranverse distances from
    % the centerline
    [tLeftTotalOffsets, tRightTotalOffsets] = fcn_INTERNAL_addLaneIncrements(stationPoints, {stationIndices}, tIncrements_NoNanColumns, laneLinksRow);

    % Plot the left side
    [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tLeftTotalOffsets, 1, plotHandles, plotLabels);

    % Plot the right side
    [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tRightTotalOffsets, -1, plotHandles, plotLabels);

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




%% fcn_ParseXODR_extractFromLaneSection_LaneEdges
function [tRow, outputStationIndices] = fcn_ParseXODR_extractFromLaneSection_LaneEdgesSt(laneSection, laneLinkageRow, laneSectionStationRange, stationPoints)
% Fills the transverse location of the lane edges for the input lane
% section, both right and left sides

% Initialize the output arrays to the transverse coordinates. tRow is a
% cell array that has 1 row (for this lane section), and N columns where N
% is the number of lanes. The number of lanes is given by the number of
% columns in the laneLinkageRow.
tRow = cell(size(laneLinkageRow));
for columnIndex = 1:length(laneLinkageRow(1,:))
    tRow{1,columnIndex} = nan(size(stationPoints));
end

% Initialize the output arrays for the station coordinates
outputStationIndices = [];

% Loop through left and right sides, getting lane edges for each
sideStrings = {'left','right'};
for ith_side = 1:length(sideStrings)
    sideString = sideStrings{ith_side};

    % Does the field exist for this side?
    if isfield(laneSection,sideString)

        % Iterate through all of the side lane elements. Each element is
        % where the geometric description of the lane width is changing.
        NLanesInCurrentLaneSection = length(laneSection.(sideString).lane);
        for sideLaneIndex = 1:NLanesInCurrentLaneSection

            % Get the t-coordinates of this particular lane
            current_lane = laneSection.(sideString).lane{sideLaneIndex};

            % Get the lane index from the XODR structure
            laneID = str2double(current_lane.Attributes.id);

            % Is this laneID listed in this laneLinkageRow? If so, we need to process it
            laneDataIndex = find(laneLinkageRow == laneID);

            if ~isempty(laneDataIndex)

                % Grab this lane edge
                laneEdgeToUpdate = tRow{1,laneDataIndex};

                % Get the current width structure
                current_width = current_lane.width;
                
                % Use width structure to calculate the lane edge transverse
                % position
                [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromLaneWidth_CurveSt(current_width, stationPoints, laneSectionStationRange);

                % Update the matrix that stores the side data. Be sure to
                % correct the width sign if the lane edge is on negative
                % transverse side
                if laneID<0
                    laneEdgeToUpdate(outputStationIndices,:) = tLaneEdge*(-1);
                else
                    laneEdgeToUpdate(outputStationIndices,:) = tLaneEdge;
                end

                % Update the cell array column corresponding to this lane
                tRow{1,laneDataIndex} = laneEdgeToUpdate;
            end

        end
    end % Ends if statement checking if field exists
end % ends looping through sides

end % Ends fcn_ParseXODR_extractFromLaneSection_LaneEdges

%% fcn_INTERNAL_addLaneIncrements
function [tLeftTotalOffsets, tRightTotalOffsets] = fcn_INTERNAL_addLaneIncrements(stations, stationIndices, tIncrements_NoNanColumns, laneLinkages)

laneLinksLeftcolumns  = find(sum(laneLinkages>0,1)>0);
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
end % ends fcn_INTERNAL_addLaneIncrements



