function fileName = fcn_convertDataPointsToARoad(enuData)
% This function works to convert a set of data points into a road. 
% Specifically, each pair of two data points forms a baby <line> segmeng in
% <geometry>, and in total, they form a road

% INPUTS: 
% - a set of data points in ENU coordinate

% OUTPUTS: 
% - the file name of exported xodr file

% This script works to write the xodr file for test track, using the data
% points exported from scenario CAD design
% Author: Wushuang
% Revision history:
% 20230520 first write of the code
% 20230521 added comments
% 20230523 edit to use path class to calculate traversal 
% 20230525 remove "data shifting"
% 20230601 added function to resample path data

% to add:
% variable of lane width, shoulder width
% add lane markers

% Load template xodr file
roadData = fcn_RoadSeg_convertXODRtoMATLABStruct('manual_stitchPointsForTestTrack.xodr');  

figure();
plot(enuData(:,1),enuData(:,2),'.','LineWidth',4);
xlabel('xEast [meters]');
ylabel('yNorth [meters]');
axis equal;
% convert from path to traversal
input_traversal = fcn_Path_convertPathToTraversalStructure(enuData);

interval = 10;
new_stations    = (0:interval:input_traversal.Station(end))';
% new_stations(end+1) = input_traversal.Station(end);

new_traversal = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);

%% manually close the gap after resampling
% 
x1= new_traversal.X(end);
y1 = new_traversal.Y(end);
x2 = new_traversal.X(1);
y2 = new_traversal.Y(1);
gapPath = [x1,y1;x2,y2];
gapTraversal = fcn_Path_convertPathToTraversalStructure(gapPath);

new_traversal.X(end+1) = x2;
new_traversal.Y(end+1) = y2;
new_traversal.Z(end+1) = new_traversal.Z(1);
new_traversal.Diff(end+1,:) = gapTraversal.Diff(end,:);
new_traversal.Station(end+1) = gapTraversal.Station(end) + new_traversal.Station(end);
new_traversal.Yaw(end+1) = gapTraversal.Yaw(end);


new_traversal.Yaw = real(new_traversal.Yaw);
% calculate the lengths of each line segment 
new_traversal.segmentLength = diff(new_traversal.Station);

%% plots
figure();
plot(enuData(:,1),enuData(:,2),'ko','LineWidth',2);
xlabel('xEast [meters]');
ylabel('yNorth [meters]');
legend('Raw ENU data');
axis equal;
figure();
plot(new_traversal.X,new_traversal.Y,'bo','LineWidth',2);
xlabel('xEast [meters]');
ylabel('yNorth [meters]');
legend('Resampled ENU data');
axis equal;

% write the new_traversal into open drive struct 
for ii = 1:length(new_traversal.segmentLength)
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.hdg = new_traversal.Yaw(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.length = new_traversal.segmentLength(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.s = new_traversal.Station(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.x = new_traversal.X(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.y = new_traversal.Y(ii);    
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.line = struct; 
end
% update total length of the road
roadData.OpenDRIVE.road{1}.Attributes.length = new_traversal.Station(end);

%% write the output file
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roadData);
myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
% Write the XODR structure to an XML formatted file
struct2xml(ODRStruct,myFilename)
% Move the output file so that it has an XODR file extension
movefile([myFilename '.xml'],[myFilename '.xodr'])
% output file name
fileName = myFilename ;
end