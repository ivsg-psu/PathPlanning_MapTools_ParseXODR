% script_ParseXODR_simpleExampleRoads
% This script demonstrates the creation of basic road shapes according to the ASAM OPENDRIVE standard.

%% example 1: simple road of line shape
clear;  % Clearing the workspace to remove any existing variables.

% Initializing the OpenDRIVE structure with header information.
ODRStruct.OpenDRIVE.header.Attributes.revMajor = '1';  % Major revision number of the standard.
ODRStruct.OpenDRIVE.header.Attributes.revMinor = '6';  % Minor revision number.
ODRStruct.OpenDRIVE.header.Attributes.date = datestr(now,'yyyy-mm-ddTHH:MM:SS');  % Current date and time.
ODRStruct.OpenDRIVE.header.Attributes.vendor = 'PSU-IVSG';  % Vendor information.
ODRStruct.OpenDRIVE.header.Attributes.version = '1';  % Version of the data structure.

% Defining the road element within the OpenDRIVE structure.
ODRStruct.OpenDRIVE.road{1}.Attributes.id = '1';  % Unique identifier for the road.
ODRStruct.OpenDRIVE.road{1}.Attributes.junction = '-1';  % Indicates that this road is not part of a junction.
ODRStruct.OpenDRIVE.road{1}.Attributes.name = 'Example Road';  % Name of the road.
ODRStruct.OpenDRIVE.road{1}.Attributes.rule = 'RHT';  % Driving rule, right-hand traffic.
ODRStruct.OpenDRIVE.road{1}.Attributes.length = '100';  % Length of the road in meters.

% Initializing the planView structure for the road geometry.
ODRStruct.OpenDRIVE.road{1}.planView = struct;

% Defining a single geometry element for the road.
ODRStruct.OpenDRIVE.road{1}.planView.geometry = cell(1);
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.length = '100';  % Length of this road segment.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.s = '0';  % Start position of the segment.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.x = '0';  % X-coordinate of the start point.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.y = '0';  % Y-coordinate of the start point.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.hdg = '0';  % Heading angle at the start point.

% Specifying that the geometry is a straight line.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.line = struct;

% Defining lane sections for the road.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.s = '0';  % Start position of the lane section.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.singleSide = 'false';  % Indicates lanes on both sides of the road center.

% Defining the center lane properties.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.center.lane.Attributes.id = '0';  % Lane identifier.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.center.lane.Attributes.level = 'false';  % Level of the lane.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.center.lane.Attributes.type = 'none';  % Type of the lane.

% Defining properties of the right lane.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.Attributes.id = '-1';  % Lane identifier.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.Attributes.level = 'false';  % Level of the lane.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.Attributes.type = 'driving';  % Type of the lane (driving lane).
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.sOffset = '0';  % Start offset for width definition.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.a = '3.65';  % Width of the lane.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.d = '0';

% Performing checks on the road segment structure.
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Converting the OpenDRIVE structure to an XODR file format.
fcn_ParseXODR_convertODRstructToXODRFile(ODRStruct,'simpleExampleRoad_line');
