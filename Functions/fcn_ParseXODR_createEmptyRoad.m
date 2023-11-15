function emptyRoad = fcn_ParseXODR_createEmptyRoad
%% fcn_ParseXODR_createEmptyRoad
% Fills an empty road structure 
%
% FORMAT:
%
%       emptyRoad = fcn_ParseXODR_createEmptyRoad
%
% INPUTS:
%
%      (none)
%
%
% OUTPUTS:
%
%      emptyRoad: a structural array containaing key fields defining a road
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
emptyRoad = struct();

% Create the nested OpenDRIVE structure
emptyRoad.OpenDRIVE = struct();

% Assuming the 'road' field in 'OpenDRIVE' is a cell array
emptyRoad.OpenDRIVE.road = cell(1, 1); % Initialize cell array

% Create the nested structure inside the cell
emptyRoad.OpenDRIVE.road{1, 1} = struct();
emptyRoad.OpenDRIVE.header = struct();

% Create the 'Attributes' substructure within 'header'
emptyRoad.OpenDRIVE.header.Attributes = struct();
emptyRoad.OpenDRIVE.header.Attributes.date = '0';
emptyRoad.OpenDRIVE.header.Attributes.east = '0';
emptyRoad.OpenDRIVE.header.Attributes.name = 'HDmap';
emptyRoad.OpenDRIVE.header.Attributes.north = '0';
emptyRoad.OpenDRIVE.header.Attributes.revMajor = '1';
emptyRoad.OpenDRIVE.header.Attributes.revMinor = '6';
emptyRoad.OpenDRIVE.header.Attributes.south = '0';
emptyRoad.OpenDRIVE.header.Attributes.vendor = 'IVSG';
emptyRoad.OpenDRIVE.header.Attributes.version = '1';
emptyRoad.OpenDRIVE.header.Attributes.west = '0';

% Create the 'Attributes' substructure within the nested 'road'
emptyRoad.OpenDRIVE.road{1, 1}.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.Attributes.id = '0';
emptyRoad.OpenDRIVE.road{1, 1}.Attributes.junction = '-1';
emptyRoad.OpenDRIVE.road{1, 1}.Attributes.length = '0';
emptyRoad.OpenDRIVE.road{1, 1}.Attributes.name = 'Road 0';
emptyRoad.OpenDRIVE.road{1, 1}.Attributes.rule = 'RHT';

% create 'type' under road{1,1}

emptyRoad.OpenDRIVE.road{1, 1}.type.speed.Attributes.max = '';
emptyRoad.OpenDRIVE.road{1, 1}.type.speed.Attributes.unit = '';
emptyRoad.OpenDRIVE.road{1, 1}.type.Attributes.s = '';
emptyRoad.OpenDRIVE.road{1, 1}.type.Attributes.type = '';

% Create the 'planView' structure within emptyRoad.OpenDRIVE.road{1, 1}
emptyRoad.OpenDRIVE.road{1, 1}.planView = struct();

% Create the nested 'geometry' structure within 'planView'
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1} = struct();

% Create the 'Attributes' substructure within 'geometry'
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.hdg = '';
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.length = '';
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.s = '';
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.x = '';
emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.Attributes.y = '';

emptyRoad.OpenDRIVE.road{1, 1}.planView.geometry{1,1}.line = struct();

% Create the 'elevationProfile' structure within emptyRoad.OpenDRIVE.road{1, 1}
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile = struct();

% Create the nested 'elevation' structure within 'elevationProfile'
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation = struct();

% Create the 'Attributes' substructure within 'elevation'
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.a = '';
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.b = '';
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.c = '';
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.d = '';
emptyRoad.OpenDRIVE.road{1, 1}.elevationProfile.elevation.Attributes.s = '';

% Create the 'lateralProfile' structure within emptyRoad.OpenDRIVE.road{1, 1}
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile = struct();

% Create the nested 'superelevation' structure within 'lateralProfile'
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation = struct();

% Create the 'Attributes' substructure within 'superelevation'
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.a = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.b = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.c = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.d = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.superelevation.Attributes.s = '';

% Create the 'shape' structure within emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape = struct();

% Create the 'Attributes' substructure within 'shape'
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.a = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.b = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.c = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.d = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.s = '';
emptyRoad.OpenDRIVE.road{1, 1}.lateralProfile.shape.Attributes.t = '';

% Create the 'laneOffset' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset = struct();

% Create the 'Attributes' substructure within 'laneOffset'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.a = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.b = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.c = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.d = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneOffset.Attributes.s = '';

% create laneSection attributes
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.Attributes.s = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.Attributes.singleSide = '';

% create left lane
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes.id = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes.level = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes.type = '';

% Create the 'width' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width = struct();

% Create the 'Attributes' substructure within 'width'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.a = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.b = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.c = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.d = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.sOffset = '';

% Create the 'roadMark' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.color = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.laneChange = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.material = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.sOffset = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.type = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.weight = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.width = '';

% Create the 'speed' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed = struct();

% Create the 'Attributes' substructure within 'speed'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes.max = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes.sOffset = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes.unit = '';

% create attributes for center lane

emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.id = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.level = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.type = '';

% Create the 'roadMark' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.color = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.laneChange = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.material = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.sOffset = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.type = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.weight = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.width = '';

emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes.id = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes.level = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes.type = '';

% Create the 'width' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width = struct();

% Create the 'Attributes' substructure within 'width'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.a = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.b = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.c = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.d = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.sOffset = '';

% Create the 'roadMark' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.color = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.laneChange = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.material = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.sOffset = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.type = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.weight = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.width = '';

% Create the 'speed' structure within emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed = struct();

% Create the 'Attributes' substructure within 'speed'
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes = struct();
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes.max = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes.sOffset = '';
emptyRoad.OpenDRIVE.road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes.unit = '';
% create attributes for object
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.id = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.name = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.s = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.t = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.zoffset = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.hdg = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.roll = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.pitch = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.orientation = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.type = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.height = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.radius = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.validLength = '';
emptyRoad.OpenDRIVE.road{1,1}.objects.object{1}.Attributes.dynamic = '';
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
