function road = fcn_ParseXODR_fillDefaultRoad(varargin)
%% fcn_ParseXODR_fillDefaultOpenDRIVE
% Fills the default OpenDRIVE structure. This is the header under the
% top-most structure in the XODR specification, for example:
%
%  testTrack.road{1,1}
%
% FORMAT:
%
%       road = fcn_ParseXODR_fillDefaultRoad
%
% INPUTS:
%
%      (none)
%
%
% OUTPUTS:
%
%      road: a structure containing the following elements with
%      default settings, such that each setting complies with ASAM
%      OPENDRIVE standard for the "road" field under the OpenDRIVE
%      structure:
%
%        road.Attributes
%        road.Attributes
%        road.Attributes
%        road.Attributes
%        road.Attributes
%        road.Attributes
%     
%
% DEPENDENCIES:
%
%       NA
%
% EXAMPLES:
%      
% See the script: script_test_fcn_ParseXODR_fillDefaultRoad
% for a full test suite.
%
% This function was written on 2024_03_06 by S. Brennan
% Questions or comments? sbrennan@psu.edu


% Revision history:
% 2024_03_06 -  S. Brennan
% -- start writing function


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==1 && isequal(varargin{end},-1))
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
        narginchk(0,1);

        % % Check the projection_vector input to be length greater than or equal to 1
        % fcn_DebugTools_checkInputsToFunctions(...
        %     input_vectors, '2or3column_of_numbers');

    end
end

% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (1<= nargin)
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

% Initialize the empty road
road   = cell(1, 1); % Initialize cell array

% Create the nested structure inside the cell
road{1, 1} = struct();

% Create the 'Attributes' under road{1,1} substructure within the nested
% 'road' Assuming the 'road' field in 'OpenDRIVE' is a cell array
road{1, 1}.Attributes = struct();
road{1, 1}.Attributes.id = '0';
road{1, 1}.Attributes.junction = '-1';
road{1, 1}.Attributes.length = '0';
road{1, 1}.Attributes.name = 'Road 0';
road{1, 1}.Attributes.rule = 'RHT';

% create 'type' under road{1,1}
road{1, 1}.type.speed.Attributes.max = '';
road{1, 1}.type.speed.Attributes.unit = '';
road{1, 1}.type.Attributes.s = '';
road{1, 1}.type.Attributes.type = '';

% Create the 'planView' structure within road{1, 1}
road{1, 1}.planView = struct();

% Create the nested 'geometry' structure within 'planView'
road{1, 1}.planView.geometry{1,1} = struct();

% Create the 'Attributes' substructure within 'geometry'
road{1, 1}.planView.geometry{1,1}.Attributes = struct();
road{1, 1}.planView.geometry{1,1}.Attributes.hdg = '';
road{1, 1}.planView.geometry{1,1}.Attributes.length = '';
road{1, 1}.planView.geometry{1,1}.Attributes.s = '';
road{1, 1}.planView.geometry{1,1}.Attributes.x = '';
road{1, 1}.planView.geometry{1,1}.Attributes.y = '';
road{1, 1}.planView.geometry{1,1}.line = struct();

% Create the 'elevationProfile' structure within road{1, 1}
road{1, 1}.elevationProfile = struct();

% Create the nested 'elevation' structure within 'elevationProfile'
road{1, 1}.elevationProfile.elevation = struct();

% Create the 'Attributes' substructure within 'elevation'
road{1, 1}.elevationProfile.elevation.Attributes = struct();
road{1, 1}.elevationProfile.elevation.Attributes.a = '';
road{1, 1}.elevationProfile.elevation.Attributes.b = '';
road{1, 1}.elevationProfile.elevation.Attributes.c = '';
road{1, 1}.elevationProfile.elevation.Attributes.d = '';
road{1, 1}.elevationProfile.elevation.Attributes.s = '';

% Create the 'lateralProfile' structure within road{1, 1}
road{1, 1}.lateralProfile = struct();

% Create the nested 'superelevation' structure within 'lateralProfile'
road{1, 1}.lateralProfile.superelevation = struct();

% Create the 'Attributes' substructure within 'superelevation'
road{1, 1}.lateralProfile.superelevation.Attributes = struct();
road{1, 1}.lateralProfile.superelevation.Attributes.a = '';
road{1, 1}.lateralProfile.superelevation.Attributes.b = '';
road{1, 1}.lateralProfile.superelevation.Attributes.c = '';
road{1, 1}.lateralProfile.superelevation.Attributes.d = '';
road{1, 1}.lateralProfile.superelevation.Attributes.s = '';

% Create the 'shape' structure within road{1, 1}.lateralProfile
road{1, 1}.lateralProfile.shape = struct();

