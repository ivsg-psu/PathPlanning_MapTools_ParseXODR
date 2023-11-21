function [roads, new_traversal] = fcn_ParseXODR_fillPlanView(roads, roadCenterLine, interval)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_fillPlanView
% Populates the plan view section of an OpenDRIVE road structure.
%
% FORMAT:
%
%       fcn_ParseXODR_fillPlanView(roads, roadCenterLine, interval)
%
% INPUTS:
%
%      roads: Structure representing the roads in the OpenDRIVE format
%
%      roadCenterLine: Coordinates of the road's centerline
%
%      interval: Interval distance for sampling along the road
%
% OUTPUTS:
%
%      roads: Updated roads structure with plan view information
%
%      new_traversal: Resampled traversal structure based on the interval
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

% Convert road centerline to traversal structure
input_traversal = fcn_Path_convertPathToTraversalStructure(roadCenterLine);
new_stations    = (0:interval:input_traversal.Station(end))';
new_traversal = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);
new_traversal.segmentLength = diff(new_traversal.Station);

% Write the new traversal data into the OpenDRIVE structure
for ii = 1:length(new_traversal.segmentLength)
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.hdg = num2str(real(new_traversal.Yaw(ii)));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.length = num2str(new_traversal.segmentLength(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.s = num2str(new_traversal.Station(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.x = num2str(new_traversal.X(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.y = num2str(new_traversal.Y(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.line = struct;
end

% Update the total length of the road
roads.OpenDRIVE.road{1}.Attributes.length = new_traversal.Station(end);

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
