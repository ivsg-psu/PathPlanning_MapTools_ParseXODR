function [roads, new_traversal] = fcn_ParseXODR_fillPlanView(roads, roadCenterLine, interval)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_fillPlanView
% Populates the plan view section of an OpenDRIVE road structure.
%
% FORMAT:
%
%       fcn_ParseXODR_fillPlanView(roads, roadCenterLine, interval)
%
% INPUTS:
%
%      roads: Structure representing the roads in the OpenDRIVE format
%
%      roadCenterLine: Coordinates of the road's centerline
%
%      interval: Interval distance for sampling along the road
%
% OUTPUTS:
%
%      roads: Updated roads structure with plan view information
%
%      new_traversal: Resampled traversal structure based on the interval
%
% DEPENDENCIES:
%
%      NA
%
% EXAMPLES:
%
%      see script_ParseXODR_createScenario1_5.m for a comprehensive test
%      suite.
%
% This function was written by Wushuang Bai and S. Brennan
% Questions or comments? sbrennan@psu.edu
%
% Revision history:
% 2023_11_10  - W. Bai
% -- Added initial code structure
% 2023_11_20 - W. Bai
% -- Enhanced with additional comments
% 2024_03_06 - S. Brennan
% -- fixed debug mode
% -- fixed horrid variable naming

flag_do_debug = 1; % Flag to show function info in UI
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end

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
    if nargin ~= 3
        error('Incorrect number of input arguments')
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  __  __       _
% |  \/  |     (_)
% | \  / | __ _ _ _ __
% | |\/| |/ _` | | '_ \
% | |  | | (_| | | | | |
% |_|  |_|\__,_|_|_| |_|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Convert road centerline to traversal structure
input_traversal = fcn_Path_convertPathToTraversalStructure(roadCenterLine);
new_stations    = (0:interval:input_traversal.Station(end))';
new_traversal   = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);
new_traversal.segmentLength = diff(new_traversal.Station);

% Write the new traversal data into the OpenDRIVE structure
for ith_laneSegment = 1:length(new_traversal.segmentLength)
    roads.OpenDRIVE.road{1}.planView.geometry{ith_laneSegment}.Attributes.hdg = num2str(real(new_traversal.Yaw(ith_laneSegment)));
    roads.OpenDRIVE.road{1}.planView.geometry{ith_laneSegment}.Attributes.length = num2str(new_traversal.segmentLength(ith_laneSegment));
    roads.OpenDRIVE.road{1}.planView.geometry{ith_laneSegment}.Attributes.s = num2str(new_traversal.Station(ith_laneSegment));
    roads.OpenDRIVE.road{1}.planView.geometry{ith_laneSegment}.Attributes.x = num2str(new_traversal.X(ith_laneSegment));
    roads.OpenDRIVE.road{1}.planView.geometry{ith_laneSegment}.Attributes.y = num2str(new_traversal.Y(ith_laneSegment));
    roads.OpenDRIVE.road{1}.planView.geometry{ith_laneSegment}.line = struct;
end

% Update the total length of the road
roads.OpenDRIVE.road{1}.Attributes.length = new_traversal.Station(end);

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
    % temp_h = figure(fig_num);
    % flag_rescale_axis = 0;
    % if isempty(get(temp_h,'Children'))
    %     flag_rescale_axis = 1;
    % end        



    % % Plot the input segments in top
    % subplot(2,1,1);
    % hold on;
    % grid on;
    % xlabel('Station [m]')
    % ylabel('Line #')
    %
    % for ith_segment = 1:N_segments
    %     % Get current color
    %     current_color = color_ordering(mod(ith_segment,N_colors)+1,:);
    %
    %     plot([lane_centerlines_start(ith_segment,1) lane_centerlines_end(ith_segment,1)],[ith_segment ith_segment],'-','LineWidth',3, 'Color', current_color);
    % end
    %
    % % Plot the counts on bottom
    % subplot(2,1,2);
    % hold on;
    % grid on;
    % xlabel('Station [m]')
    %
    %
    % % Plot the results
    % nudge_amount = 0.1;
    % for ith_result = 1:length(per_segment_count)
    %     num_nudges = sum(in_segment_membership(ith_result,:));
    %     if 0==num_nudges
    %         plot([station_segments(ith_result,1) station_segments(ith_result,2)], [0 0] ,'-','LineWidth',3, 'Color', [0 0 0]);
    %     else
    %         y_val = per_segment_count(ith_result,1) - (num_nudges-1)/2*nudge_amount;
    %         for jth_segment = 1:N_segments
    %             % Get current color
    %             current_color = color_ordering(mod(jth_segment,N_colors)+1,:);
    %             current_nudge = sum(in_segment_membership(ith_result, 1:jth_segment))-1;
    %             y_plot = y_val + current_nudge*nudge_amount;
    %             if 1==in_segment_membership(ith_result,jth_segment)
    %                 plot([station_segments(ith_result,1) station_segments(ith_result,2)], [y_plot y_plot] ,'-','LineWidth',3, 'Color', current_color);
    %             end
    %         end
    %     end
    % end
    %
    % % Make axis slightly larger?
    % if flag_rescale_axis
    %     subplot(2,1,1);
    %     temp = axis;
    %     %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
    %     axis_range_x = temp(2)-temp(1);
    %     axis_range_y = temp(4)-temp(3);
    %     percent_larger = 0.3;
    %     axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    %     xrange = xlim;
    %
    %     subplot(2,1,2);
    %     temp = axis;
    %     %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
    %     axis_range_y = temp(4)-temp(3);
    %     percent_larger = 0.3;
    %     xlim(xrange);
    %     ylim([temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    % else
    %     subplot(2,1,1);
    %     temp = axis;
    %     subplot(2,1,2);
    %     xlim([temp(1) temp(2)]);
    % end
    %
    %
    % % Plot the station breaks
    % subplot(2,1,1);
    % temp = axis;
    % for ith_break = 1:length(station_segments(:,1))
    %     plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
    %     plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
    % end
    %
    % subplot(2,1,2);
    % temp = axis;
    % for ith_break = 1:length(station_segments(:,1))
    %     plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
    %     plot([station_segments(ith_break,1) station_segments(ith_break,1)], [temp(3) temp(4)] ,'--','LineWidth',1, 'Color', [1 0 0]);
    % end
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
