function [ODRStruct_fixed, flag_warnings_were_found] = fcn_ParseXODR_checkXODRBoundBox(ODRStruct, varargin)
%% fcn_ParseXODR_checkXODRBoundBox
% Checks that the bounding box of the ODRStruct is correct. If not, it is
% fixed and a flag_warnings_were_found is set to 1.
%
% FORMAT:
%
%       ODRStruct = fcn_ParseXODR_checkXODRBoundBox(ODRStruct))
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
%       See the script: script_test_fcn_ParseXODR_checkXODRBoundBox for a
%       full test suite.
%
% This function was orginally written by C. Beal as the function
% fcn_RoadSeg_XODRSegmentChecks, now maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_03_20 - C. Beal
% -- wrote the code
% 2024_03_23 - S. Brennan
% -- renamed the function to fcn_ParseXODR_checkXODRBoundBox
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


if flag_be_verbose
    fprintf(1,'Checking ODR bounding box values...\n');
end

%% Pull the min and max values for both the East and North directions. 
% If the header attribute does not exist, add the bounding box elements to
% the header structure with zeros and output a warning

if isfield(ODRStruct.OpenDRIVE.header.Attributes,'west')
    west = str2double(ODRStruct.OpenDRIVE.header.Attributes.west);
else
    flag_warnings_were_found = 1;
    west = 0;
    ODRStruct_fixed.OpenDRIVE.header.Attributes.west = num2str(west);
    warning('Non-compliant XODR file, missing west bounding box value in header');
end

if isfield(ODRStruct.OpenDRIVE.header.Attributes,'east')
    east = str2double(ODRStruct.OpenDRIVE.header.Attributes.east);
else
    flag_warnings_were_found = 1;
    east = 0;
    ODRStruct_fixed.OpenDRIVE.header.Attributes.east = num2str(east);
    warning('Non-compliant XODR file, missing east bounding box value in header');
end

if isfield(ODRStruct.OpenDRIVE.header.Attributes,'south')
    south = str2double(ODRStruct.OpenDRIVE.header.Attributes.south);
else
    flag_warnings_were_found = 1;
    south = 0;
    ODRStruct_fixed.OpenDRIVE.header.Attributes.south = num2str(south);
    warning('Non-compliant XODR file, missing south bounding box value in header');
end

if isfield(ODRStruct.OpenDRIVE.header.Attributes,'north')
    north = str2double(ODRStruct.OpenDRIVE.header.Attributes.north);
else
    flag_warnings_were_found = 1;
    north = 0;
    ODRStruct_fixed.OpenDRIVE.header.Attributes.north = num2str(north);
    warning('Non-compliant XODR file, missing north bounding box value in header');
end

%% Grab all the roads
roads = fcn_ParseXODR_extractRoadsFromOpenDRIVE(ODRStruct_fixed.OpenDRIVE);

% Determine the number of roads in the map
Nroads = length(roads);



%% Loop through all the roads to find the true bounding box
NgeomElems = zeros(Nroads,1);

