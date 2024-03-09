function [station_segments, per_segment_count, in_segment_membership] = ...
    fcn_ParseXODR_countLanes(...
    lane_centerlines_start, ...
    lane_centerlines_end, ...
    varargin)
%% fcn_ParseXODR_countLanes
% Counts the number of lanes that are overlapping, returning the counts,
% the stations of each segment, and the membership within each segment.
%
% FORMAT:
%
% [station_segments, per_segment_count, in_segment_membership] = ...
%     laneCountfcn_ParseXODR_countLanes(...
%     lane_centerlines_start, ...
%     lane_centerlines_end, ...
%     station_tolerance, ...
%     (fig_num));
%
% INPUTS:
%
%       lane_centerlines_start: an Nx1 matrix of the station coordinates of
%       the starting point of each lane center.
% 
%       lane_centerlines_end: an Nx1 matrix of the station coordinates of
%       the ending point of each lane center.
%
%      (OPTIONAL INPUTS)
% 
%      tolerance: the amount of overlap or lack of overlap to ignore, if
%      the overlap is not perfect.
%
%      fig_num: a figure number to plot the results.
%
% OUTPUTS:
%
%      station_segments: an [Mx2 matrix denoting the station coordinates of each segment, in format [s_start s_end]
% 
%      per_segment_count: an Mx1 matrix with the total count of lanes in each segment
% 
%      in_segment_membership: which indicies belong to each segment,
%      indexing into the lane_centerlines_start
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%      
% See the script: script_test_fcn_ParseXODR_countLanes
% for a full test suite.
%
% This function was written on 2024_02_01 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2024_02_01 - S. Brennan
% -- wrote the code

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==4 && isequal(varargin{end},-1))
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
        narginchk(2,4);

        % Check the lane_centerlines_start input to have 1 column
        fcn_DebugTools_checkInputsToFunctions(...
            lane_centerlines_start, '1column_of_numbers');

        % Check the lane_centerlines_end input to have 1 column and same
        % number of rows as the start values
        fcn_DebugTools_checkInputsToFunctions(...
            lane_centerlines_end, '1column_of_numbers',length(lane_centerlines_start(:,1)));
        

    end
end

% Does user want to specify station_tolerance?
station_tolerance = 9; % Default is to have no station_tolerance
if (3<= nargin) 
    temp = varargin{1};
    if ~isempty(temp)
        station_tolerance = temp;
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) && (4<= nargin) 
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

% Get the color ordering?
try
    color_ordering = orderedcolors('gem12');
catch
    color_ordering = colororder;
end

N_colors = length(color_ordering(:,1));


N_segments = length(lane_centerlines_start(:,1));
if length(lane_centerlines_end(:,1))~=N_segments
    error('lane_centerlines_start must have the same length as lane_centerlines_end. Quitting.');
end

% Sort all the stations
unsorted_stations = [lane_centerlines_start; lane_centerlines_end];
[sorted_stations, sort_indicies] = sort(unsorted_stations);

% Remove stations that are too close to each other
common_boundary_sorted_stations = sorted_stations;
corrected_unsorted_stations = unsorted_stations;

% Are any stations too close to each other?
if any(diff(sorted_stations)<station_tolerance)
    % Yes, some are too close
    for ith_station = 1:length(common_boundary_sorted_stations)
        % Get current station
        current_station = common_boundary_sorted_stations(ith_station,1);

        % Which indicies are close to current station?
        indicies_near_same_station = intersect(...
            find(common_boundary_sorted_stations>=current_station),...
            find(common_boundary_sorted_stations<=current_station+station_tolerance));

        % Use the first station as the shared station
        shared_station = current_station;

        % Force the remaining stations to be the same as the shared station
        common_boundary_sorted_stations(indicies_near_same_station,1) = shared_station;

        % Fix the unsorted start and end stations to this one
        indicies_unsorted_to_correct = sort_indicies(indicies_near_same_station);
        corrected_unsorted_stations(indicies_unsorted_to_correct) = shared_station;
    end
end

% At this point, all the start/end locations are now forced to be within
% the same station point. 
corrected_lane_centerlines_start = corrected_unsorted_stations(1:N_segments);
corrected_lane_centerlines_end   = corrected_unsorted_stations(N_segments+1:end);

% % For debugging
% disp([unsorted_stations corrected_unsorted_stations])
% disp([corrected_lane_centerlines_start corrected_lane_centerlines_end])
% figure(38383); clf; hold on;
% 
% for ith_segment = 1:N_segments
%     % Get current color
%     current_color = color_ordering(mod(ith_segment,N_colors)+1,:);
% 
%     plot([corrected_lane_centerlines_start(ith_segment,1) corrected_lane_centerlines_end(ith_segment,1)],[ith_segment ith_segment],'-','LineWidth',3, 'Color', current_color);
% end

