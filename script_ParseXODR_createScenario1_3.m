 %                                _         __   ____  
 %                               (_)       /_ | |___ \ 
 %  ___  ___ ___ _ __   __ _ _ __ _  ___    | |   __) |
 % / __|/ __/ _ \ '_ \ / _` | '__| |/ _ \   | |  |__ < 
 % \__ \ (_|  __/ | | | (_| | |  | | (_) |  | |_ ___) |
 % |___/\___\___|_| |_|\__,_|_|  |_|\___/   |_(_)____/

clear;
close all;clc;
flag_addSignals = 0;
fig_num = 13000;
figure(fig_num);
clf;
ApplicationString = 'AlignedDesign';
Lane1 = fcn_LoadWZ_loadLane('Scenario_1_3_OuterLoopRoad_m1_MainLoopOuterLaneEntry', ApplicationString, 1, fig_num);
Lane2 = fcn_LoadWZ_loadLane('Scenario_1_3_EntryTransitionRoad_m2_NewLane1_DoubleYellowLeft', ApplicationString, 1, fig_num);
% start of lane section 2
Lane3 = fcn_LoadWZ_loadLane('Scenario_1_3_EntryMultiLaneHighway_m2_NewLane1_DoubleYellowLeft', ApplicationString, 1, fig_num);
%Lane3_1 = fcn_LoadWZ_loadLane('Scenario_1_3_ChannelizerTransition1', ApplicationString, 1, fig_num);
%Lane3_2 = fcn_LoadWZ_loadLane('Scenario_1_3_ChannelizerTransition2', ApplicationString, 1, fig_num);
%Lane4 = fcn_LoadWZ_loadLane('Scenario_1_3_MiddleMultiLaneHighway_m1_NewLane2_DoubleYellowRight', ApplicationString, 1, fig_num);
%Lane4_1 = fcn_LoadWZ_loadLane('Scenario_1_3_ChannelizerTransition3', ApplicationString, 1, fig_num);
Lane5 = fcn_LoadWZ_loadLane('Scenario_1_3_ExitMultiLaneHighway_m2_NewLane1_DoubleYellowLeft', ApplicationString, 1, fig_num);
% start of lane section 3
Lane6 = fcn_LoadWZ_loadLane('Scenario_1_3_ExitTransitionRoad_m2_NewLane1_DoubleYellowLeft', ApplicationString, 1, fig_num);
Lane7 = fcn_LoadWZ_loadLane('Scenario_1_3_OuterLoopRoad_m1_MainLoopOuterLaneExit', ApplicationString, 1, fig_num);

roadCenterENU = [Lane1.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane2.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane3.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane5.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane6.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
    Lane7.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU];



%%

% Set the base name for the output scenario file
scenarioName = 'scenario1_3';

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
[roads,new_traversal] = fcn_ParseXODR_fillPlanView(roads,roadCenterLine,5);

% Remove unnecessary fields 'elevationProfile' and 'lateralProfile' from the road structure
roads.OpenDRIVE.road{1} = rmfield(roads.OpenDRIVE.road{1},{'elevationProfile','lateralProfile'});

%% Start defining lane information
% Initialize lane offset for the road
roads.OpenDRIVE.road{1}.lanes.laneOffset = fcn_ParseXODR_fillLaneOffset(roads.OpenDRIVE.road{1}.lanes.laneOffset, 0,0,0,0,0);

% Define a single lane section with attributes
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.s = '0';
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.singleSide = 'false';

% There are 3 lane sections in total
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = roads.OpenDRIVE.road{1}.lanes.laneSection{1};
roads.OpenDRIVE.road{1}.lanes.laneSection{3} = roads.OpenDRIVE.road{1}.lanes.laneSection{1};




% get st-coordinates for lane section 2 and 3. 
XY_points = Lane3.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU(1,1:2);
referencePath = roadCenterLine(:,1:2);
flag_snap_type = 1;
fig_num = 111;
St_points = fcn_Path_convertXY2St(referencePath,XY_points, flag_snap_type,fig_num);
start.section2 = St_points(1);

XY_points = Lane6.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU(1,1:2);
referencePath = roadCenterLine(:,1:2);
flag_snap_type = 1;
fig_num = 111;
St_points = fcn_Path_convertXY2St(referencePath,XY_points, flag_snap_type,fig_num);
start.section3 = St_points(1);

roads.OpenDRIVE.road{1}.lanes.laneSection{2}.Attributes.s = num2str(start.section2);
roads.OpenDRIVE.road{1}.lanes.laneSection{3}.Attributes.s = num2str(start.section3);


%% Definition for lane section 1
section1.rightWidthStruct(1).Attributes.a = '3.65';
section1.rightWidthStruct(1).Attributes.b = '0';
section1.rightWidthStruct(1).Attributes.c = '0';
section1.rightWidthStruct(1).Attributes.d = '0';
section1.rightWidthStruct(1).Attributes.sOffset = '0';

% Define the right lane marking parameters
section1.rightMarkStruct(1).Attributes = struct();
section1.rightMarkStruct(1).Attributes.color = 'white';
section1.rightMarkStruct(1).Attributes.laneChange = 'none';
section1.rightMarkStruct(1).Attributes.material = 'standard';
section1.rightMarkStruct(1).Attributes.sOffset = '0';
section1.rightMarkStruct(1).Attributes.type = 'solid';
section1.rightMarkStruct(1).Attributes.weight = 'standard';
section1.rightMarkStruct(1).Attributes.width = '0.125';

% Define the center lane marking parameters
section1.centerMarkStruct(1).Attributes = struct();
section1.centerMarkStruct(1).Attributes.color = 'yellow';
section1.centerMarkStruct(1).Attributes.laneChange = 'none';
section1.centerMarkStruct(1).Attributes.material = 'standard';
section1.centerMarkStruct(1).Attributes.sOffset = '0';
section1.centerMarkStruct(1).Attributes.type = 'solid solid';
section1.centerMarkStruct(1).Attributes.weight = 'standard';
section1.centerMarkStruct(1).Attributes.width = '0.125';

% Define right lane speed limit parameters
section1.rightSpeedStruct(1) = struct();
section1.rightSpeedStruct(1).Attributes = struct();
section1.rightSpeedStruct(1).Attributes.max = num2str(speedlimit);
section1.rightSpeedStruct(1).Attributes.sOffset = '0';
section1.rightSpeedStruct(1).Attributes.unit = 'mph';


% Since scenario 1.1 does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.left = [];

% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{1} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{1}, ...
    'right', 1, section1.rightWidthStruct, section1.rightMarkStruct, section1.rightSpeedStruct, 0);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{1} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{1}, ...
    'center', 1, [], section1.centerMarkStruct, [], 0);

