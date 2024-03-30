function tOutput = fcn_ParseXODR_extractFromLaneSection_St(currentLaneSection, stationPoints, laneLinksLeftRow, laneLinksRightRow,laneSectionStationLimits, varargin)
%% fcn_ParseXODR_extractFromLaneSection_St
% Extracts the station and transverse coordinates for the center, left and
% right lanes in a given road.
%
% FORMAT:
%
%       [stationPoints,tLeft,transverseCenterOffsets,tRight] = fcn_ParseXODR_extractFromLaneSection_St(ODRRoad, maxPlotGap, (fig_num))
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
%       See the script: script_test_fcn_ParseXODR_extractFromLaneSection_St.m for a
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
% fcn_ParseXODR_extractFromLaneSection_St

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==6 && isequal(varargin{end},-1))
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
        narginchk(5,6);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end

% Does user want to specify fig_num?
fig_num = []; %#ok<NASGU> % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (6<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp; %#ok<NASGU>
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
% Left side:
[tLeftOutputRow, stationIndicesLeft]  = ...
    fcn_ParseXODR_extractFromLaneSection_LaneEdges(...
    currentLaneSection,...
    'left',...
    laneLinksLeftRow,...
    laneSectionStationLimits,...
    stationPoints);

% Right side:
[tRightOutputRow, stationIndicesRight] = ...
    fcn_ParseXODR_extractFromLaneSection_LaneEdges(...
    currentLaneSection,...
    'right', ...
    laneLinksRightRow,...
    laneSectionStationLimits,...
    stationPoints);

% Convert cell arrays into matricies
tOutput = nan(length(stationPoints(:,1)),(length(laneLinksLeftRow(1,:)) + length(laneLinksRightRow(1,:))));

for columnIndex = 1:length(laneLinksLeftRow(1,:))
    tOutput(stationIndicesLeft,columnIndex) = tLeftOutputRow{1,columnIndex}(stationIndicesLeft,1);
end
for columnIndex = (1+length(laneLinksLeftRow(1,:))):(length(laneLinksRightRow(1,:))+length(laneLinksLeftRow(1,:)))
    tOutput(stationIndicesLeft,columnIndex) = tRightOutputRow{1,columnIndex-length(laneLinksLeftRow(1,:))}(stationIndicesLeft,1);
end
% 
% tLeftOutput = nan(length(stationPoints(:,1)),length(laneLinksLeftRow(1,:)));
% for columnIndex = 1:length(laneLinksLeftRow(1,:))
%     tLeftOutput(stationIndicesLeft,columnIndex) = tLeftOutputRow{1,columnIndex}(stationIndicesLeft,1);
% end
% 
% tRightOutput = nan(length(stationPoints(:,1)),length(laneLinksRightRow(1,:)));
% for columnIndex = 1:length(laneLinksRightRow(1,:))
%     tRightOutput(stationIndicesLeft,columnIndex) = tRightOutputRow{1,columnIndex}(stationIndicesLeft,1);
% end

% tOutput = [tLeftOutput, tRightOutput];

if ~isequal(stationIndicesLeft,stationIndicesRight)
    warning('An unexpected error occurred - expecting stations to match on right and left side.');
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
    % temp_h = figure(fig_num);
    % flag_rescale_axis = 0;
    % if isempty(get(temp_h,'Children'))
    %     flag_rescale_axis = 1;
    % end
    % 
    % 
    % % St coordinates plotting
    % % Plot the lane lines in (s,t) coordinates for illustrative/debugging
    % % purposes
    % figure(fig_num+1)
    % clf
    % hold on
    % grid on
    % 
    % title('St coordinate view');
    % xlabel('S coordinate [m]')
    % ylabel('t coordinate [m]')
    % 
    % % Plot the centerline
    % hC = plot(stationPoints,transverseCenterOffsets,'k--','linewidth',1.5);
    % plotHandles = hC;
    % plotLabels = {'Center Lane'};
    % 
    % % Plot the left side
    % [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tLeft, 1, plotHandles, plotLabels);
    % 
    % % Plot the right side
    % [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tRight, -1, plotHandles, plotLabels);
    % 
    % legend(plotHandles,plotLabels)
    % 
    % 
    % % Make axis slightly larger?
    % if flag_rescale_axis
    %     temp = axis;
    %     %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
    %     axis_range_x = temp(2)-temp(1);
    %     axis_range_y = temp(4)-temp(3);
    %     percent_larger = 0.3;
    %     axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    % end

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



