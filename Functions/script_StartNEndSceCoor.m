sce1 = readtable(['C:\Users\ccctt\OneDrive - The Pennsylvania State University\Documents\GitHub' ...
    '\FieldDataCollection_VisualizingFieldData_LoadWorkZone\Data\Scenario1-1\Scenario1-1_objects.csv']);
[S,X,Y] = fcn_extractCenterLine('testTrack_outerTrack.xodr');
figure();
geoplot(sce1.Latitude,sce1.Longitude,'ro')
geobasemap('satellite');

wzStart.lat = 40.862461390000000;
wzStart.lon = -77.834039450000000;

wzEnd.lat = 40.864241830000000;
wzEnd.lon = -77.831054190000000; 

wzStart.alt = 333.817;
reference_LLA = [40.86368573, -77.83592832, 344.189];

Pstart = [wzStart.lat,wzStart.lon,wzStart.alt];
Pend = [wzEnd.lat,wzEnd.lon,wzStart.alt];

enuStart = fcn_GPS_lla2enu(Pstart,reference_LLA);
enuEnd = fcn_GPS_lla2enu(Pend,reference_LLA);

pathXY = [X,Y];
figure();
plot(X,Y);
hold on;
% plot(1.592789617110226e+02,-1.359405412612701e+02,'r*');

point1 = [enuStart(1), enuStart(2)];
point2 = [enuEnd(1),enuEnd(2)];

% Define the snap type (1 indicates a specific type of snapping, 
% you can provide more details if necessary)
flag_snap_type = 1;

% Snap the current vehicle's position onto the nearest path using the 
% fcn_Path_snapPointOntoNearestPath function
[closest_path_point, s_coordinate1, first_path_point_index, second_path_point_index, ...
    percent_along_length, distance_real, distance_imaginary] = ...
    fcn_Path_snapPointOntoNearestPath(point1, pathXY, flag_snap_type);
[closest_path_point, s_coordinate2, first_path_point_index, second_path_point_index, ...
    percent_along_length, distance_real, distance_imaginary] = ...
    fcn_Path_snapPointOntoNearestPath(point2, pathXY, flag_snap_type);

