%   _____                           _      _  _  __ _     
%  / ____|                         (_)    | || |/_ | |    
% | (___   ___ ___ _ __   __ _ _ __ _  ___| || |_| | |__  
%  \___ \ / __/ _ \ '_ \ / _` | '__| |/ _ \__   _| | '_ \ 
%  ____) | (_|  __/ | | | (_| | |  | | (_) | | |_| | |_) |
% |_____/ \___\___|_| |_|\__,_|_|  |_|\___/  |_(_)_|_.__/ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script creates xodr file for ADS scenario 4.1b.
% It sets up road and lane structures, adds objects and signals,
% and finally generates an XODR file based on these configurations.
% 
% Author: Wushuang Bai, wxb41@psu.edu
% Revision history:
% 20231204 - Initial script setup
% 20231205 - Added comments and enhanced documentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; 
close all; clc;

% Initialize flags for adding signals and objects
flag_addSignals = 0;
flag_gridObjects = 0;
gridText = [];

%% define road center 

ApplicationString = 'AlignedDesign';
% ApplicationString = 'DesignDrawings';

fig_num = 41300; % Numbered 413 because it sounds like 4-1-"b"
figure(fig_num);
clf;

Lane1 = fcn_LoadWZ_loadLane('Scenario_4_1b_OuterLoopRoad_m1_MainLoopOuterLaneEntry', ApplicationString, 1, fig_num);
Lane2 = fcn_LoadWZ_loadLane('Scenario_4_1b_EntryTransitionRoad_m1_NewLane4_DoubleYellowLeft', ApplicationString, 1, fig_num);

% start of section 2
Lane3 = fcn_LoadWZ_loadLane('Scenario_4_1b_EntryTransitionTwoLaneSpace_m1_NewLane4_DoubleYellowLeft', ApplicationString, 1, fig_num);
Lane4 = fcn_LoadWZ_loadLane('Scenario_4_1b_EntryTransitionDoubleLane_m1_NewLane4_DoubleYellowLeft', ApplicationString, 1, fig_num);
%Lane5 = fcn_LoadWZ_loadLane('Scenario_4_1b_ExitStraightaway_doubleLane', ApplicationString, 1, fig_num);
Lane6 = fcn_LoadWZ_loadLane('Scenario_4_1b_ExitStraightawayIntoTransition_doubleLane', ApplicationString, 1, fig_num);

% start of section 3
Lane7 = fcn_LoadWZ_loadLane('Scenario_4_1b_ExitTransitionRoad_m1_NewLane4_DoubleYellowLeft', ApplicationString, 1, fig_num);
Lane8 = fcn_LoadWZ_loadLane('Scenario_4_1b_OuterLoopRoad_m1_MainLoopOuterLaneExit', ApplicationString, 1, fig_num);


% Aggregate road center ENU coordinates
roadCenterENU = [Lane1.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane2.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane3.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane4.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    %Lane5.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane6.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane7.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane8.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    ];

% make sure there is no overlap
figure();
plot(roadCenterENU(:,1),roadCenterENU(:,2));


% Set the base name for the output scenario file
scenarioName = 'scenario4_1b';

% Get the current date and time in a specific format ('YYYY_MM_DDTHH_MM_SS') 
% and convert it to a string. 'T' is a literal character.
dt = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy_MM_dd''T''HH_mm_ss'));

% Concatenate the scenario name with the current date and time to form the output file name
outputFileName = strcat(scenarioName,'_',dt);

% Initialize an empty road structure
roads = fcn_ParseXODR_createEmptyRoad;

% Assign attributes to the first road in the structure. Set its ID, junction type, 
% name, and driving rule (Right Hand Traffic, RHT).
roads.OpenDRIVE.road{1}.Attributes.id = num2str(numel(roads.OpenDRIVE.road) - 1);
roads.OpenDRIVE.road{1}.Attributes.junction = '-1';
roads.OpenDRIVE.road{1}.Attributes.name = ['Road ',roads.OpenDRIVE.road{1}.Attributes.id];
roads.OpenDRIVE.road{1}.Attributes.rule = 'RHT';

% Define a speed limit and fill in the road type for the road structure
speedlimit = 25;
roads = fcn_ParseXODR_fillRoadType(roads,speedlimit);

% Retrieve the centerline of the road from the 'Lane' data and fill in the plan view for the road
roadCenterLine = roadCenterENU;
resampleStationInterval = 10;
[roads,new_traversal] = fcn_ParseXODR_fillPlanView(roads,roadCenterLine,resampleStationInterval);

% Remove unnecessary fields 'elevationProfile' and 'lateralProfile' from the road structure
roads.OpenDRIVE.road{1} = rmfield(roads.OpenDRIVE.road{1},{'elevationProfile','lateralProfile'});

%% define lane section 
% Initialize lane offset for the road
roads.OpenDRIVE.road{1}.lanes.laneOffset = fcn_ParseXODR_fillLaneOffset(roads.OpenDRIVE.road{1}.lanes.laneOffset, 0,0,0,0,0);

% Define a single lane section with attributes
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.s = '0';
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.singleSide = 'false';

% There are 3 lane sections in total
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = roads.OpenDRIVE.road{1}.lanes.laneSection{1};
roads.OpenDRIVE.road{1}.lanes.laneSection{3} = roads.OpenDRIVE.road{1}.lanes.laneSection{1};

% get s for lane section 2
XY_points = Lane3.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU(1,1:2);
referencePath = roadCenterLine(:,1:2);
flag_snap_type = 1;
fig_num = 111;
St_points = fcn_Path_convertXY2St(referencePath,XY_points, flag_snap_type,fig_num);
start.section2 = St_points(1);

% get s for lane section 3

XY_points = Lane7.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU(1,1:2);
referencePath = roadCenterLine(:,1:2);
flag_snap_type = 1;
fig_num = 111;
St_points = fcn_Path_convertXY2St(referencePath,XY_points, flag_snap_type,fig_num);
start.section3 = St_points(1);

roads.OpenDRIVE.road{1}.lanes.laneSection{2}.Attributes.s = num2str(start.section2);
roads.OpenDRIVE.road{1}.lanes.laneSection{3}.Attributes.s = num2str(start.section3);


%% Definition for lane section 1
numOfLeftLane = 0;
numOfRightLane = 1;
flag_shoulder = 0;
section1 = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane,numOfRightLane,speedlimit); 