for roadInd = 1:Nroads
    current_road = roads{roadInd};
    current_geometries = current_road.planView.geometry;

    % Determine the number of geometry segments in the active road
    NgeomElems(roadInd) = length(current_geometries);

    for geomInd = 1:NgeomElems(roadInd)
        % Gather the segment geometry data for the "next" segment
        xCurrent = str2double(current_geometries{geomInd}.Attributes.x);
        yCurrent = str2double(current_geometries{geomInd}.Attributes.y);
        lCurrent = str2double(current_geometries{geomInd}.Attributes.length);
        hCurrent = str2double(current_geometries{geomInd}.Attributes.hdg);

        % Determine whether any of the initial points expand the known bounding
        % box of the map in any of the four cardinal directions
        if xCurrent < west
            west = xCurrent;
        end
        if xCurrent > east
            east = xCurrent;
        end
        if yCurrent < south
            south = yCurrent;
        end
        if yCurrent > north
            north = yCurrent;
        end

        if isfield(current_geometries{geomInd},'line')
            % Calculate the segment endpoint location and heading for the final
            % segment. All other segments will have the endpoint tested as the
            % initial point of the following segment
            %if geomInd == NgeomElems(roadInd)
            xMinMax = xCurrent + lCurrent*cos(hCurrent);
            yMinMax = yCurrent + lCurrent*sin(hCurrent);
            %end

        elseif isfield(current_geometries{geomInd},'arc')
            KC = str2double(current_geometries{geomInd}.arc.Attributes.curvature);

            % x = sin(K0*s + h0)/K0 -> dxds = cos(K0*s + h0) -> zero when
            % pi/2 = K0*s + h0 -> s = (pi/2 - h0)/K0 or s = (3*pi/2 - h0)/K0
            % Similarly, y is at a max or min at pi or 2*pi

            % Make sure any headings are bounded between 0 and 2*pi to avoid
            % issues with multiple solutions in the following calcs
            hCurrent = mod(hCurrent,2*pi);
            
            % Determine the s values associated with the critical angles in the x
            % and y directions
            candSValuesX = [(pi/2-hCurrent)/KC; (3*pi/2-hCurrent)/KC];
            candSValuesY = [(pi-hCurrent)/KC; (2*pi-hCurrent)/KC];

            % If this is the last road segment, test the end point in addition.
            % The rest of the end points will get tested as the initial points of
            % the next geometry segment.
            if geomInd == NgeomElems(roadInd)
                candSValuesX = [candSValuesX; lCurrent]; %#ok<AGROW>
                candSValuesY = [candSValuesY; lCurrent]; %#ok<AGROW>
            end

            % Find the X,Y points associated with the min and max s values
            [xMinMax,~] = fcn_ParseXODR_extractXYfromSTArc(candSValuesX(candSValuesX <= lCurrent & candSValuesX > 0),hCurrent,xCurrent,yCurrent,KC);
            [~,yMinMax] = fcn_ParseXODR_extractXYfromSTArc(candSValuesY(candSValuesY <= lCurrent & candSValuesX > 0),hCurrent,xCurrent,yCurrent,KC);

        elseif isfield(current_geometries{geomInd},'spiral')
            KCstart = str2double(current_geometries{geomInd}.spiral.Attributes.curvStart);
            KCend = str2double(current_geometries{geomInd}.spiral.Attributes.curvEnd);

            % Make sure any headings are bounded between 0 and 2*pi to avoid
            % issues with multiple solutions in the following calcs
            while hCurrent > 2*pi
                hCurrent = hCurrent - 2*pi;
            end
            while hCurrent < 0
                hCurrent = hCurrent + 2*pi;
            end

            % The max and min x coordinates will be located at points where
            % cos((KF-K0)/sF*s^2/2 + K0*s + h0) = 0, or where
            % (KF-K0)/sF*s^2/2 + K0*s + h0 = pi/2 or 3*pi/2
            % Similarly, the max and min y coordinates will be located where
            % sin((KF-K0)/sF*s^2/2 + K0*s + h0) = 0, or where
            % (KF-K0)/sF*s^2/2 + K0*s + h0 = pi/2 or 3*pi/2

            % Determine the s values associated with the critical angles in the x
            % and y directions
            if KCstart^2 - 4*(KCend-KCstart)/(2*lCurrent)*(hCurrent-pi/2) > 0
                candSValuesX = roots([(KCend-KCstart)/(2*lCurrent) KCstart hCurrent-pi/2]);
            end
            if KCstart^2 - 4*(KCend-KCstart)/(2*lCurrent)*(hCurrent-3*pi/2) > 0
                candSValuesX = [candSValuesX; roots([(KCend-KCstart)/(2*lCurrent) KCstart hCurrent-3*pi/2])]; %#ok<AGROW>
            end
            if KCstart^2 - 4*(KCend-KCstart)/(2*lCurrent)*(hCurrent-pi) > 0
                candSValuesY = roots([(KCend-KCstart)/(2*lCurrent) KCstart hCurrent-pi]);
            end
            if KCstart^2 - 4*(KCend-KCstart)/(2*lCurrent)*(hCurrent-2*pi) > 0
                candSValuesY = [candSValuesY; roots([(KCend-KCstart)/(2*lCurrent) KCstart hCurrent-2*pi])]; %#ok<AGROW>
            end

            % If this is the last road segment, test the end point in addition.
            % The rest of the end points will get tested as the initial points of
            % the next geometry segment.
            if geomInd == NgeomElems(roadInd)
                candSValuesX = [candSValuesX; lCurrent]; %#ok<AGROW>
                candSValuesY = [candSValuesY; lCurrent]; %#ok<AGROW>
            end

            % Find the X,Y points associated with the min and max s values
            if ~isempty(candSValuesX(candSValuesX <= lCurrent & candSValuesX > 0))
                [xMinMax,~] = fcn_ParseXODR_extractXYfromSTSpiral(candSValuesX(candSValuesX <= lCurrent & candSValuesX > 0),lCurrent,hCurrent,xCurrent,yCurrent,KCstart,KCend);
            end
            if ~isempty(candSValuesY(candSValuesY <= lCurrent & candSValuesY > 0))
                [~,yMinMax] = fcn_ParseXODR_extractXYfromSTSpiral(candSValuesY(candSValuesY <= lCurrent & candSValuesY > 0),lCurrent,hCurrent,xCurrent,yCurrent,KCstart,KCend);
            end
        else
            if flag_be_verbose
                fprintf(1,'Boundary checks not implemented for polynomial road geometry segments\n');
            end
        end

        % Determine whether the endpoint of the geometry segment expands
        % the known bounding box of the map in any of the four cardinal
        % directions
        if min(xMinMax) < west
            west = min(xMinMax);
        end
        if max(xMinMax) > east
            east = max(xMinMax);
        end
        if min(yMinMax) < south
            south = min(yMinMax);
        end
        if max(yMinMax) > north
            north = max(yMinMax);
        end
    end
