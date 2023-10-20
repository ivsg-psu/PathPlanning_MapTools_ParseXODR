function road = fcn_ParseXODR_createEmptyRoad
%% fcn_LoadWZ_fillEmptyLane
% Fills an empty Lane structure 
%
% FORMAT:
%
%       EmptyLane = fcn_LoadWZ_fillEmptyLane
%
% INPUTS:
%
%      (none)
%
%
% OUTPUTS:
%
%      EmptyLane: a structural array containaing key fields defining a road
%      complying with ASAM OPENDRIVE standard
%     
%
% DEPENDENCIES:
%
%       NA
%
%
% This function was written on 2023 10 19 by W. Bai
% Questions or comments? wxb41@psu.edu


% Revision history:
% 2023 10 19: start writing function
flag_do_plots = 0;
flag_do_debug = 0; % Flag to plot the results for debugging
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 34838;
else
    debug_fig_num = [];  %#ok<NASGU>
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

if flag_check_inputs == 1
    % Are there the right number of inputs?
    narginchk(0,0);
end

% the inputs are compulsory
%% Write main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Create the top-level structure
road = struct();

% Create the nested OpenDRIVE structure
road.OpenDRIVE = struct();

% Assuming the 'road' field in 'OpenDRIVE' is a cell array
road.OpenDRIVE.road = cell(1, 1); % Initialize cell array

% Create the nested structure inside the cell
road.OpenDRIVE.road{1, 1} = struct();
road.OpenDRIVE.header = struct();

% Create the 'Attributes' substructure within 'header'
road.OpenDRIVE.header.Attributes = struct();
road.OpenDRIVE.header.Attributes.date = '';
road.OpenDRIVE.header.Attributes.east = '';
road.OpenDRIVE.header.Attributes.name = '';
road.OpenDRIVE.header.Attributes.north = '';
road.OpenDRIVE.header.Attributes.revMajor = '';
road.OpenDRIVE.header.Attributes.revMinor = '';
road.OpenDRIVE.header.Attributes.south = '';
road.OpenDRIVE.header.Attributes.vendor = '';
road.OpenDRIVE.header.Attributes.version = '';
road.OpenDRIVE.header.Attributes.west = '';

% Create the 'Attributes' substructure within the nested 'road'
road.OpenDRIVE.road{1, 1}.Attributes = struct();
road.OpenDRIVE.road{1, 1}.Attributes.id = '';
road.OpenDRIVE.road{1, 1}.Attributes.junction = '';
road.OpenDRIVE.road{1, 1}.Attributes.length = '';
road.OpenDRIVE.road{1, 1}.Attributes.name = '';
road.OpenDRIVE.road{1, 1}.Attributes.rule = '';

% create 'type' under road{1,1}

road.OpenDRIVE.road{1, 1}.type.speed.Attributes.max = '';
road.OpenDRIVE.road{1, 1}.type.speed.Attributes.unit = '';
road.OpenDRIVE.road{1, 1}.type.Attributes.s = '';
road.OpenDRIVE.road{1, 1}.type.Attributes.type = '';

% Create the 'planView' structure within road.OpenDRIVE.road{1, 1}
road.OpenDRIVE.road{1, 1}.planView = struct();

% Create the nested 'geometry' structure within 'planView'
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1} = struct();

% Create the 'Attributes' substructure within 'geometry'
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes = struct();
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.hdg = '';
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.length = '';
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.s = '';
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.x = '';
road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.y = '';

road.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.line = struct();

% Create the 'elevationProfile' structure within road.OpenDRIVE.road{1, 1}
road.OpenDRIVE.road{1, 1}.elevationProfile = struct();

% Create the nested 'elevation' structure within 'elevationProfile'
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation = struct();

% Create the 'Attributes' substructure within 'elevation'
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes = struct();
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.a = '';
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.b = '';
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.c = '';
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.d = '';
road.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.s = '';

% Create the 'lateralProfile' structure within road.OpenDRIVE.road{1, 1}
road.OpenDRIVE.road{1, 1}.lateralProfile = struct();

% Create the nested 'superelevation' structure within 'lateralProfile'
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation = struct();

% Create the 'Attributes' substructure within 'superelevation'
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.a = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.b = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.c = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.d = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.s = '';

% Create the 'shape' structure within road.OpenDRIVE.road{1, 1}.lateralProfile
road.OpenDRIVE.road{1, 1}.lateralProfile.shape = struct();

% Create the 'Attributes' substructure within 'shape'
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.a = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.b = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.c = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.d = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.s = '';
road.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.t = '';

% Create the 'laneOffset' structure within road.OpenDRIVE.road{1, 1}.lanes
road.OpenDRIVE.road{1, 1}.lanes.laneOffset = struct();

% Create the 'Attributes' substructure within 'laneOffset'
road.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.a = '';
road.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.b = '';
road.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.c = '';
road.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.d = '';
road.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.s = '';

% create laneSection attributes
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.Attributes.s = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.Attributes.singleSide = '';

% create left lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.Attributes.id = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.Attributes.level = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.Attributes.type = '';

% Create the 'width' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width = struct();

% Create the 'Attributes' substructure within 'width'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width.Attributes.a = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width.Attributes.b = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width.Attributes.c = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width.Attributes.d = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.width.Attributes.sOffset = '';

% Create the 'roadMark' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.color = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.laneChange = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.material = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.sOffset = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.type = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.weight = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.roadMark.Attributes.width = '';

% Create the 'speed' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.speed = struct();

% Create the 'Attributes' substructure within 'speed'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.speed.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.speed.Attributes.max = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.speed.Attributes.sOffset = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane.speed.Attributes.unit = '';

% create attributes for center lane

road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.id = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.level = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.type = '';

% Create the 'roadMark' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.color = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.laneChange = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.material = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.sOffset = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.type = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.weight = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.width = '';

road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.Attributes.id = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.Attributes.level = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.Attributes.type = '';

% Create the 'width' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width = struct();

% Create the 'Attributes' substructure within 'width'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width.Attributes.a = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width.Attributes.b = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width.Attributes.c = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width.Attributes.d = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.width.Attributes.sOffset = '';

% Create the 'roadMark' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.color = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.laneChange = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.material = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.sOffset = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.type = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.weight = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.roadMark.Attributes.width = '';

% Create the 'speed' structure within road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.speed = struct();

% Create the 'Attributes' substructure within 'speed'
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.speed.Attributes = struct();
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.speed.Attributes.max = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.speed.Attributes.sOffset = '';
road.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane.speed.Attributes.unit = '';
% create attributes for object
road.OpenDRIVE.road{1,1}.objects.object.Attributes.id = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.name = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.s = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.t = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.zoffset = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.hdg = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.roll = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.pitch = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.orientation = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.type = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.height = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.radius = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.validLength = '';
road.OpenDRIVE.road{1,1}.objects.object.Attributes.dynamic = '';
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
    % Nothing to plot
end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end
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
