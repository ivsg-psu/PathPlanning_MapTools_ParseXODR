% This script is used to determine the coordinates of objects/lanes in
% SUMO.
% The reason why this is needed, is that there are several coordinate
% systems used during the creation of scenarios. 
function fcn_transform_ENUtoSUMO(lat,lon)
% xodr directly generated from ENU coordinate

addpath(genpath('C:\Users\ccctt\OneDrive - The Pennsylvania State University\Documents\GitHub\PathPlanning_PathTools_PathClassLibrary\*'));
lat= 40.862298757000080;
lon= -77.834552794999980;
[s1,x1,y1] = fcn_extractCenterLine('TestTrackConvertedFromENU.xodr');
% xodr generated by RR based on the ENU one
[s2,x2,y2] = fcn_extractCenterLine('testTrack_outerTrack.xodr');
% The x and y offset during the creation of the network in RoadRunner
RRoffset.x = mean(x2-x1);
RRoffset.y = mean(y2-y1); 
SUMOnet= readstruct(['C:\Users\ccctt\OneDrive - The Pennsylvania State University\Documents\' ...
    'GitHub\TrafficSimulators_Project_SUMOSimulationForADSProject\maps\testTrack_outerTrack.net.xml']);
offsetStr = strsplit(SUMOnet.location.netOffsetAttribute,',');
%%
SUMOoffset.x = str2num(offsetStr(1));
SUMOoffset.y = str2num(offsetStr(2));

% LL: starting point of 3 lanes 

AltConst = 333.817;
reference_LLA = [40.86368573, -77.83592832, 344.189];
ENU.start = fcn_GPS_lla2enu([lat,lon,AltConst],reference_LLA);
figure();
plot(x1,y1);
hold on;
plot(ENU.start(1),ENU.start(2),'r*')

[RRx,RRy] = fcn_coorOffset(x1,y1,RRoffset.x,RRoffset.y);
figure();
plot(RRx,RRy,'r','LineWidth',2);
hold on;
plot(x2,y2,' k--','LineWidth',2);

% snap the point onto SUMO path
[SUMOx,SUMOy] = fcn_coorOffset(RRx,RRy,SUMOoffset.x,SUMOoffset.y);
[SUMOstart.x,SUMOstart.y] = fcn_coorOffset(ENU.start(1),ENU.start(2),RRoffset.x + SUMOoffset.x,RRoffset.y + SUMOoffset.y);

point = [SUMOstart.x,SUMOstart.y];
pathXY = [SUMOx,SUMOy];
flag_snap_type = 1;

fignum = 111;
[closest_path_point,s_coordinate,first_path_point_index,second_path_point_index,percent_along_length,distance_real,distance_imaginary] = ...
    fcn_Path_snapPointOntoNearestPath(point, pathXY,flag_snap_type,fignum);
fprintf(1,['Figure: %d,\n\t\t Closest point is: %.2f %.2f \n' ...
    '\t\t Matched to the path segment given by indices %d and %d, \n' ...
    '\t\t S-coordinate is: %.2f, \n' ...
    '\t\t percent_along_length is: %.2f\n' ...
    '\t\t real distance is: %.2f\n, ' ...
    '\t\t imag distance is %.2f\n, '],...
    fignum, closest_path_point(1,1),closest_path_point(1,2),...
    first_path_point_index,second_path_point_index, ...
    s_coordinate, percent_along_length,...
    distance_real,distance_imaginary);


end

