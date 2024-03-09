function laneSection = fcn_ParseXODR_fillLanes(laneSection, laneKeyWord, section_template, shoulderFlag, varargin)
%% fcn_ParseXODR_fillLanes
% Fills in lane details for a lane section in an OpenDRIVE structure.
%
% FORMAT:
%
%       fcn_ParseXODR_fillLanes(laneSection, laneKeyWord, numOfLanes, widthStruct,
%                               roadMarkStruct, speedStruct, shoulderFlag)
%
% INPUTS:
%
%      laneSection: The lane section structure to be filled
%
%      laneKeyWord: Keyword indicating the lane side ('left', 'right', or 'center')
%
%      section_template: a field containing, for each keyword, the
%      following:
%
%            widthStruct: Structure containing lane width information
%
%            roadMarkStruct: Structure containing road marking details
%
%            speedStruct: Structure containing speed limit information
%
%      shoulderFlag: Flag indicating whether the outermost lane is a shoulder (1) or not (0)
%
% OUTPUTS:
%
%      laneSection: The updated lane section structure
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
% This function was written by Wushuang Bai, and maintained by S. Brennan
% Questions or comments? sbrennan@psu.edu
%
% Revision history:
% 2023_11_10 - W. Bai
% - Added initial code structure
% 2023_11_20 - W. Bai
% - Enhanced with additional comments
% 2024_03_06 -  S. Brennan
% -- functionalized the code 


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

        % % Check the projection_vector input to be length greater than or equal to 1
        % fcn_DebugTools_checkInputsToFunctions(...
        %     input_vectors, '2or3column_of_numbers');

    end
end


% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (5<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  __  __       _
% |  \/  |     (_)
% | \  / | __ _ _ _ __
% | |\/| |/ _` | | '_ \
% | |  | | (_| | | | | |
% |_|  |_|\__,_|_|_| |_|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% How many lanes of this type are there?
numOfLanes = fcn_INTERNAL_countLanesInSectionTemplate(section_template, laneKeyWord);

% Fill in lane details
if 0==numOfLanes
    laneSection.(laneKeyWord) = [];
else

    % Initialize lanes if left or right has more than 1 lane. Copy lane 1
    % into the repeats
    if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
        if numOfLanes >= 2 % initialize empty lane sections
            for ithLane = 2:numOfLanes
                laneSection.(laneKeyWord).lane{1,ithLane} = fcn_ParseXODR_fillDefaultRoadLane(laneKeyWord);
            end
        end
    end

    % Fill lane details for left or right lanes
    if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
        for ithLane = 1:numOfLanes
            % Fill lane ID
            if strcmp(laneKeyWord,'left')
                laneSection.(laneKeyWord).lane{1,ithLane}.Attributes.id = num2str(ithLane);
            elseif strcmp(laneKeyWord,'right')
                laneSection.(laneKeyWord).lane{1,ithLane}.Attributes.id = num2str(-ithLane);
            end
            % Fill lane type
            if 1 == shoulderFlag && ithLane == numOfLanes
                laneSection.(laneKeyWord).lane{1,ithLane}.Attributes.type = 'shoulder';
            else
                laneSection.(laneKeyWord).lane{1,ithLane}.Attributes.type = 'driving';
            end
            % Fill lane level
            laneSection.(laneKeyWord).lane{1,ithLane}.Attributes.level = 'false';
        end
    end

    % Fill details for the center lane
    if strcmp(laneKeyWord,'center')
        laneSection.(laneKeyWord).lane.Attributes.type = 'none';
        laneSection.(laneKeyWord).lane.Attributes.level = 'false';
        laneSection.(laneKeyWord).lane.Attributes.id = '0';
    end

    % Fill width, road marks, and speed for left or right lanes
    if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
        for ithLane = 1:numOfLanes
            StructName = cat(2,laneKeyWord, 'WidthStruct');
            StructContents = section_template.(StructName);
            laneSection.(laneKeyWord).lane{1,ithLane}.width = StructContents(ithLane);

            StructName = cat(2,laneKeyWord, 'MarkStruct');
            StructContents = section_template.(StructName);
            laneSection.(laneKeyWord).lane{1,ithLane}.roadMark = StructContents(ithLane);
            
            StructName = cat(2,laneKeyWord, 'SpeedStruct');
            StructContents = section_template.(StructName);
            laneSection.(laneKeyWord).lane{1,ithLane}.speed = StructContents(ithLane);
        end
    end

    % Fill road marks for the center lane
    if strcmp(laneKeyWord,'center')
        StructName = cat(2,laneKeyWord, 'MarkStruct');
        StructContents = section_template.(StructName);
        laneSection.(laneKeyWord).lane.roadMark =  StructContents;
    end

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

function count = fcn_INTERNAL_countLanesInSectionTemplate(section_template, keyword)
keyword = lower(keyword);
field_to_measure = cat(2,keyword,'MarkStruct');
if ~isfield(section_template,field_to_measure)
    count = 0;
else
    temp = section_template.(field_to_measure);
    count = length(temp);
end
end