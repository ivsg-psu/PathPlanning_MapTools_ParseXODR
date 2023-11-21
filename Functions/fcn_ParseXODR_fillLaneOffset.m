function laneOffset = fcn_ParseXODR_fillLaneOffset(laneOffset, s, a, b, c, d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_fillLaneOffset
% Fills in the attributes for a lane offset structure in an XODR file.
%
% FORMAT:
%
%       fcn_ParseXODR_fillLaneOffset(laneOffset, s, a, b, c, d)
%
% INPUTS:
%
%      laneOffset: The lane offset structure to be filled
%
%      s: The s-coordinate value
%
%      a, b, c, d: Polynomial coefficients defining the lane offset
%
% OUTPUTS:
%
%      laneOffset: The updated lane offset structure with new attributes
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
    if nargin ~= 6
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


% Fill in the lane offset attributes
laneOffset.Attributes.s = num2str(s);
laneOffset.Attributes.a = num2str(a);
laneOffset.Attributes.b = num2str(b);
laneOffset.Attributes.c = num2str(c);
laneOffset.Attributes.d = num2str(d);

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

