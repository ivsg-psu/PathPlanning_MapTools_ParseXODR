function fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,varargin)
%% fcn_ParseXODR_plotXODRinENU
% plots a realistic road environment defined in an XODR file
%
% FORMAT:
%
%       fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,(flag_plot_road_geometry),(fig_num))
%
% INPUTS:
%
%      ODRStruct: a standard structure produced by the XODR XML file when
%      read into MATLAB structure format.
%
%      minPlotGap: minimum spacing of the points defining the road geometries
%
%      (OPTIONAL INPUTS)
% 
%      flag_plot_road_geometry: flag to either shut off road geometry
%      plotting ( = 0, default), or to show road geometry centerline (= 1)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
%
% OUTPUTS:
%
%      (none)     
%
% DEPENDENCIES:
%
%       NA
%
% EXAMPLES:
%      
% See the script: script_test_fcn_ParseXODR_plotXODRinENU
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

        % % Check the projection_vector input to be length greater than or equal to 1
        % fcn_DebugTools_checkInputsToFunctions(...
        %     input_vectors, '2or3column_of_numbers');

    end
end


% Does user want to specify the flag_plot_road_geometry? 
flag_plot_road_geometry = 0;
if (3 <=nargin)
    temp = varargin{1};
    if ~isempty(temp)
        flag_plot_road_geometry = temp;
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

if isempty(fig_num)
    temp = figure;
    fig_num = temp.Number;
    flag_do_plots = 1;
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

% Find how many roads are in the XODR structure
Nroads = length(ODRStruct.OpenDRIVE.road);


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

    hold on
    grid on
    axis equal
    xlabel('East (m)')
    ylabel('North (m)')


    % Iterate through each of the roads in the XODR file and obtain all of
    % the geometry for plotting. Once acquired, plot a dark gray patch for
    % the road extents.
    for roadIndex = 1:Nroads
        % Grab a current road object to make it simpler to address it
        currentRoad = ODRStruct.OpenDRIVE.road{roadIndex};

        % First, extract the lane geometry in order to determine the extents of
        % the road
        [stationPoints,tLeft,tCenter,tRight] = fcn_ParseXODR_extractLaneGeometry(currentRoad,minPlotGap);

        % First, find the extents of the road as the maximum t-coordinate on the
        % left side of the road and the minimum t-coordinate on the right side of
        % the road, then add just a tiny bit of
        if isempty(tLeft)
            leftExtents = tCenter;
        else
            leftExtents = max(tLeft,[],2,'omitnan');
        end
        if isempty(tRight)
            rightExtents = tCenter;
        else
            rightExtents = min(tRight,[],2,'omitnan');
        end

        % Determine the (E,N) coordinates associated with each of the road
        % extents
        [E_LeftExtents,N_LeftExtents] = fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,leftExtents);
        [E_RightExtents,N_RightExtents] = fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,rightExtents);

        % Plot a dark gray patch to represent the road surface
        patch([E_LeftExtents; flipud(E_RightExtents)],...
            [N_LeftExtents; flipud(N_RightExtents)],[0.2 0.2 0.2],'edgecolor',[0.2 0.2 0.2]);
    end

    % Iterate through each of the roads in the XODR file again and obtain
    % all of the geometry for plotting the lane markers. Iterating through
    % all of the roads in different loops is a bit inefficient, but saves
    % on memory usage and the need to build a large data structure.
    for roadIndex = 1:Nroads
        % Grab a current road object to make it simpler to address it
        currentRoad = ODRStruct.OpenDRIVE.road{roadIndex};

        % First, extract the lane geometry in order to determine the extents of
        % the road
        [stationPoints,tLeft,tCenter,tRight] = fcn_ParseXODR_extractLaneGeometry(currentRoad,minPlotGap);

        if 1==flag_plot_road_geometry
            % Plot the geometry reference line by taking all the station points
            % and forcing the transverse points to be zero
            [E_GeometryRef,N_GeometryRef] = fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,0*stationPoints);
            plot(E_GeometryRef,N_GeometryRef,'-','linewidth',3,'color',[0 1 0]);
        end

        % Now, plot the center lane as a double-yellow line, by offsetting the
        % center lane by 10 cm each direction from the center lane definition
        [E_CenterLaneL,N_CenterLaneL] = fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,tCenter+0.1);
        [E_CenterLaneR,N_CenterLaneR] = fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,tCenter-0.1);
        plot(E_CenterLaneL,N_CenterLaneL,'-','linewidth',3,'color',[0.8 0.6 0.1])
        plot(E_CenterLaneR,N_CenterLaneR,'-','linewidth',3,'color',[0.8 0.6 0.1])

        % Finally, determine the outer lines of the driving lanes, assuming that
        % the outside lanes are the shoulder
        if ~isempty(tLeft)
            [~,inds] = sort(tLeft,2,'descend','MissingPlacement','last');
            for laneIdx = 2:size(tLeft,2)
                for i = 1:length(stationPoints)
                    tLeftDrivingBoundary(i,1) = tLeft(i,[inds(i,laneIdx)]); %#ok<AGROW>
                end
                [eLeftLane,nLeftLane] = ...
                    fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,tLeftDrivingBoundary);
                if laneIdx == 2
                    plot(eLeftLane,nLeftLane,'-','linewidth',3,'color','white');
                else
                    plot(eLeftLane,nLeftLane,'--','linewidth',3,'color','white');
                end
            end
        end

        % Right side
        if ~isempty(tRight)
            [~,inds] = sort(tRight,2,'ascend','MissingPlacement','last');
            for laneIdx = 2:size(tRight,2)
                for i = 1:length(stationPoints)
                    tRightDrivingBoundary(i,1) = tRight(i,[inds(i,laneIdx)]); %#ok<AGROW>
                end
                [eRightLane,nRightLane] = ...
                    fcn_RoadSeg_findXYfromSTandODRRoad(currentRoad,stationPoints,tRightDrivingBoundary);
                if laneIdx == 2
                    plot(eRightLane,nRightLane,'-','linewidth',3,'color','white');
                else
                    plot(eRightLane,nRightLane,'--','linewidth',3,'color','white');
                end
            end
        end
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

