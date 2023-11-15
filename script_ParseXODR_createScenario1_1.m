% Clear all variables except for 'Lane'
clearvars -except Lane;

% Set the base name for the output scenario file
scenarioName = 'scenario1_1';

% Get the current date and time in a specific format ('YYYY_MM_DDTHH_MM_SS') 
% and convert it to a string. 'T' is a literal character.
dt = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy_MM_dd''T''HH_mm_ss'));

% Concatenate the scenario name with the current date and time to form the output file name
outputFileName = strcat(scenarioName,dt);

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
roadCenterLine = Lane.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
roads = fcn_ParseXODR_fillPlanView(roads,roadCenterLine);

% Remove unnecessary fields 'elevationProfile' and 'lateralProfile' from the road structure
roads.OpenDRIVE.road{1} = rmfield(roads.OpenDRIVE.road{1},{'elevationProfile','lateralProfile'});

%% Start defining lane information
% Initialize lane offset for the road
roads.OpenDRIVE.road{1}.lanes.laneOffset = fcn_ParseXODR_fillLaneOffset(roads.OpenDRIVE.road{1}.lanes.laneOffset, 0,0,0,0,0);

% Define a single lane section with attributes
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.s = '0';
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.singleSide = 'false';

% Define the right lane width parameters
rightWidthStruct(1).Attributes.a = '3.65';
rightWidthStruct(1).Attributes.b = '0';
rightWidthStruct(1).Attributes.c = '0';
rightWidthStruct(1).Attributes.d = '0';
rightWidthStruct(1).Attributes.sOffset = '0';
rightWidthStruct(2) = rightWidthStruct(1);

% Define the right lane marking parameters
rightMarkStruct(1).Attributes = struct();
rightMarkStruct(1).Attributes.color = 'white';
rightMarkStruct(1).Attributes.laneChange = 'none';
rightMarkStruct(1).Attributes.material = 'standard';
rightMarkStruct(1).Attributes.sOffset = '0';
rightMarkStruct(1).Attributes.type = 'solid';
rightMarkStruct(1).Attributes.weight = 'standard';
rightMarkStruct(1).Attributes.width = '0.125';
rightMarkStruct(2) = rightMarkStruct(1);

% Define the center lane marking parameters
centerMarkStruct(1).Attributes = struct();
centerMarkStruct(1).Attributes.color = 'yellow';
centerMarkStruct(1).Attributes.laneChange = 'none';
centerMarkStruct(1).Attributes.material = 'standard';
centerMarkStruct(1).Attributes.sOffset = '0';
centerMarkStruct(1).Attributes.type = 'solid solid';
centerMarkStruct(1).Attributes.weight = 'standard';
centerMarkStruct(1).Attributes.width = '0.125';

% Define right lane speed limit parameters
rightSpeedStruct(1) = struct();
rightSpeedStruct(1).Attributes = struct();
rightSpeedStruct(1).Attributes.max = num2str(speedlimit);
rightSpeedStruct(1).Attributes.sOffset = '0';
rightSpeedStruct(1).Attributes.unit = 'mph';
rightSpeedStruct(2) = rightSpeedStruct(1);

% Since scenario 1.1 does not have a left lane, set the left lane section to empty
roads.OpenDRIVE.road{1}.lanes.laneSection{1}.left = [];

% Fill in the right lane details: 1 driving lane and 1 shoulder
roads.OpenDRIVE.road{1}.lanes.laneSection{1} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{1}, 'right', 2, rightWidthStruct, rightMarkStruct, rightSpeedStruct, 1);

% Fill in the center lane details
roads.OpenDRIVE.road{1}.lanes.laneSection{1} = fcn_ParseXODR_fillLanes(roads.OpenDRIVE.road{1}.lanes.laneSection{1}, 'center', 1, [], centerMarkStruct, [], 0);

% Perform checks and adjustments on the road segment, ensuring it adheres to OpenDRIVE standards
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roads);

%% Begin processing and visualizing object clusters
% Initialize figure for visualization
fig_num = 2343;
figure(fig_num);
clf;

% Load names and types of object clusters for the work zone
[ObjectClusterNames, ApplicationTypeStrings] = fcn_LoadWZ_nameObjectClusters;

% Determine which object clusters are selected for the current scenario
isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames, {'Scenario_1_1'}, {});

% Define the application type for object cluster alignment
application_string = 'AlignedDesign';

% Iterate over all object clusters and process the selected ones
N_ObjectClusters = length(ObjectClusterNames);
for ith_objectCluster = 1:N_ObjectClusters
    if isPlotted(ith_objectCluster)
        objectClusterName = ObjectClusterNames{ith_objectCluster};
        objectCluster{ith_objectCluster} = fcn_LoadWZ_loadObjectCluster(objectClusterName, application_string, 1, fig_num);
        title(sprintf('Object cluster %.0d: %s', ith_objectCluster, objectClusterName), 'Interpreter', 'none');
    end
end

% Initialize an array to store object coordinates
objectsENU = [];

% Aggregate coordinates of all objects into one array, removing duplicates later
for ii = 1:length(objectCluster)
    objectsENU = [objectsENU; objectCluster{ii}.TraceCenterOfObjectCluster.ENU];
end

% Remove duplicate coordinates to avoid redundancy
objectsENU = unique(objectsENU, 'rows');

% Add object coordinates to the OpenDRIVE structure
ODRStruct = fcn_ParseXODR_addObjects(ODRStruct, roadCenterLine, objectsENU, 0.6);

% Assign the formatted date and time to the 'date' attribute within the header
ODRStruct.OpenDRIVE.header.Attributes.date = dt;

% Prepare the final output structure with header and road information
outputStruct.OpenDRIVE.header = ODRStruct.OpenDRIVE.header;
outputStruct.OpenDRIVE.road = ODRStruct.OpenDRIVE.road;

% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(outputStruct, outputFileName);
