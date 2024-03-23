function [ODRStruct_fixed, flag_warnings_were_found] = fcn_ParseXODR_checkXODRSegments(ODRStruct, varargin)
%% fcn_ParseXODR_checkXODRSegments
% Checks that beginning and end points of geometric segments match up.
%
% FORMAT:
%
%       ODRStruct = fcn_ParseXODR_checkXODRSegments(ODRStruct))
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
%      ODRStruct: a nested structure containing the XDOR map elements, with
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
%       See the script: script_test_fcn_ParseXODR_checkXODRSegments for a
%       full test suite.
%
% This function was orginally written by C. Beal as the function
% fcn_RoadSeg_XODRSegmentChecks, now maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_03_20 - C. Beal
% -- wrote the code
% 2024_03_23 - S. Brennan
% -- renamed the function to fcn_ParseXODR_checkXODRSegments
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


%% Check alignment and continuity of segments
% Check to see if end points of segments align in location and heading with
% the following segment
headingDiffThreshold = 0.2*pi/180;  % max 0.2 degree heading mismatch allowed
positionDiffThreshold = 0.1;        % max 0.1 meter position mismatch allowed

NgeomElems = zeros(Nroads,1);

if flag_be_verbose
    fprintf(1,'Checking XODR road geometry segments for continuity of start/end point positions and headings...\n');
end
for roadInd = 1:Nroads
    current_road = roads{roadInd};
    current_geometries = current_road.planView.geometry;

    % Determine the number of geometry segments in the active road
    NgeomElems(roadInd) = length(current_geometries);

    % Gather the segment geometry data for the first segment
    xNext = str2double(current_geometries{1}.Attributes.x);
    yNext = str2double(current_geometries{1}.Attributes.y);
    lNext = str2double(current_geometries{1}.Attributes.length);
    hNext = str2double(current_geometries{1}.Attributes.hdg);

    for geomInd = 1:NgeomElems(roadInd)-1
        % Shift the data from the previous "next" variables into the "current"
        % variables
        xCurrent = xNext; 
        yCurrent = yNext; 
        lCurrent = lNext; 
        hCurrent = hNext;

        % Gather the segment geometry data for the "next" segment
        xNext = str2double(current_geometries{geomInd+1}.Attributes.x);
        yNext = str2double(current_geometries{geomInd+1}.Attributes.y);
        lNext = str2double(current_geometries{geomInd+1}.Attributes.length);
        hNext = str2double(current_geometries{geomInd+1}.Attributes.hdg);

        if isfield(current_geometries{geomInd},'line')
            % Calculate the segment endpoint location and heading for the current
            % segment
            xF = xCurrent + lCurrent*cos(hCurrent);
            yF = yCurrent + lCurrent*sin(hCurrent);
            hF = hCurrent;
        elseif isfield(current_geometries{geomInd},'arc')
            KC = str2double(current_geometries{geomInd}.arc.Attributes.curvature);
            [xF,yF] = fcn_ParseXODR_extractXYfromSTArc(lCurrent,hCurrent,xCurrent,yCurrent,KC);
            hF = hCurrent + KC*lCurrent;

        elseif isfield(current_geometries{geomInd},'spiral')
            KCstart = str2double(current_geometries{geomInd}.spiral.Attributes.curvStart);
            KCend = str2double(current_geometries{geomInd}.spiral.Attributes.curvEnd);
            [xF,yF] = fcn_ParseXODR_extractXYfromSTSpiral(lCurrent,lCurrent,hCurrent,xCurrent,yCurrent,KCstart,KCend);
            %hF = (KCend-KCstart)/lC*lC^2/2 + KCstart*lC + hC;
            hF = (KCend-KCstart)*lCurrent/2 + KCstart*lCurrent + hCurrent;
        else
            flag_warnings_were_found = 1;
            if flag_be_verbose
                fprintf(1,'No geometric description found?');
            end
        end

        % Compare the segment endpoint data to the start data for the next
        % segment
        if abs(xF - xNext) > positionDiffThreshold
            flag_warnings_were_found = 1;
            if flag_be_verbose
                fprintf(1,'   X coordinate of road %s, geometry segment %d, does not match the following segment.\n',...
                    current_road.Attributes.id,geomInd);
            end
        end
        if abs(yF - yNext) > positionDiffThreshold
            flag_warnings_were_found = 1;
            if flag_be_verbose
                fprintf(1,'   Y coordinate of road %s, geometry segment %d, does not match the following segment.\n',...
                    current_road.Attributes.id,geomInd);
            end
        end
        if abs(hF - hNext) > headingDiffThreshold
            flag_warnings_were_found = 1;
            if flag_be_verbose
                fprintf(1,'   Heading of road %s, geometry segment %d, does not match the following segment.\n',...
                    current_road.Attributes.id,geomInd);
            end
        end
    end
end
if flag_be_verbose
    fprintf(1,'   Geometry segment consistency check complete.\n');
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