% So we now calculate memberships

% Sort all the stations
unsorted_corrected_stations = [corrected_lane_centerlines_start; corrected_lane_centerlines_end];

% Keep only the unique ones
% [sorted_corrected_stations, ~] = sort(unsorted_corrected_stations);
[unique_stations, ~, in_unique] = unique(unsorted_corrected_stations);
N_unique_stations = length(unique_stations(:,1));


% Associate all the start and end/points with one specific unique station
start_indicies_of_unique_stations = in_unique(1:N_segments);
end_indicies_of_unique_stations   = in_unique(N_segments+1:end);

% Add up all the contributions of starts and ends
counts_to_add = zeros(N_unique_stations,1);
for ith_segment = 1:N_segments
    start_index = start_indicies_of_unique_stations(ith_segment,1);
    end_index = end_indicies_of_unique_stations(ith_segment,1);
    counts_to_add(start_index,1) = counts_to_add(start_index,1) + 1;
    counts_to_add(end_index,1)   = counts_to_add(end_index,1) - 1;
end

totals_in_each_segment = [cumsum(counts_to_add)];

if totals_in_each_segment(end)~=0
    error('Total start locations do not add up to total end locations. An error must have occurred!');
end

% Generate the membership matrix
% create this by tagging the start and end indicies. For the end index,
% subtract 1 so that the end is not counted as "full". Otherwise, segments
% with zero membership will show up as having entries because a segment
% will be showing membership both after it adds a member and after it
% removes a member
membership_matrix = zeros(N_unique_stations,N_segments);
for ith_segment = 1:N_segments
    start_index = start_indicies_of_unique_stations(ith_segment,1);
    end_index = end_indicies_of_unique_stations(ith_segment,1)-1;
    membership_matrix(start_index:end_index,ith_segment) = 1;
end


% For debugging
% disp([unique_stations membership_matrix]);

final_station_membership_matrix = membership_matrix; 

station_segments = [unique_stations(1:end-1,1), unique_stations(2:end,1)];
per_segment_count = totals_in_each_segment(1:end-1,1);
in_segment_membership = final_station_membership_matrix(1:end-1,:);

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



    % Plot the input segments in top 
    subplot(2,1,1);
    hold on;
    grid on;
    xlabel('Station [m]')
    ylabel('Line #')

    for ith_segment = 1:N_segments
        % Get current color
        current_color = color_ordering(mod(ith_segment,N_colors)+1,:);

        plot([lane_centerlines_start(ith_segment,1) lane_centerlines_end(ith_segment,1)],[ith_segment ith_segment],'-','LineWidth',3, 'Color', current_color);
    end

    % Plot the counts on bottom 
    subplot(2,1,2);
    hold on;
    grid on;
    xlabel('Station [m]')

    
    % Plot the results    
    nudge_amount = 0.1;
    for ith_result = 1:length(per_segment_count)
        num_nudges = sum(in_segment_membership(ith_result,:));
        if 0==num_nudges
            plot([station_segments(ith_result,1) station_segments(ith_result,2)], [0 0] ,'-','LineWidth',3, 'Color', [0 0 0]);
        else
            y_val = per_segment_count(ith_result,1) - (num_nudges-1)/2*nudge_amount;
            for jth_segment = 1:N_segments
                % Get current color
                current_color = color_ordering(mod(jth_segment,N_colors)+1,:);
                current_nudge = sum(in_segment_membership(ith_result, 1:jth_segment))-1;
                y_plot = y_val + current_nudge*nudge_amount;
                if 1==in_segment_membership(ith_result,jth_segment)
                    plot([station_segments(ith_result,1) station_segments(ith_result,2)], [y_plot y_plot] ,'-','LineWidth',3, 'Color', current_color);
                end
            end
        end
    end

    % Make axis slightly larger?
    if flag_rescale_axis
        subplot(2,1,1);
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_x = temp(2)-temp(1);
        axis_range_y = temp(4)-temp(3);
        percent_larger = 0.3;
        axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
        xrange = xlim;

        subplot(2,1,2);
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_y = temp(4)-temp(3);
        percent_larger = 0.3;
        xlim(xrange);
        ylim([temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    else
        subplot(2,1,1);
        temp = axis;
        subplot(2,1,2);
        xlim([temp(1) temp(2)]);
    end


    % Plot the station breaks
    subplot(2,1,1);
    temp = axis;
    for ith_break = 1:length(station_segments(:,1))
        plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
        plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
    end

    subplot(2,1,2);
    temp = axis;
    for ith_break = 1:length(station_segments(:,1))
        plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
        plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
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