%% fcn_ParseXODR_extractFromLaneSection_LaneEdges
function [tSide, outputStationIndices] = fcn_ParseXODR_extractFromLaneSection_LaneEdges(laneSection, sideString, laneLinkageRow, laneSectionStationRange, stationPoints)
% Fills the transverse location of the lane edges for the input lane
% section, either right or left side

%% FIX THIS TO TAKE BOTH RIGHT AND LEFT AT SAME TIME

% Initialize the output arrays to the transverse coordinates
tSide = cell(size(laneLinkageRow));
for columnIndex = 1:length(laneLinkageRow(1,:))
    tSide{1,columnIndex} = nan(size(stationPoints));
end
% Initialize the output arrays for the station coordinates
outputStationIndices = [];


% Are we solving the right or left side?
switch lower(sideString)
    case {'left'}
        side_multiplier = 1;
    case {'right'}
        side_multiplier = -1;
    otherwise
        error('Unrecognized sideString: %s',sideString)
end

if isfield(laneSection,sideString)
    % Iterate through all of the side lane elements
    NleftLanesInCurrentLaneSection = length(laneSection.(sideString).lane);
    for sideLaneIndex = 1:NleftLanesInCurrentLaneSection

        % Get the t-coordinates of this particular lane
        current_lane = laneSection.(sideString).lane{sideLaneIndex};

        % Get the lane index from the XODR structure
        laneID = str2double(current_lane.Attributes.id);

        % Is this laneID listed in this laneLinkageRow? If so, we need to process it
        laneDataIndex = find(laneLinkageRow == side_multiplier*laneID);

        if ~isempty(laneDataIndex)

            % Grab this lane edge
            laneEdgeToUpdate = tSide{1,laneDataIndex};

            % Get the current width descriptor
            current_width = current_lane.width;

            [tLaneEdge, outputStationIndices] = fcn_ParseXODR_extractFromWidth_LaneEdges(current_width, laneSectionStationRange, stationPoints);

            % Update the matrix that stores the side data
            laneEdgeToUpdate(outputStationIndices,:) = tLaneEdge*side_multiplier;

            tSide{1,laneDataIndex} = laneEdgeToUpdate;
        end

    end
end

end % Ends fcn_ParseXODR_extractFromLaneSection_LaneEdges


%% fcn_ParseXODR_extractFromLane_LaneEdges
function [tLane, outputStationIndices] = fcn_ParseXODR_extractFromWidth_LaneEdges(current_width, laneSectionStationRange, stationPoints)
laneSecStart = laneSectionStationRange(1);
laneSecEnd   = laneSectionStationRange(2);


% Find how many lane widths are given for this side
Nwidths = length(current_width);

if ~iscell(current_width)
    current_width = {current_width};
end

% Loop through all the widths
for widthIndex = 1:Nwidths
    % Grab the coefficients for poly fitting
    a = str2double(current_width{widthIndex}.Attributes.a);
    b = str2double(current_width{widthIndex}.Attributes.b);
    c = str2double(current_width{widthIndex}.Attributes.c);
    d = str2double(current_width{widthIndex}.Attributes.d);

    % Grab the station offset
    sOffset = str2double(current_width{widthIndex}.Attributes.sOffset);

    % Find stations where the width function description starts and ends
    stationWhereWidthStarts = laneSecStart + sOffset;
    if widthIndex == Nwidths
        stationWhereWidthEnds = laneSecEnd;
    else
        stationWhereWidthEnds = str2double(current_width{widthIndex+1}.Attributes.sOffset);
    end

    % Determine which of the indices in the s-direction are affected by
    % this offset descriptor
    outputStationIndices = find(stationPoints >= stationWhereWidthStarts & stationPoints <= stationWhereWidthEnds);

    % Now calculate the t coordinate of the left line at each of the
    % affected points
    ds = stationPoints(outputStationIndices)-stationWhereWidthStarts;
    tLane = a + b*ds + c*ds.^2 + d*ds.^3;

end

end % ends fcn_ParseXODR_extractFromLane_LaneEdges
