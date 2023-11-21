function sectionStruct = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane, ...
    numOfRightLane,speedlimit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_createStructForLaneSection
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
    if nargin ~= 3
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

    sectionStruct.rightWidthStruct = rightWidthStruct;
    sectionStruct.rightMarkStruct = rightMarkStruct;
    sectionStruct.rightSpeedStruct = rightSpeedStruct;
end

% Construct left lane structures if any
if numOfLeftLane >= 1
    leftWidthStruct(1:numOfLeftLane) = widthStruct;
    leftMarkStruct(1:numOfLeftLane) = markStruct;
    leftSpeedStruct(1:numOfLeftLane) = speedStruct;

    sectionStruct.leftWidthStruct = leftWidthStruct;
    sectionStruct.leftMarkStruct = leftMarkStruct;
    sectionStruct.leftSpeedStruct = leftSpeedStruct;
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
    for ii = 1:numOfRightLane-1
        rightMarkStruct(ii).Attributes.type = 'broken';
    end
end

% Update marking type for multiple left lanes
if numOfLeftLane >= 2
    for ii = 1:numOfLeftLane-1
        leftMarkStruct(ii).Attributes.type = 'broken';
    end
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