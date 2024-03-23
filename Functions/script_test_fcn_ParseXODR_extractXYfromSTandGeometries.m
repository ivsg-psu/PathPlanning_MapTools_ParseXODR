% script_test_fcn_ParseXODR_extractXYfromSTandGeometries
% Script to extract XY+heading in an XODR file.
% Tests function fcn_ParseXODR_extractXYfromSTandGeometries
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" written by C. Beal Questions or comments?
% sbrennan@psu.edu

% Revision history:
% 2024_03_21 - S. Brennan
% -- wrote the code

close all


%% BASIC call - no figure
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
lengthRoad = str2double(current_road.Attributes.length);
Npoints = 20;
stationPoints = linspace(0,lengthRoad,Npoints)';
transversePoints = 5*cos(stationPoints*(2*pi/40));

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(planView_geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
    [xPts, yPts, hPts] = fcn_ParseXODR_extractXYfromSTandGeometries(planView_geometry{segIdx},stationPoints,transversePoints);

    assert(length(xPts(:,1))==length(stationPoints(:,1)));
    assert(length(yPts(:,1))==length(stationPoints(:,1)));
    assert(length(hPts(:,1))==length(stationPoints(:,1)));
    assert(length(xPts(1,:))==1);
    assert(length(yPts(1,:))==1);
    assert(length(hPts(1,:))==1);
end

%% BASIC call - no transverse, with figure
fig_num = 2;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Call the plotting function to show the actual road
minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
flag_plot_road_geometry = [];
fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
lengthRoad = str2double(current_road.Attributes.length);
Npoints = 20;
stationPoints = linspace(0,lengthRoad,Npoints)';
% transversePoints = 5*cos(stationPoints*(2*pi/40));

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(planView_geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
    [xPts, yPts, hPts] = fcn_ParseXODR_extractXYfromSTandGeometries(planView_geometry{segIdx},stationPoints,[], fig_num);

    assert(length(xPts(:,1))==length(stationPoints(:,1)));
    assert(length(yPts(:,1))==length(stationPoints(:,1)));
    assert(length(hPts(:,1))==length(stationPoints(:,1)));
    assert(length(xPts(1,:))==1);
    assert(length(yPts(1,:))==1);
    assert(length(hPts(1,:))==1);

end

%% BASIC call - with transverse, with figure
fig_num = 3;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% % Call the plotting function to show the actual road
% minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
% flag_plot_road_geometry = [];
% fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
% title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
lengthRoad = str2double(current_road.Attributes.length);
Npoints = 20;
stationPoints = linspace(0,lengthRoad,Npoints)';
transversePoints = 5*cos(stationPoints*(2*pi/40));

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(planView_geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
    [xPts, yPts, hPts] = fcn_ParseXODR_extractXYfromSTandGeometries(planView_geometry{segIdx},stationPoints,transversePoints, fig_num);

    assert(length(xPts(:,1))==length(stationPoints(:,1)));
    assert(length(yPts(:,1))==length(stationPoints(:,1)));
    assert(length(hPts(:,1))==length(stationPoints(:,1)));
    assert(length(xPts(1,:))==1);
    assert(length(yPts(1,:))==1);
    assert(length(hPts(1,:))==1);

end

%% BASIC call - multiple transverse, with figure
fig_num = 4;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% % Call the plotting function to show the actual road
% minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
% flag_plot_road_geometry = [];
% fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num*100);
% title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
lengthRoad = str2double(current_road.Attributes.length);
Npoints = 20;
stationPoints = linspace(0,lengthRoad,Npoints)';
transversePoints = [5*cos(stationPoints*(2*pi/40)), 10*sin(stationPoints*(2*pi/30))+4];

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(planView_geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
    [xPts, yPts, hPts] = fcn_ParseXODR_extractXYfromSTandGeometries(planView_geometry{segIdx},stationPoints,transversePoints, fig_num);

    assert(length(xPts(:,1))==length(stationPoints(:,1)));
    assert(length(yPts(:,1))==length(stationPoints(:,1)));
    assert(length(hPts(:,1))==length(stationPoints(:,1)));
    assert(length(xPts(1,:))==2);
    assert(length(yPts(1,:))==2);
    assert(length(hPts(1,:))==2);

end

%% BASIC call - no figure, station points outside of range returns values
fig_num = 5;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% % Call the plotting function to show the actual road
% minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
% flag_plot_road_geometry = [];
% fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
% title(sprintf('%s',example_file),'Interpreter','none');


% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
lengthRoad = str2double(current_road.Attributes.length);
Npoints = 20;
stationPoints = linspace(lengthRoad+1,lengthRoad+100,Npoints)';
transversePoints = [5*cos(stationPoints*(2*pi/40)), 10*sin(stationPoints*(2*pi/30))+4];

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(planView_geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
    [xPts, yPts, hPts] = fcn_ParseXODR_extractXYfromSTandGeometries(planView_geometry{segIdx},stationPoints,transversePoints, fig_num);

    assert(length(xPts(:,1))==length(stationPoints(:,1)));
    assert(length(yPts(:,1))==length(stationPoints(:,1)));
    assert(length(hPts(:,1))==length(stationPoints(:,1)));
    assert(length(xPts(1,:))==2);
    assert(length(yPts(1,:))==2);
    assert(length(hPts(1,:))==2);

end

%% BASIC call - no figure, station points outside of range returns values
fig_num = 6;
figure(fig_num)
clf

example_file = 'workzone_100m_Lane_Offset.xodr';
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct(example_file);
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% % Call the plotting function to show the actual road
% minPlotGap = 0.2; % (m) % Choose a minimum spacing of the points defining the road geometries
% flag_plot_road_geometry = [];
% fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);
% title(sprintf('%s',example_file),'Interpreter','none');
% 

% Get the current road
current_road = ODRStruct.OpenDRIVE.road{1};

% Get the centerline geometry from this road
planView_geometry = current_road.planView.geometry;


% Decide the station points
lengthRoad = str2double(current_road.Attributes.length);
Npoints = 20;
stationPoints = linspace(-100,-1,Npoints)';
transversePoints = [5*cos(stationPoints*(2*pi/40)), 10*sin(stationPoints*(2*pi/30))+4];

% Determine the number of road geometry segments in the specified road in
% order to plot the lanes over the road geometry
Nsegments = length(planView_geometry);

% Iterate over all of the road geometry segments to determine the lane
% boundaries in (E,N) coordinates
for segIdx = 1:Nsegments
    [xPts, yPts, hPts] = fcn_ParseXODR_extractXYfromSTandGeometries(planView_geometry{segIdx},stationPoints,transversePoints, fig_num);

    assert(length(xPts(:,1))==length(stationPoints(:,1)));
    assert(length(yPts(:,1))==length(stationPoints(:,1)));
    assert(length(hPts(:,1))==length(stationPoints(:,1)));
    assert(length(xPts(1,:))==2);
    assert(length(yPts(1,:))==2);
    assert(length(hPts(1,:))==2);

end
