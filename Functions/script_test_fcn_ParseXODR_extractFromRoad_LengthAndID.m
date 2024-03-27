%% script_test_fcn_ParseXODR_extractFromRoad_LengthAndID
% Script to extract LaneGeometry in an XODR file.
% Tests function fcn_ParseXODR_extractFromRoad_LengthAndID
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


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));

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


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));


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


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));


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


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));


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


% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));



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




% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));


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




% Get the current road, road length, and lanes
current_road = ODRStruct.OpenDRIVE.road{1};

% Extract the key information
[lengthOfRoad,IDofRoad] = fcn_ParseXODR_extractFromRoad_LengthAndID(current_road, fig_num);

fprintf(1,'Road named: %s has a length of %.0d meters.\n',IDofRoad, lengthOfRoad);
% Check lengths - this example has 5 lane offset segments
assert(isnumeric(lengthOfRoad));
assert(lengthOfRoad>=0);
assert(ischar(IDofRoad)||isstring(IDofRoad));

