function [planView, totalStationLength] = fcn_ParseXODR_fillPlanViewViaLineSegments(roadCenterLine, interval, varargin)
%% fcn_ParseXODR_fillPlanView
% Populates the plan view section of an OpenDRIVE road structure given a
% roadCenterline input and sampling interval. The roadCenterline is broken
% into line segments that each define a short region of geometry, with the
% region length given by the interval input value.
%
% FORMAT:
%
%       [planView, totalStationLength] = fcn_ParseXODR_fillPlanViewViaLineSegments(roadCenterLine, interval, (fig_num))
%
% INPUTS:
%
%      roadCenterLine: the centerline coordinates defined as a sequence of
%      points in Nx2 format containing [x y] values for each row
%
%      interval: Interval distance for sampling along the road
%
%      (OPTIONAL INPUTS)
% 
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      planView: Updated roads structure with plan view information
%
%      totalStationLength: the total path length of the roadCenterLine
%
% DEPENDENCIES:
%
%      fcn_ParseXODR_fillDefaultRoadPlanView
%
% EXAMPLES:
%
%      see script_ParseXODR_createScenario1_5.m for a comprehensive test
%      suite.
%
% This function was written by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2024_03_06 - S. Brennan
% -- Added initial code structure

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
        % Are there the right number of inputs?
        narginchk(2,3);
        
        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

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

% Convert road centerline to traversal structure
input_traversal = fcn_Path_convertPathToTraversalStructure(roadCenterLine);
new_stations    = (0:interval:input_traversal.Station(end))';
new_traversal   = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);
new_traversal.segmentLength = diff(new_traversal.Station);

% Initialize the planView
planView = fcn_ParseXODR_fillDefaultRoadPlanView(-1);

% Write the new traversal data into the OpenDRIVE structure
for ith_laneSegment = 1:length(new_traversal.segmentLength)
    planView.geometry{ith_laneSegment}.Attributes.hdg = num2str(real(new_traversal.Yaw(ith_laneSegment)));
    planView.geometry{ith_laneSegment}.Attributes.length = num2str(new_traversal.segmentLength(ith_laneSegment));
    planView.geometry{ith_laneSegment}.Attributes.s = num2str(new_traversal.Station(ith_laneSegment));
    planView.geometry{ith_laneSegment}.Attributes.x = num2str(new_traversal.X(ith_laneSegment));
    planView.geometry{ith_laneSegment}.Attributes.y = num2str(new_traversal.Y(ith_laneSegment));
    planView.geometry{ith_laneSegment}.line = struct;
end

% Update the total length of the road
totalStationLength = new_traversal.Station(end);



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