% Since this scenario does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.left = [];

% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{1} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{1}, ...
    'right', 1, section1.rightWidthStruct, section1.rightMarkStruct, section1.rightSpeedStruct, flag_shoulder);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{1} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{1}, ...
    'center', 1, [], section1.centerMarkStruct, [], flag_shoulder);

%% Definition for lane section 2
numOfLeftLane = 0;
numOfRightLane = 3;
flag_shoulder = 1;
section2 = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane,numOfRightLane,speedlimit);

% update the road mark 
section2.rightMarkStruct(2).Attributes.type = 'solid';
section2.rightMarkStruct(3).Attributes.type = 'none';
section2.rightWidthStruct(3).Attributes.a = '7.3';

% Since this scenario does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{2}.left = [];

% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{2}, ...
    'right', numOfRightLane , section2.rightWidthStruct, section2.rightMarkStruct, section2.rightSpeedStruct, flag_shoulder);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{2}, ...
    'center', 1, [], section2.centerMarkStruct, [], flag_shoulder);


%% Definition for lane section 3
numOfLeftLane = 0;
numOfRightLane = 1;
flag_shoulder = 0;
section3 = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane,numOfRightLane,speedlimit);

% Since this scenario does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{3}.left = [];
% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{3} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{3}, ...
    'right', 1, section3.rightWidthStruct, section3.rightMarkStruct, section3.rightSpeedStruct, flag_shoulder);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{3} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{3}, ...
    'center', 1, [], section3.centerMarkStruct, [], flag_shoulder);


%% load objects
% Initialize figure for visualization
fig_num = 2343;
figure(fig_num);
clf;

[ObjectClusterNames,ApplicationTypeStrings] = fcn_LoadWZ_nameObjectClusters;

fig_num = 413;
figure(fig_num);
clf;

[ObjectClusterNames,~] = fcn_LoadWZ_nameObjectClusters;

% FORMAT: [flags_whichIsSelected] = fcn_LoadWZ_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_4_1b'},{});

application_string = 'AlignedDesign';
objectCluster = cell(0);
N_ObjectClusters = length(ObjectClusterNames);
for ith_objectCluster = 1:N_ObjectClusters
    if isPlotted(ith_objectCluster)
        objectClusterName = ObjectClusterNames{ith_objectCluster};
        objectCluster{end+1} = fcn_LoadWZ_loadObjectCluster(objectClusterName, application_string, 0, fig_num);
        title(sprintf('Object cluster %.0d: %s',ith_objectCluster, objectClusterName),'Interpreter','none');

    end
end

disp(ObjectClusterNames(isPlotted)');
% Initialize an array to store object coordinates
objectsENU = [];
if 0 ==flag_gridObjects
% Aggregate coordinates of all objects into one array, removing duplicates later
for ii = 1:4
    objectsENU = [objectsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU];
end
elseif 1== flag_gridObjects
    gridText = '_gridObjects';
for ii = 5:8
    objectsENU = [objectsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU];
end
end
% Remove duplicate coordinates to avoid redundancy
objectsENU = unique(objectsENU, 'rows','stable');

%% add objects
% Perform checks and adjustments on the road segment, ensuring it adheres to OpenDRIVE standards
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roads);

% Add object coordinates to the OpenDRIVE structure
ODRStruct = fcn_ParseXODR_addObjects(ODRStruct, roadCenterLine, objectsENU, 0.608);
signalsName = cell(0);

%% add signs 
% CMU does not use signs

%% file conversion 
% Assign the formatted date and time to the 'date' attribute within the header
ODRStruct.OpenDRIVE.header.Attributes.date = dt;
% Prepare the final output structure with header and road information
outputStruct.OpenDRIVE.header = ODRStruct.OpenDRIVE.header;
outputStruct.OpenDRIVE.road = ODRStruct.OpenDRIVE.road;
outputFileName = [outputFileName,gridText];
% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(outputStruct, outputFileName);



