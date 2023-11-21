function roads = fcn_ParseXODR_fillRoadType(roads, speedLimit)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_fillRoadType
% Fills in the road type and speed limit for a road in an OpenDRIVE structure.
%
% FORMAT:
%
%       roads = fcn_ParseXODR_fillRoadType(roads, speedLimit)
%
% INPUTS:
%
%      roads: The OpenDRIVE road structure to be updated
%
%      speedLimit: The speed limit to be set for the road (in mph)
%
% OUTPUTS:
%
%      roads: The updated OpenDRIVE road structure with road type and speed limit set
%
% DEPENDENCIES:
%
%      NA
%
% EXAMPLES:
%
%      see script_ParseXODR_createScenario1_5.m for a comprehensive test
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
    if nargin ~= 2
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

% Set the starting point of the road type attribute
roads.OpenDRIVE.road{1}.type.Attributes.s = '0';

% Set the road type as 'town'
roads.OpenDRIVE.road{1}.type.Attributes.type = 'town';

% Set the maximum speed limit for the road
roads.OpenDRIVE.road{1}.type.speed.Attributes.max = num2str(speedLimit);

% Set the unit for the speed limit (miles per hour)
roads.OpenDRIVE.road{1}.type.speed.Attributes.unit = 'mph';

end % Ends the function
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
