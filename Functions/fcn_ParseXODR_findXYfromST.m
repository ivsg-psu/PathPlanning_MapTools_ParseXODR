function [x,y,h] = fcn_ParseXODR_findXYfromST(geomType,initial_values,St_coordinates,varargin)
%% fcn_ParseXODR_findXYfromST
% Script to determine the X,Y and heading coordinates along a segment of a
% road defined in the XODR standard. Unlike the arc and spiral specific
% functions in this library, this function accommodates t coordinate inputs
% to calculate coordinates for points where the locations are offset from
% the path center line
%
% FORMAT:
%
%       [x,y,h] = fcn_ParseXODR_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,varargin)
%
% INPUTS:
%
%       geomtype: a string containing 'line', 'arc', or 'spiral' to denote
%         the type of path and therefore the appropriate computation
%
%       initial_values: a (5x1) or (1x5) vector containing the following,
%       in order:
%
%          x0: a scalar parameter denoting the x-coordinate of the path at
%            the s = 0 point
%          y0: a scalar parameter denoting the y-coordinate of the path at
%            the s = 0 point
%          h0: a scalar parameter denoting the heading of the path at the
%            s = 0 point
%          s0: a scalar parameter denoting the start point of the path in s
%            coordinates
%          l0: a scalar parameter denoting the maximum extent of the path, in
%            station coordinates, relative to s = 0
%
%      St_coordinates: a (Nx2) vector containing the following columns: 
%
%       s: a vector of station coordinates along the path at which to
%         compute the x,y coordinates. s is NOT assumed to start at zero.
%       t: a vector of station coordinates perpendicular to the path at
%         which to compute the x,y coordinates.
%
%       (VARIABLE INPUTS):
%       K0: a scalar parameter denoting the curvature of the arc or the
%         curvature at the start of a spiral
%       KF: a scalar parameter denoting the curvature of the arc or the
%         curvature at the end of a spiral
%
% OUTPUTS:
%
%       x: a vector of x-coordinates corresponding to points along the
%         path at each of the s-coordinates
%       y: a vector of y-coordinates corresponding to points along the
%         path at each of the s-coordinates
%       h: a vector of headings corresponding to points along the
%         path at each of the s-coordinates
%
% DEPENDENCIES:
%
%      fcn_RoadSeg_findXYfromXODRSpiral
%      fcn_RoadSeg_findXYfromXODRArc
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_findXYfromST.m for
%       a full test suite.
%
% This function was originally written by C. Beal as the function:
% fcn_RoadSeg_findXYfromST. It is maintained by S. Brennan
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_03_20 - C. Beal
% -- wrote the code
% 2024_03_19 - S. Brennan
% -- renamed to fcn_ParseXODR_findXYfromST
% -- grouped inputs and outputs for clarity
% -- functionalized the final transverse calculation across methods

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
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
        switch geomType
            case 'line'
                if flag_check_inputs && nargin > 8
                    warning('Ignoring extra arguments for line geometry')
                end
            case 'arc'
                if nargin < 9
                    error('Not enough input arguments to define arc geometry')
                elseif nargin > 9
                    warning('Ignoring extra arguments for arc geometry')
                end
                % Extract the curvature of the arc
                K0 = varargin{1};
            case 'spiral'
                if nargin < 10
                    error('Not enough input arguments to define spiral geometry')
                elseif nargin > 10
                    warning('Ignoring extra arguments for spiral geometry')
                end
                % Extract the initial and final curvatures for the spiral
                K0 = varargin{1};
                KF = varargin{2};
        end
    end
end

% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (3<= nargin)
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

% Grab the initial values
%       x0: a scalar parameter denoting the x-coordinate of the path at
%         the s = 0 point
x0 = initial_values(1);

%       y0: a scalar parameter denoting the y-coordinate of the path at
%         the s = 0 point
y0 = initial_values(2);

%       h0: a scalar parameter denoting the heading of the path at the
%         s = 0 point
h0 = initial_values(3);

%       s0: a scalar parameter denoting the start point of the path in s
%         coordinates
s0 = initial_values(4);

%       l0: a scalar parameter denoting the maximum extent of the path, in
%         station coordinates, relative to s = 0
l0 = initial_values(5);

% Grab the St coordinates
s = St_coordinates(:,1);
t = St_coordinates(:,2);

switch geomType
    case 'line'
        % See for example: https://github.com/pageldev/libOpenDRIVE/blob/master/src/Geometries/Line.cpp

        % Add together the contribution to the x position of the initial x,y
        % coordinate, the travel down the road line, and the offset from the
        % centerline of the line (defined as the heading + pi/2) given the s,t
        % coordinate system
        x = x0 + (s(:)-s0).*cos(h0);
        y = y0 + (s(:)-s0).*sin(h0);

        % The heading stays the same along all points of a line segment, so
        % return a vector of the same size as x and y, populated with h0
        h = h0*ones(length(s),1);

        % Offset the x and y coordinates by the projection along t (which is
        % aligned at the heading plus pi/2)
        x = x + t(:).*cos(h+pi/2);
        y = y + t(:).*sin(h+pi/2);


    case 'arc'
        % Find the points along the path assuming t = 0
        [x,y] = fcn_RoadSeg_findXYfromXODRArc(s(:)-s0,h0,x0,y0,K0);

        % Compute the heading at the specified points
        h = K0*(s(:) - s0) + h0;

        % Offset the x and y coordinates by the projection along t (which is
        % aligned at the heading plus pi/2)
        x = x + t(:).*cos(h+pi/2);
        y = y + t(:).*sin(h+pi/2);
        

    case 'spiral'
        % Find the point along the path with t = 0
        [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s(:)-s0,l0,h0,x0,y0,K0,KF);

        % Compute the heading at the specified points
        h = (KF-K0)/l0*(s(:)-s0).^2/2 + K0*(s(:)-s0) + h0;

        % Offset the x and y coordinates by the projection along t (which is
        % aligned at the heading plus pi/2)
        x = x + t(:).*cos(h+pi/2);
        y = y + t(:).*sin(h+pi/2);
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

