function [laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, varargin)
%% fcn_ParseXODR_extractFromLanes_LaneLinkages
% Given a lanes structure, loops through all the laneSections and in each
% laneSection, finds which lane IDs in one section are connected to which
% lane IDs in other sections. This produces two matricies wherein the rows
% indicate the presence and ordering of lanes in a section, and the column
% numbering indicates the ID of lanes that are active.
%
% FORMAT:
%
%       [laneLinksLeft, laneLinksRight] = fcn_ParseXODR_extractFromLanes_LaneLinkages(lanesStructure, (fig_num))
%
% INPUTS:
%
%      lanesStructure: the lanes subfield for an XODRRoad
%
%
% (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%       [laneLinksLeft, laneLinksRight]: the [SxL] matricies indicating
%       connectivity, where S is the number of lane sections and L are the
%       number of linked lanes. Each column indicates the lane number, so
%       that column 1 represents how lane 1 is connected, column 2
%       represents how lane 2 is connected, etc. The number in each element
%       indicates the numbering, relative to the centerline, of that
%       particular lane. Thus, if a number that is on row 3 and column 4
%       indicates a 2 in the lanesLinksRight matrix, this indicates that,
%       in lane section 3, the lane that is numbered 4 will be the second
%       one over to the right relative to the centerline. NaN values mean
%       that the respective lane numbering for that column is not present
%       in the lane section.
%
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_extractFromLanes_LaneLinkages
%       for a full test suite.
%
% This function was by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2024_03_24 - S. Brennan
% -- original write of function


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==2 && isequal(varargin{end},-1))
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
        narginchk(1,2);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end


% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (2<= nargin)
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


% Determine the number of lane sections in the current road (there should
% always be at least one)
NlaneSections = length(lanesStructure.laneSection);

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
    [laneLinksLeft,  leftLanesStarted]  = fcn_INTERNAL_extractLaneLinkageFromSide(lanesStructure.laneSection{laneSectionIndex}, laneSectionIndex, 'left', leftLanesStarted, laneLinksLeft);
    [laneLinksRight, rightLanesStarted] = fcn_INTERNAL_extractLaneLinkageFromSide(lanesStructure.laneSection{laneSectionIndex}, laneSectionIndex, 'right', rightLanesStarted, laneLinksRight);
end % ends looping through laneSections


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

    % Grab colors to use
    try
        color_ordering = orderedcolors('gem12');
    catch
        color_ordering = colororder;
    end
    N_colors = length(color_ordering(:,1)); %#ok<NASGU>



    fprintf(1,'\n\nLANE LINKAGES: \nLaneLinksLeft: \n');
    disp(laneLinksLeft);
    fprintf(1,'LaneLinksRight: \n');
    disp(laneLinksRight);

   
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