%% Definition for lane section 2
numOfLeftLane = 2;
numOfRightLane = 2;
section2 = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane,numOfRightLane,speedlimit);
section2.leftMarkStruct(1).Attributes.type = 'broken';


% Since scenario 1.1 does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{2}, ...
    'left', numOfLeftLane , section2.leftWidthStruct, section2.leftMarkStruct, section2.leftSpeedStruct, 0);

% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{2}, ...
    'right',numOfLeftLane , section2.rightWidthStruct, section2.rightMarkStruct, section2.rightSpeedStruct, 0);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{2} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{2}, ...
    'center', 1, [], section2.centerMarkStruct, [], 0);

%% Definition for lane section 3
numOfLeftLane = 0;
numOfRightLane = 1;
section3 = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane,numOfRightLane,speedlimit);

% Since scenario 1.1 does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{3}.left = [];
% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{3} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{3}, ...
    'right', 1, section3.rightWidthStruct, section3.rightMarkStruct, section3.rightSpeedStruct, 0);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{3} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{3}, ...
    'center', 1, [], section3.centerMarkStruct, [], 0);




%% Begin processing and visualizing object clusters
% Initialize figure for visualization
fig_num = 2343;
figure(fig_num);
clf;

[ObjectClusterNames,ApplicationTypeStrings] = fcn_LoadWZ_nameObjectClusters;

% FORMAT: [flags_whichIsSelected] = fcn_LoadWZ_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_1_3'},{});

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

% Aggregate coordinates of all objects into one array, removing duplicates later
for ii = 1:9
    objectsENU = [objectsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU];
end

% Remove duplicate coordinates to avoid redundancy
objectsENU = unique(objectsENU, 'rows','stable');

% Perform checks and adjustments on the road segment, ensuring it adheres to OpenDRIVE standards
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roads);

% Add object coordinates to the OpenDRIVE structure
ODRStruct = fcn_ParseXODR_addObjects(ODRStruct, roadCenterLine, objectsENU, 0.608);

%% add signs
signalsName = cell(0);
signalsENU = [];

for ii = length(objectCluster)-6:length(objectCluster)
    signalsENU = [signalsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU];
    signalsName{end+1} = objectCluster{ii}.objectClusterName;
end


if 1 == flag_addSignals
for ii = 1:length(signalsName)
ODRStruct = fcn_ParseXODR_addSignals(ODRStruct,roadCenterLine,signalsENU(ii,:),ii,signalsName{ii});
end
outputFileName = [outputFileName,'_WithSigns'];

end

%% writeout file
% Assign the formatted date and time to the 'date' attribute within the header
ODRStruct.OpenDRIVE.header.Attributes.date = dt;

% Prepare the final output structure with header and road information
outputStruct.OpenDRIVE.header = ODRStruct.OpenDRIVE.header;
outputStruct.OpenDRIVE.road = ODRStruct.OpenDRIVE.road;

% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(outputStruct, outputFileName);