% Create the 'Attributes' substructure within 'shape'
road{1, 1}.lateralProfile.shape.Attributes = struct();
road{1, 1}.lateralProfile.shape.Attributes.a = '';
road{1, 1}.lateralProfile.shape.Attributes.b = '';
road{1, 1}.lateralProfile.shape.Attributes.c = '';
road{1, 1}.lateralProfile.shape.Attributes.d = '';
road{1, 1}.lateralProfile.shape.Attributes.s = '';
road{1, 1}.lateralProfile.shape.Attributes.t = '';

% Create the 'laneOffset' structure within road{1, 1}.lanes
road{1, 1}.lanes.laneOffset = struct();

% Create the 'Attributes' substructure within 'laneOffset'
road{1, 1}.lanes.laneOffset.Attributes = struct();
road{1, 1}.lanes.laneOffset.Attributes.a = '';
road{1, 1}.lanes.laneOffset.Attributes.b = '';
road{1, 1}.lanes.laneOffset.Attributes.c = '';
road{1, 1}.lanes.laneOffset.Attributes.d = '';
road{1, 1}.lanes.laneOffset.Attributes.s = '';

% create laneSection attributes
road{1, 1}.lanes.laneSection{1,1}.Attributes.s = '';
road{1, 1}.lanes.laneSection{1,1}.Attributes.singleSide = '';

% create left lane
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes.id = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes.level = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.Attributes.type = '';

% Create the 'width' structure within road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width = struct();

% Create the 'Attributes' substructure within 'width'
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.a = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.b = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.c = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.d = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.width.Attributes.sOffset = '';

% Create the 'roadMark' structure within road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.color = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.laneChange = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.material = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.sOffset = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.type = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.weight = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.roadMark.Attributes.width = '';

% Create the 'speed' structure within road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed = struct();

% Create the 'Attributes' substructure within 'speed'
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes.max = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes.sOffset = '';
road{1, 1}.lanes.laneSection{1,1}.left.lane{1,1}.speed.Attributes.unit = '';

% create attributes for center lane

road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.id = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.level = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.Attributes.type = '';

% Create the 'roadMark' structure within road{1, 1}.lanes.laneSection{1,1}.center.lane
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.color = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.laneChange = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.material = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.sOffset = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.type = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.weight = '';
road{1, 1}.lanes.laneSection{1,1}.center.lane.roadMark.Attributes.width = '';

road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes.id = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes.level = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.Attributes.type = '';

% Create the 'width' structure within road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width = struct();

% Create the 'Attributes' substructure within 'width'
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.a = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.b = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.c = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.d = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.width.Attributes.sOffset = '';

% Create the 'roadMark' structure within road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark = struct();

% Create the 'Attributes' substructure within 'roadMark'
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.color = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.laneChange = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.material = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.sOffset = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.type = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.weight = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.roadMark.Attributes.width = '';

% Create the 'speed' structure within road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed = struct();

% Create the 'Attributes' substructure within 'speed'
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes = struct();
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes.max = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes.sOffset = '';
road{1, 1}.lanes.laneSection{1,1}.right.lane{1,1}.speed.Attributes.unit = '';

% create attributes for object
road{1,1}.objects.object{1}.Attributes.id = '';
road{1,1}.objects.object{1}.Attributes.name = '';
road{1,1}.objects.object{1}.Attributes.s = '';
road{1,1}.objects.object{1}.Attributes.t = '';
road{1,1}.objects.object{1}.Attributes.zoffset = '';
road{1,1}.objects.object{1}.Attributes.hdg = '';
road{1,1}.objects.object{1}.Attributes.roll = '';
road{1,1}.objects.object{1}.Attributes.pitch = '';
road{1,1}.objects.object{1}.Attributes.orientation = '';
road{1,1}.objects.object{1}.Attributes.type = '';
road{1,1}.objects.object{1}.Attributes.height = '';
road{1,1}.objects.object{1}.Attributes.radius = '';
road{1,1}.objects.object{1}.Attributes.validLength = '';
road{1,1}.objects.object{1}.Attributes.dynamic = '';




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
    % 
    % % Plot the input vectors alongside the unit vectors
    % N_vectors = length(input_vectors(:,1));
    % for ith_vector = 1:N_vectors
    %     h_plot = quiver(0,0,input_vectors(ith_vector,1),input_vectors(ith_vector,2),0,'-','LineWidth',3);
    %     plot_color = get(h_plot,'Color');
    %     quiver(0,0,unit_vectors(ith_vector,1),unit_vectors(ith_vector,2),0,'-','LineWidth',1,'Color',(plot_color+[1 1 1])/2,'MaxHeadSize',1);
    % 
    % end
    % 

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

