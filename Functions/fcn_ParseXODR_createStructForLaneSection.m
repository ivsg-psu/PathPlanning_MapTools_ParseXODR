function sectionStruct = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane, ...
    numOfRightLane,speedlimit, varargin)
%% fcn_ParseXODR_createStructForLaneSection
% Creates a structure for a lane section in an XODR file.
%
% FORMAT:
%
%       fcn_ParseXODR_createStructForLaneSection(numOfLeftLane, numOfRightLane, speedlimit)
%
% INPUTS:
%
%      numOfLeftLane: Number of lanes on the left side of the road
%
%      numOfRightLane: Number of lanes on the right side of the road
%
%      speedlimit: Speed limit for the section (in mph)
%
%      (OPTIONAL INPUTS)
% 
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      sectionStruct: Struct containing lane section data
%
% DEPENDENCIES:
%
%      NA
%
% EXAMPLES:
%
%      See script_ParseXODR_createScenario1_5.m for a comprehensive test
%      suite.
%
% This function was written by Wushuang Bai, maintained by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_11_10 - W. Bai.
% -- Added initial code structure
% 2023_11_20 - W. Bai.
% -- Enhanced with additional comments
% 2024_03_09 - S. Brennan
% -- reformatted to standard template


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==4 && isequal(varargin{end},-1))
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
        narginchk(3,4);

        % % Check the projection_vector input to be length greater than or equal to 1
        % fcn_DebugTools_checkInputsToFunctions(...
        %     input_vectors, '2or3column_of_numbers');

    end
end


% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (4<= nargin)
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


% Initialize lane width structure
widthStruct.Attributes.a = '3.65';
widthStruct.Attributes.b = '0';
widthStruct.Attributes.c = '0';
widthStruct.Attributes.d = '0';
widthStruct.Attributes.sOffset = '0';

% Initialize lane marking structure
markStruct.Attributes = struct();
markStruct.Attributes.color = 'white';
markStruct.Attributes.laneChange = 'none';
markStruct.Attributes.material = 'standard';
markStruct.Attributes.sOffset = '0';
markStruct.Attributes.type = 'solid';
markStruct.Attributes.weight = 'standard';
markStruct.Attributes.width = '0.125';

% Initialize speed limit structure
speedStruct.Attributes = struct();
speedStruct.Attributes.max = num2str(speedlimit);
speedStruct.Attributes.sOffset = '0';
speedStruct.Attributes.unit = 'mph';

% Construct right lane structures if any
if numOfRightLane >= 1
    rightWidthStruct(1:numOfRightLane) = widthStruct;
    rightMarkStruct(1:numOfRightLane) = markStruct;
    rightSpeedStruct(1:numOfRightLane) = speedStruct;
end

% Construct left lane structures if any
if numOfLeftLane >= 1
    leftWidthStruct(1:numOfLeftLane) = widthStruct;
    leftMarkStruct(1:numOfLeftLane) = markStruct;
    leftSpeedStruct(1:numOfLeftLane) = speedStruct;
end

% Define the center lane marking parameters
sectionStruct.centerMarkStruct(1).Attributes = struct();
sectionStruct.centerMarkStruct(1).Attributes.color = 'yellow';
sectionStruct.centerMarkStruct(1).Attributes.laneChange = 'none';
sectionStruct.centerMarkStruct(1).Attributes.material = 'standard';
sectionStruct.centerMarkStruct(1).Attributes.sOffset = '0';
sectionStruct.centerMarkStruct(1).Attributes.type = 'solid solid';
sectionStruct.centerMarkStruct(1).Attributes.weight = 'standard';
sectionStruct.centerMarkStruct(1).Attributes.width = '0.125';

% Update marking type for multiple right lanes
if numOfRightLane >= 2
    for ithLane = 1:numOfRightLane-1
        rightMarkStruct(ithLane).Attributes.type = 'broken';
    end
end

% Update marking type for multiple left lanes
if numOfLeftLane >= 2
    for ithLane = 1:numOfLeftLane-1
        leftMarkStruct(ithLane).Attributes.type = 'broken';
    end
end

if numOfRightLane>=1
    sectionStruct.rightWidthStruct = rightWidthStruct;
    sectionStruct.rightMarkStruct = rightMarkStruct;
    sectionStruct.rightSpeedStruct = rightSpeedStruct;
end

if numOfLeftLane>=1
    sectionStruct.leftWidthStruct = leftWidthStruct;
    sectionStruct.leftMarkStruct = leftMarkStruct;
    sectionStruct.leftSpeedStruct = leftSpeedStruct;
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

    hold on
    grid on
    axis equal
    xlabel('East (m)')
    ylabel('North (m)')


  % NOTHING TO PLOT


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
