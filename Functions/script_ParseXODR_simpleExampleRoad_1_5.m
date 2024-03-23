% script_LoadWZ_createScenario1_5_XODR
% This script creates xodr file for ADS scenario 1.5.
% It sets up road and lane structures, adds objects and signals,
% and finally generates an XODR file based on these configurations.
%
% Author: Wushuang Bai, wxb41@psu.edu
%
% Revision history:
% 2023_11_10 by Wushuang Bai
% -- Initial script setup
% 2023_11_20 by Wushuang Bai
% -- Added comments and enhanced documentation
% 2024_01_29, by V. Wagh
% -- added code to save xodr file to Data folder
% 2024_01_31, by S. Brennan
% -- scripted procedure

clear;
close all; 

%%
%   _____                           _      __   _____
%  / ____|                         (_)    /_ | | ____|
% | (___   ___ ___ _ __   __ _ _ __ _  ___ | | | |__
%  \___ \ / __/ _ \ '_ \ / _` | '__| |/ _ \| | |___ \
%  ____) | (_|  __/ | | | (_| | |  | | (_) | |_ ___) |
% |_____/ \___\___|_| |_|\__,_|_|  |_|\___/|_(_)____/

%% Load the Scenario 1_5 data
% See script_test_fcn_LoadWZ_loadLane.m

% Initialize flags for adding signals and objects
flag_addSignals = 1;
flag_gridObjects = 1;
gridText = [];

mat_filename = fullfile(cd,'Data','Scenario_1_5_lanes.mat');

% Does the mat file exist?
% if 1==0 %exist(mat_filename,'file')
if exist(mat_filename,'file')
    load(mat_filename,'LanesToMap','objectsENU','signalsENU','signalsName','roadCenterENU');
else
    error('unable to find data file to load. Need to regenerate or copy it from LoadWZ.');
    %
    % % Define figure number for plotting
    % fig_num = 15000;
    % figure(fig_num);
    % clf;
    %
    % % Load various lane data for the scenario
    % % Lane 1: Outer loop road main lane entry
    % LaneName = 'Scenario_1_5_OuterLoopRoad_m1_MainLoopOuterLaneEntry';
    % LanesToMap{1} = fcn_LoadWZ_loadLane(LaneName, 'AlignedDesign', 1, fig_num);
    %
    % % Lane 2: Entry transition road
    % LaneName = 'Scenario_1_5_EntryTransitionRoad_m2_NewLane1_DoubleYellowLeft';
    % LanesToMap{2} = fcn_LoadWZ_loadLane(LaneName, 'AlignedDesign', 1, fig_num);
    %
    % % Lane 3: Entry multi-lane highway
    % LaneName = 'Scenario_1_5_EntryMultiLaneHighway_m1_NewLane1_DoubleDashedYellowLeft';
    % LanesToMap{3} = fcn_LoadWZ_loadLane(LaneName, 'AlignedDesign', 1, fig_num);
    %
    % % Lane 4: Exit transition road
    % LaneName = 'Scenario_1_5_ExitTransitionRoad_m2_NewLane1_DoubleYellowLeft';
    % LanesToMap{4} = fcn_LoadWZ_loadLane(LaneName, 'AlignedDesign', 1, fig_num);
    %
    % % Lane 5: Outer loop road main lane exit
    % LaneName = 'Scenario_1_5_OuterLoopRoad_m1_MainLoopOuterLaneExit';
    % LanesToMap{5} = fcn_LoadWZ_loadLane(LaneName, 'AlignedDesign', 1, fig_num);
    %
    % % load objects
    % % Initialize figure for visualization
    % fig_num = 2343;
    % figure(fig_num);
    % clf;
    %
    % [ObjectClusterNames,~] = fcn_LoadWZ_nameObjectClusters;
    %
    % % FORMAT: [flags_whichIsSelected] = fcn_LoadWZ_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
    % if 1 == flag_gridObjects
    %     isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_1_5_GridChannelizers'},{});
    %     gridText = '_GridObjects';
    % else
    %     isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_1_5'},{});
    % end
    % application_string = 'AlignedDesign';
    % objectCluster = cell(0);
    % N_ObjectClusters = length(ObjectClusterNames);
    % for ith_objectCluster = 1:N_ObjectClusters
    %     if isPlotted(ith_objectCluster)
    %         objectClusterName = ObjectClusterNames{ith_objectCluster};
    %         objectCluster{end+1} = fcn_LoadWZ_loadObjectCluster(objectClusterName, application_string, 0, fig_num); %#ok<SAGROW>
    %         title(sprintf('Object cluster %.0d: %s',ith_objectCluster, objectClusterName),'Interpreter','none');
    %
    %     end
    % end
    %
    % disp(ObjectClusterNames(isPlotted)');
    % % Initialize an array to store object coordinates
    % objectsENU = [];
    %
    % % Aggregate coordinates of all objects into one array, removing duplicates later
    % for ii = 1:4
    %     objectsENU = [objectsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU]; %#ok<AGROW>
    % end
    %
    % % Remove duplicate coordinates to avoid redundancy
    % objectsENU = unique(objectsENU, 'rows','stable');
    %
    %
    % % Load signals (signs)
    % fig_num = 2343;
    % figure(fig_num);
    % clf;
    %
    % [ObjectClusterNames,ApplicationTypeStrings] = fcn_LoadWZ_nameObjectClusters;
    %
    % % FORMAT: [flags_whichIsSelected] = fcn_LoadWZ_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
    % isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_1_5'},{});
    % %isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_1_5_GridChannelizers'},{});
    % application_string = 'AlignedDesign';
    % objectCluster = cell(0);
    % N_ObjectClusters = length(ObjectClusterNames);
    % for ith_objectCluster = 1:N_ObjectClusters
    %     if isPlotted(ith_objectCluster)
    %         objectClusterName = ObjectClusterNames{ith_objectCluster};
    %         objectCluster{end+1} = fcn_LoadWZ_loadObjectCluster(objectClusterName, application_string, 0, fig_num); %#ok<SAGROW>
    %         title(sprintf('Object cluster %.0d: %s',ith_objectCluster, objectClusterName),'Interpreter','none');
    %
    %     end
    % end
    %
    % signalsENU = [];
    % signalsName = cell(0);
    %
    % for ii = 9:length(objectCluster)
    %     signalsENU = [signalsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU]; %#ok<AGROW>
    %     signalsName{end+1} = objectCluster{ii}.objectClusterName; %#ok<SAGROW>
    % end
    %
    % % Define name and retrieve road center coordinates by the name
    % center_trace_name = 'AlignedDesign_NewLine2_Centerline';
    % [~, roadCenterENU_cell_array] = ...
    %     fcn_LoadWZ_loadCenterline(center_trace_name); % flag_bypass_full_load, plot_color, line_width, fig_num);
    % roadCenterENU = roadCenterENU_cell_array{1};
    %
    %
    % % Save the results
    % save(mat_filename,'LanesToMap','objectsENU','signalsENU','signalsName','roadCenterENU');

end
Lane1 = LanesToMap{1};
Lane3 = LanesToMap{3};
Lane4 = LanesToMap{4};


%% Separate data into lane sections
% each section has constant number of left and right lanes
% each section's centerline has a specific line type
% each right/left lane has a specific line type and lane width


%% Find lane sections
% Section changes occur when:
% the markings change
% - markings are determined by the side away from center
% OR
% the number of lanes change
% - this can be detected by looking at the s-coordinates of each right
% boundary of the lane. Any place they overlap in the s-domain means there
% is more than one lane. The number of lanes can be determined by counting
% the number of overlaps.

% The lane offsets change when
% the curves describing the offset change geometrically, i.e. there's a
% geometric change. This is not tested for yet.

%% Find where the markings change
figure(3838);
clf;
hold on;
axis equal;
grid on;


% Make a list of all markings
N_lanes = length(LanesToMap);
N_markings = 0;
N_right_boundaries = 0;

all_marking_centerlines = cell(2*N_lanes,1);
all_marking_right_centerlines = cell(N_lanes,1);
all_marking_structures  = cell(2*N_lanes,1);
for ith_laneSection = 1:N_lanes
    N_markings = N_markings+1;
    N_right_boundaries = N_right_boundaries+1;
    all_marking_centerlines{N_markings}               = LanesToMap{ith_laneSection}.RightBoundary.ENU;
    all_marking_structures{N_markings}                = LanesToMap{ith_laneSection}.RightMarkerCluster;
    all_marking_right_centerlines{N_right_boundaries} = LanesToMap{ith_laneSection}.RightBoundary.ENU;

    plot(all_marking_centerlines{N_markings}(:,1),all_marking_centerlines{N_markings}(:,2),'r-','LineWidth',3);


    N_markings = N_markings+1;
    all_marking_centerlines{N_markings} = LanesToMap{ith_laneSection}.LeftBoundary.ENU;
    all_marking_structures{N_markings}  = LanesToMap{ith_laneSection}.LeftMarkerCluster;

    plot(all_marking_centerlines{N_markings}(:,1),all_marking_centerlines{N_markings}(:,2),'b-','LineWidth',3);

end

% Check which marks are connected
% To be connected, the end of one mark has to be at the start of another,
% and the color and style of the mark has to be same.
%
% Initialize the connectivity matrix (rows are from, columns are to)
% For each connected one, mark if their style changes - keeping the
% s-coordinate



threshold = 2; % 1 meter
ConnectivityMatrix = zeros(N_markings,N_markings);
points_of_marking_changes = [];

for ith_end = 1:N_markings
    ending_point = all_marking_centerlines{ith_end}(end,:);
    for jth_start = 1:N_markings
        starting_point = all_marking_centerlines{jth_start}(1,:);
        distance = abs(sum((ending_point-starting_point).^2,2).^0.5);
        if distance<threshold
            ConnectivityMatrix(ith_end,jth_start)=1;

            % Check if the style changes
            isSameMarker = fcn_INTERNAL_isMarkingSameStyle(...
                all_marking_structures{ith_end}.markerClusterTraces, ...
                all_marking_structures{jth_start}.markerClusterTraces);

            if ~isSameMarker
                new_point = mean([ending_point;starting_point],1);
                points_of_marking_changes = [points_of_marking_changes; new_point]; %#ok<AGROW>
                plot(new_point(:,1),new_point(:,2),'g.','MarkerSize',30);

            end
        end
    end
end

%% Find the points where the number of lanes changes

figure(2343);
clf;
hold on;
% axis equal;
grid on;

% Find the s-coordinate of all right boundaries
N_right_boundaries = length(all_marking_right_centerlines);

% Initialize empty cell arrays and reference path to use
all_marking_right_centerlines_st_coords = cell(N_lanes,1);
referencePath = roadCenterENU(:,1:2);
right_centerlines_st_coords_start = zeros(N_right_boundaries,2);
right_centerlines_st_coords_end   = zeros(N_right_boundaries,2);

% For each right boundary, convert into St coordinates
for ith_right = 1:N_right_boundaries
    XY_points = all_marking_right_centerlines{ith_right}(:,1:2);
    flag_snap_type = 1;
    St_points = fcn_Path_convertXY2St(referencePath,XY_points, flag_snap_type);
    St_points = real(St_points);
    all_marking_right_centerlines_st_coords{ith_right} = St_points;
    right_centerlines_st_coords_start(ith_right,:) = St_points(1,:);
    right_centerlines_st_coords_end(ith_right,:)   = St_points(end,:);

    plot(St_points(:,1),St_points(:,2),'-');


end

% Check to see if any overlap in right lane markings across the same
% s-coordinates. If so, calculate where and how much
fig_num = 38383;
station_tolerance = 1;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes(right_centerlines_st_coords_start(:,1), right_centerlines_st_coords_end(:,1), station_tolerance, (fig_num));

% Goal at end is to determine the number of lane sections
N_lane_sections = 3;

%% Convert to XODR structure

% Define the speed limit for this road
speedlimit = 25;

% Define the centerline of the road
roadCenterLine = roadCenterENU;

% Define how far apart the road is resampled
resampleStationInterval = 10;


%% Set up file info
% Set the base name for the output scenario file
scenarioName = 'scenario1_5';

% Define the save directory
XODR_save_directory = fullfile(cd,'Data',filesep,'XODR_outputs');

% Get the current date and time in a specific format ('YYYY_MM_DDTHH_MM_SS')
% and convert it to a string. 'T' is a literal character.
datetimeString = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy_MM_dd''T''HH_mm_ss'));

% Concatenate the scenario name with the current date and time to form the output file name
outputFileName = strcat(scenarioName,'_',datetimeString);

% Name the subdirectory for storage
if exist(XODR_save_directory,'dir')~=7
    warning('backtrace','on')
    warning('Unable to find storage directory %s for XODR file - quitting.',XODR_save_directory);
    error('Unable to find directory: %s',XODR_save_directory);
end

% Add the save directory to the filename
full_filename = fullfile(XODR_save_directory,outputFileName);

%% Code to be functionalized starts here
% Inputs:
% full_filename
% speedlimit, 
% roadCenterLine, 
% resampleStationInterval
% LanesToMap 
% objectsENU 
% signalsENU 
% signalsName


% Initialize an empty road structure
roads = fcn_ParseXODR_fillDefaultRoadNetwork;

% Remove unnecessary fields 'elevationProfile' and 'lateralProfile' from the road structure
roads.OpenDRIVE.road{1} = rmfield(roads.OpenDRIVE.road{1},{'elevationProfile','lateralProfile'});

% Define a speed limit and fill in the road type for the road structure
roads.OpenDRIVE.road{1}.type = fcn_ParseXODR_fillRoadType(speedlimit);

% Retrieve the centerline of the road from the 'Lane' data and fill in the plan view for the road
% [roads,new_traversal] = fcn_ParseXODR_fillPlanView(roads,roadCenterLine,resampleStationInterval);
[planView, totalStationLength] = fcn_ParseXODR_fillPlanViewViaLineSegments(roadCenterLine, resampleStationInterval, fig_num);

% Update the road with the results
roads.OpenDRIVE.road{1}.planView = planView;
roads.OpenDRIVE.road{1}.Attributes.length = num2str(totalStationLength);

%% View the results so far
fig_num = 1;

% Create a blank figure in which to plot the roads
figure(fig_num)
clf

% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

flag_plot_road_geometry = [];

% Call the plotting function
fcn_ParseXODR_plotXODRinENU(roads,minPlotGap,flag_plot_road_geometry,fig_num);


%% Start defining lane information
% Initialize lane offset for the road
roads.OpenDRIVE.road{1}.lanes.laneOffset{1} = fcn_ParseXODR_fillLaneOffset(roads.OpenDRIVE.road{1}.lanes.laneOffset{1}, 0,0,0,0,0);

%% Define lane sections
% Lane sections are where the number of lanes or types of markings change

blank_template_lane_section = roads.OpenDRIVE.road{1}.lanes.laneSection{1};
LaneSections{1} = Lane1;
LaneSections{2} = Lane3;
LaneSections{3} = Lane4;

% Fill in lane counts
numOfLeftLanes  = [0; 2; 0];
numOfRightLanes = [1; 1; 1];
flag_shoulders  = [0; 0; 0];


for ith_laneSection = 1:N_lane_sections

    % Grab CurrentLaneSection
    CurrentLaneSection = LaneSections{ith_laneSection};

    % Fill in blank template for lane section
    roads.OpenDRIVE.road{1}.lanes.laneSection{ith_laneSection} = blank_template_lane_section;

    % Fill in s for current lane section
    XY_points = CurrentLaneSection.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU(1,1:2);
    referencePath = roadCenterLine(:,1:2);
    flag_snap_type = 1;
    St_points = fcn_Path_convertXY2St(referencePath,XY_points, flag_snap_type, []); % fig_num empty, does not plot
    startingPoint = St_points(1);    
    roads.OpenDRIVE.road{1}.lanes.laneSection{ith_laneSection}.Attributes.s = num2str(startingPoint);

    % Single side?
    roads.OpenDRIVE.road{1}.lanes.laneSection{ith_laneSection}.Attributes.singleSide = 'false';

    % Fill in the lanes in this section
    numOfLeftLane  = numOfLeftLanes(ith_laneSection,1);
    numOfRightLane = numOfRightLanes(ith_laneSection,1);
    flag_shoulder  = flag_shoulders(ith_laneSection,1);

    % Fill in a section template
    section_template = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane,numOfRightLane,speedlimit);

    % Fill in markings
    if ith_laneSection == 2
        section_template.centerMarkStruct.Attributes.type = 'broken solid';
        section_template.leftMarkStruct(1).Attributes.color = 'yellow';
        section_template.leftMarkStruct(1).Attributes.type = 'solid broken';
    end

    % Fill in lane section details
    starter_laneSection = roads.OpenDRIVE.road{1}.lanes.laneSection{ith_laneSection};
    laneSection = fcn_ParseXODR_fillLaneSection(starter_laneSection, section_template, flag_shoulder);
    roads.OpenDRIVE.road{1}.lanes.laneSection{ith_laneSection} = laneSection;
        
