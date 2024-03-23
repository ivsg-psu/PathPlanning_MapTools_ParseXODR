function [x_arc,y_arc] = fcn_ParseXODR_extractXYfromSTArc(s,h0,x0,y0,K0,varargin)
%% fcn_ParseXODR_extractXYfromSTArc
% Script to determine the X,Y coordinates along a segment of a road defined
% as an "arc" segment in the XODR standard. The arc is plotted if a figure
% handle is provided

% The path can be expressed in parametric integral form:
% x = int_0^s cos(K0*s + h0) ds + x0
% y = int_0^s sin(K0*s + h0) ds + y0
% where K0*s is the included angle of the arc length s, h0 is the initial
% angle. These integral expressions can be solved explicitly and a
% vectorized implementation of the calculations is easily formed.
%
% FORMAT: 
%
%       [x_arc,y_arc] = fcn_ParseXODR_extractXYfromSTArc(s,h0,x0,y0,K0,{fig_num})
%
% INPUTS:
%
%       s: a vector of station coordinates along the arc path at which to
%         compute the x,y coordinates. s is assumed to start at zero.
%
%       h0: a scalar parameter denoting the heading of the arc at the
%         s = 0 point
%
%       x0: a scalar parameter denoting the x-coordinate of the arc at
%         the s = 0 point
%
%       y0: a scalar parameter denoting the y-coordinate of the arc at
%         the s = 0 point
%
%       K0: a scalar parameter denoting the curvature of the arc
%
%      (OPTIONAL INPUTS): 
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%       x_arc: a vector of x-coordinates corresponding to points along the
%         arc at each of the s-coordinates
%
%       y_arc: a vector of y-coordinates corresponding to points along the
%         arc at each of the s-coordinates
%
% DEPENDENCIES:
%
%      None
%
% EXAMPLES:
%      
%       See the script: script_test_fcn_ParseXODR_extractXYfromSTArc.m for
%       a full test suite.
%
% This function was originally written by C. Beal (cbeal@bucknell.edu) as
% fcn_RoadSeg_findXYfromXODRArc, renamed by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2022_03_20 - C. Beal
% -- wrote the code
% 2022_03_22 - S. Brennan
% -- wrote the code

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==6 && isequal(varargin{end},-1))
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
        narginchk(5,6);
    end
end

% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (6<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
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

% Compute the x and y coordinates from the provided vector of s coordinates
x_arc = ( sin(K0*s(:) + h0) - sin(h0))/K0 + x0;
y_arc = (-cos(K0*s(:) + h0) + cos(h0))/K0 + y0;

% const double angle_at_s = (s - s0) * curvature - M_PI / 2;
% const double r = 1 / curvature;
% const double xs = r * (std::cos(hdg0 + angle_at_s) - std::sin(hdg0)) + x0;
% const double ys = r * (std::sin(hdg0 + angle_at_s) + std::cos(hdg0)) + y0;

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

    % Determine the hold state of the figure
    holdState = ishold;
    % Turn on hold for the purposes of adding the clothoid segment
    hold on

    grid on;
    axis equal


    % Grab colors to use
    try
        color_ordering = orderedcolors('gem12');
    catch
        color_ordering = colororder;
    end
    N_colors = length(color_ordering(:,1)); 

    % Set up labels and title
    xlabel('X (m)')
    ylabel('Y (m)')

    % Plot the results as dots
    for ith_column = 1:length(x_arc(1,:))
        % Get current color
        current_color = color_ordering(mod(ith_column,N_colors)+1,:); %#ok<NASGU>

        % Plot results as dots
        plot(x_arc(:,ith_column),y_arc(:,ith_column),'.-.','MarkerSize',30); % ,'Color',current_color);
    end
 

    % Restore the original hold state of the plot as necessary
    if 0 == holdState
        hold off
    end

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

