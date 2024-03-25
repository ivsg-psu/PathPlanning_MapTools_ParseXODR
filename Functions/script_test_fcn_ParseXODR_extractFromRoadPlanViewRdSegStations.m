%% script_test_fcn_ParseXODR_extractFromRoadPlanViewRdSegStations
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromRoadPlanViewRdSegStations
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" written by C. Beal Questions or comments?
% sbrennan@psu.edu

% Revision history:
% 2024_03_21 - S. Brennan
% -- wrote the code

close all


%% workzone_100m_Lane_Offset
fig_num = 1;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example only has 1 road segment
assert(length(roadSegmentStations(:,1))==1);
assert(length(roadSegmentStations(1,:))==2);

% Check values - this example is exactly 100 meters long
assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
assert(isequal(round(roadSegmentStations(1,2),4),round(100,4)));

%% Ex_Complex_Lane_Offset - 100 meters
fig_num = 2;
figure(fig_num)
clf

example_file = 'Ex_Complex_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example only has 2 road segments
assert(length(roadSegmentStations(:,1))==2);
assert(length(roadSegmentStations(1,:))==2);

% Check values - this example is exactly 50 meters long in both segments
assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
assert(isequal(round(roadSegmentStations(1,2),4),round(50,4)));
assert(isequal(round(roadSegmentStations(2,1),4),round(50,4)));
assert(isequal(round(roadSegmentStations(2,2),4),round(100,4)));

%% Ex_Simple_Lane_Offset_Reversed - 100 meters
fig_num = 3;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset_Reversed.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example only has 1 road segment
assert(length(roadSegmentStations(:,1))==1);
assert(length(roadSegmentStations(1,:))==2);

% Check values - this example is exactly 100 meters long
assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
assert(isequal(round(roadSegmentStations(1,2),4),round(100,4)));

%% Ex_Simple_Lane_Offset - 100 meters
fig_num = 4;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example only has 1 road segment
assert(length(roadSegmentStations(:,1))==1);
assert(length(roadSegmentStations(1,:))==2);

% Check values - this example is exactly 100 meters long
assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
assert(isequal(round(roadSegmentStations(1,2),4),round(100,4)));

%% Ex_Simple_Lane_Gains
fig_num = 5;
figure(fig_num)
clf

example_file = 'Ex_Simple_Lane_Gains.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example only has 1 road segment
assert(length(roadSegmentStations(:,1))==1);
assert(length(roadSegmentStations(1,:))==2);

% Check values - this example is exactly 200 meters long
assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
assert(isequal(round(roadSegmentStations(1,2),4),round(200,4)));


%% workzone_50m_curve_barrels
fig_num = 6;
figure(fig_num)
clf

example_file = 'workzone_50m_curve_barrels.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example only has 1 road segment
assert(length(roadSegmentStations(:,1))==1);
assert(length(roadSegmentStations(1,:))==2);

% Check values - this example is exactly 50 meters long
assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
assert(isequal(round(roadSegmentStations(1,2),4),round(50,4)));
%% testTrack_outerTrack
fig_num = 7;
figure(fig_num)
clf

example_file = 'testTrack_outerTrack.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);


% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
% lengthRoad = str2double(current_road.Attributes.length);
% Npoints = 20;
% stationPoints = linspace(0,lengthRoad,Npoints)';

% Extract the path coordinate lane information from the XODR file for the
% first road in the specified XODR file
roadSegmentStations = fcn_ParseXODR_extractFromRoadPlanViewRdSegStations(planView_geometry, fig_num);

% Check lengths - this example has 154 road segments
assert(length(roadSegmentStations(:,1))==154);
assert(length(roadSegmentStations(1,:))==2);

% % Check values - this example is exactly 100 meters long
% assert(isequal(round(roadSegmentStations(1,1),4),round(0,4)));
% assert(isequal(round(roadSegmentStations(1,2),4),round(100,4)));