end

% Write the bounding box info back to the header substructure
bbTol = 0.001; % m
if abs(str2double(ODRStruct_fixed.OpenDRIVE.header.Attributes.east) - east) > bbTol
    flag_warnings_were_found = 1;
    if flag_be_verbose
        fprintf(1,'   East bounds incorrect. Updating bounding box on east edge.\n');
    end
    ODRStruct_fixed.OpenDRIVE.header.Attributes.east = num2str(east);
end
if abs(str2double(ODRStruct_fixed.OpenDRIVE.header.Attributes.west) - west) > bbTol
    flag_warnings_were_found = 1;
    if flag_be_verbose
        fprintf(1,'   West bounds incorrect. Updating bounding box on west edge.\n');
    end
    ODRStruct_fixed.OpenDRIVE.header.Attributes.west = num2str(west);
end
if abs(str2double(ODRStruct_fixed.OpenDRIVE.header.Attributes.south) - south) > bbTol
    flag_warnings_were_found = 1;
    if flag_be_verbose
        fprintf(1,'   South bounds incorrect. Updating bounding box on south edge.\n');
    end
    ODRStruct_fixed.OpenDRIVE.header.Attributes.south = num2str(south);
end
if abs(str2double(ODRStruct_fixed.OpenDRIVE.header.Attributes.north) - north) > bbTol
    flag_warnings_were_found = 1;
    if flag_be_verbose
        fprintf(1,'   North bounds incorrect. Updating bounding box on north edge.\n');
    end
    ODRStruct_fixed.OpenDRIVE.header.Attributes.north = num2str(north);
end
if flag_be_verbose
    fprintf(1,'   Bounding box check complete.\n');
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
