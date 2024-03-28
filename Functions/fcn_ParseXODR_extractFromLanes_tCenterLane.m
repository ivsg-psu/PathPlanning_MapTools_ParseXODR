function transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, varargin)
%% fcn_ParseXODR_extractFromLanes_tCenterLane
% Given a lanes structure, extracts the transverse "t" coordinate offsets
% of the centerline relative to the road reference line.
%
% FORMAT:
%
%       transverseCenterOffsets = fcn_ParseXODR_extractFromLanes_tCenterLane(lanesStructure, roadEndStation, stationPoints, (fig_num))
%
% INPUTS:
%
%      lanesStructure: the lanes subfield for an XODRRoad
%
%      roadEndStation: the station coordinate that ends the road
%      containining this lanes structure
%
%      stationPoints: the station locations where the transverse center
%      offsets should be calculated [N x 1] vector.
%
% (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%       transverseCenterOffsets: a [N x 2] vector where N is the number of
%       laneOffset segments in the lanes, each row is ordered in the sequence
%       of segment 1, segment 2, etc, and each row corresponds to
%       [laneSectionStart laneSectionEnd] for that laneOffset segment
%
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_extractFromLanes_tCenterLane
%       for a full test suite.
%
% This function was by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2024_03_24 - S. Brennan
% -- original write of function


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
        narginchk(3,4);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end


% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
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

% Determine whether there are any lane offsets in the
% current lanes
if isfield(lanesStructure,'laneOffset')
    laneOffsetStructure = lanesStructure.laneOffset;
    
    % Get the lane offset stations
    laneOffsetStations = fcn_ParseXODR_extractFromLanes_LaneOffsetStations(lanesStructure, roadEndStation, -1);

    % Preallocate a t-coordinate vector for the center lane. This will be
    % zero when the center lane is not offset, but offsets may shift it.
    % All other lane positions are referenced to this position.
    transverseCenterOffsets = zeros(length(stationPoints(:,1)),1);

    % Determine the number of offset descriptors in the road
    Noffsets = length(laneOffsetStations(:,1));
    % Iterate through all of the offset descriptors
    for laneOffsetIdx = 1:Noffsets
        % Determine the start and end points of the offset
        offsetStart = laneOffsetStations(laneOffsetIdx,1);
        offsetEnd = laneOffsetStations(laneOffsetIdx,2);

        % Determine which of the indices in the s-direction are affected by
        % this offset descriptor
        affectedIdxs = find(stationPoints >= offsetStart & stationPoints <= offsetEnd);

        % Grab the properties of the offset
        a = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.a);
        b = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.b);
        c = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.c);
        d = str2double(laneOffsetStructure{laneOffsetIdx}.Attributes.d);

        % Now calculate the t coordinate of the center line at each of the
        % affected points
        ds = stationPoints(affectedIdxs)-offsetStart;
        transverseCenterOffsets(affectedIdxs) = a + b*ds + c*ds.^2 + d*ds.^3;

        if flag_do_debug
            fprintf(1,'Offset center lane from stations %d to %d\n',offsetStart,offsetEnd);
        end
    end

else
    transverseCenterOffsets = 0*stationPoints;
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

    % Grab colors to use
    try
        color_ordering = orderedcolors('gem12');
    catch
        color_ordering = colororder;
    end
    N_colors = length(color_ordering(:,1)); %#ok<NASGU>


    title('St coordinate view');
    xlabel('S coordinate [m]')
    ylabel('t coordinate [m]')

    % Plot the centerline
    hC = plot(stationPoints,transverseCenterOffsets,'k--','linewidth',1.5);
    plotHandles = hC;
    plotLabels = {'Center Lane'};

    % Plot the left side
    % [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tLeft, 1, plotHandles, plotLabels);

    % Plot the right side
    % [plotHandles, plotLabels] = fcn_INTERNAL_plotLaneSidesSt(stationPoints, tRight, -1, plotHandles, plotLabels);

    legend(plotHandles,plotLabels)

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