end


%% Check results
% Perform checks and adjustments on the road segment, ensuring it adheres to OpenDRIVE standards
ODRStruct = fcn_ParseXODR_checkXODR(roads);


%% Add objects

% Add object coordinates to the OpenDRIVE structure
ODRStruct = fcn_ParseXODR_addObjects(ODRStruct, roadCenterLine, objectsENU, 0.608);

%% Add signals
if 1 == flag_addSignals
    for ii = 1:length(signalsName)
        ODRStruct = fcn_ParseXODR_addSignals(ODRStruct,roadCenterLine,signalsENU(ii,:),ii,signalsName{ii});
    end
    outputFileName = [outputFileName,'_WithSigns'];

end

%% Do final file conversion
% Assign the formatted date and time to the 'date' attribute within the header
ODRStruct.OpenDRIVE.header.Attributes.date = datetimeString;


% Prepare the final output structure with header and road information
outputStruct.OpenDRIVE.header = ODRStruct.OpenDRIVE.header;
outputStruct.OpenDRIVE.road = ODRStruct.OpenDRIVE.road;
outputFileName = [outputFileName,gridText];

% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(outputStruct, full_filename);


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

function isSameMarker = fcn_INTERNAL_isMarkingSameStyle(markerCluster1, markerCluster2)

isSameMarker = 1;
if length(markerCluster1)~=length(markerCluster2)
    isSameMarker = 0;
    return;
end

for jth_marker = 1:length(markerCluster1)

    marker1toTest = markerCluster1{jth_marker};
    marker2toTest = markerCluster2{jth_marker};

    % Find the color of the first cluster
    if any(isnan(marker1toTest.MarkerTapeColors))
        color1 = marker1toTest.MarkerPaintColors;
        type1  = marker1toTest.MarkerPaintTypes;
    else
        color1 = marker1toTest.MarkerTapeColors;
        type1  = marker1toTest.MarkerTapeTypes;
    end

    % Find the color of the second cluster
    if any(isnan(marker2toTest.MarkerTapeColors))
        color2 = marker2toTest.MarkerPaintColors;
        type2  = marker2toTest.MarkerPaintTypes;
    else
        color2 = marker2toTest.MarkerTapeColors;
        type2  = marker2toTest.MarkerTapeTypes;
    end

    % Check if they are the same
    if ~isequal(color1,color2)
        isSameMarker = 0;
        return;
    end

    if ~isequal(type1,type2)
        isSameMarker = 0;
        return;
    end
end
end