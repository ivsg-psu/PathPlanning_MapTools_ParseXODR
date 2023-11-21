function laneSection = fcn_ParseXODR_fillLanes(laneSection, laneKeyWord, numOfLanes, widthStruct, ...
    roadMarkStruct, speedStruct, shoulderFlag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_fillLanes
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
%      numOfLanes: Number of lanes on the specified side
%
%      widthStruct: Structure containing lane width information
%
%      roadMarkStruct: Structure containing road marking details
%
%      speedStruct: Structure containing speed limit information
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
% This function was written by Wushuang Bai
% Questions or comments? wxb41@psu.edu
%
% Revision history:
% 20231110 - Added initial code structure
% 20231120 - Enhanced with additional comments

flag_do_debug = 1; % Flag to show function info in UI
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end

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


if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin ~= 7
        error('Incorrect number of input arguments')
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

% Initialize lanes if left or right
if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
    if numOfLanes >= 2 % initialize empty lane sections
        for ii = 2:numOfLanes
            laneSection.(laneKeyWord).lane{1,ii} = laneSection.(laneKeyWord).lane{1};
        end
    end
end

% Fill lane details for left or right lanes
if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
    for ii = 1:numOfLanes
        % Fill lane ID
        if strcmp(laneKeyWord,'left')
            laneSection.(laneKeyWord).lane{1,ii}.Attributes.id = num2str(ii);
        elseif strcmp(laneKeyWord,'right')
            laneSection.(laneKeyWord).lane{1,ii}.Attributes.id = num2str(-ii);
        end
        % Fill lane type
        if 1 == shoulderFlag && ii == numOfLanes
            laneSection.(laneKeyWord).lane{1,ii}.Attributes.type = 'shoulder';
        else
            laneSection.(laneKeyWord).lane{1,ii}.Attributes.type = 'driving';
        end
        % Fill lane level
        laneSection.(laneKeyWord).lane{1,ii}.Attributes.level = 'false';
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
    for ii = 1:numOfLanes
        laneSection.(laneKeyWord).lane{1,ii}.width = widthStruct(ii);
        laneSection.(laneKeyWord).lane{1,ii}.roadMark = roadMarkStruct(ii);
        laneSection.(laneKeyWord).lane{1,ii}.speed = speedStruct(ii);
    end
end

% Fill road marks for the center lane
if strcmp(laneKeyWord,'center')
    laneSection.(laneKeyWord).lane.roadMark = roadMarkStruct;
end

end % Ends main function
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
% NA.