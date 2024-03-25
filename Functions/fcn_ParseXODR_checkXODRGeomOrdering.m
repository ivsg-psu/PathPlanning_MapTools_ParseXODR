function [ODRStruct_fixed, flag_warnings_were_found] = fcn_ParseXODR_checkXODRGeomOrdering(ODRStruct, varargin)
%% fcn_ParseXODR_checkXODRGeomOrdering
% A function to check that the geometric station progression within each
% road of an ODRStruct is strictly increasing. If the station progression
% is not increasing in the geometry orderings, the orderings are fixed
% and a flag_warnings_were_found is set to 1.
%
% FORMAT:
%
%       ODRStruct = fcn_ParseXODR_checkXODRGeomOrdering(ODRStruct))
%
% INPUTS:
%
%      ODRStruct: a nested structure containing the XDOR map elements
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed. If set to positive value, also sets the
%      results to be "verbose", e.g. to write messages to the screen at
%      each testing stage.
%
% OUTPUTS:
%
%      ODRStruct_fixed: a nested structure containing the XDOR map elements, with
%         the proper characteristics confirmed
%
%      flag_warnings_were_found: returns 1 if there was a fixable warning
%      produced in the processing
%
% DEPENDENCIES:
%
%      None
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_checkXODRGeomOrdering for a
%       full test suite.
%
% This function was orginally written by C. Beal as the function
% fcn_RoadSeg_XODRSegmentChecks, now maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_03_20 - C. Beal
% -- wrote the code
% 2024_03_23 - S. Brennan
% -- renamed the function to fcn_ParseXODR_checkXODRGeomOrdering
% -- added fast mode and system-level debugging flags
% -- added test script
% -- added debug and function areas back in


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==2 && isequal(varargin{end},-1))
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if 0==flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(1,2);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end

% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
flag_be_verbose = 0;
if (0==flag_max_speed) && (2<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
        flag_be_verbose = 1;
    end
end

%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ODRStruct_fixed = ODRStruct;

flag_warnings_were_found = 0;

% Check for out of order segments (by station) and reorder properly
if flag_be_verbose
    fprintf(1,'Checking XODR structure for road geometry segment order...\n');
end

% Grab all the roads
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct.OpenDRIVE);

% Determine the number of roads in the map
Nroads = length(roads);

%% Check road geometries
% Preallocate a vector to store the number of geometry segments in each
% road
NgeomElems = zeros(Nroads,1);

% Iterate through all of the roads
for roadInd = 1:Nroads
    current_road = roads{roadInd};
    planView_geometry = current_road.planView.geometry;
    roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, -1);
    sVals = roadSegmentStations(:,1);

    % Determine the number of geometry segments in the active road
    NgeomElems(roadInd) = length(planView_geometry);


    % Check to see if there are any negative differences between subsequent
    % segments, indicating an out of order segment (by station)
    if any(sign(diff(sVals)) < 0)
        flag_warnings_were_found = 1;
        if flag_be_verbose
            fprintf(1,'   Warning: XODR file is malformed. Road %s has geometry segments with non-monotonically increasing stations.\n',current_road.Attributes.id)
        end

        % Create an index vector in order by starting station
        [~,sortInds] = sort(sVals);
        % Create a temporary copy of the road geometry
        temp = planView_geometry;


        % Iterate through the total number of geometry segments and copy
        % fixed order into the output
        for geomInd = 1:NgeomElems(roadInd)
            % Place the geometry from the temporary copy back into the original
            % cell array of geometry elements, but in order by the sort indices
            ODRStruct_fixed.OpenDRIVE.road{roadInd}.planView.geometry{geomInd} = temp{sortInds(geomInd)};
        end
        if flag_be_verbose
            fprintf(1,'   Segments reordered. Checking downstream results recommended.\n');
        end
    end
end
if flag_be_verbose
    fprintf(1,'   Road geometry segment order check complete.\n');
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

    hold on;
    grid on;
    axis equal


    % Set up labels and title
    xlabel('East (m)')
    ylabel('North (m)')
    title('XY view')



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
