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
plot(enuData(:,1),enuData(:,2),'.')

% convert from path to traversal
input_traversal = fcn_Path_convertPathToTraversalStructure(enuData);

interval = 10;
new_stations    = (0:interval:input_traversal.Station(end))';
new_traversal = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);
new_traversal.Yaw = real(new_traversal.Yaw);
% calculate the lengths of each line segment 
new_traversal.segmentLength = diff(new_traversal.Station);

% write the new_traversal into open drive struct 
for ii = 1:length(new_traversal.segmentLength)
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.hdg = new_traversal.Yaw(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.length = new_traversal.segmentLength(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.s = new_traversal.Station(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.x = new_traversal.X(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.y = new_traversal.Y(ii);    
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.line = struct; 
end

% for each segment, check the discrepancy between calculated end point, and
% given end point.
% for ii = 1:length(new_traversal.segmentLength)
% eudis(ii) = fcn_checkPointsAlign(new_traversal.X(ii),new_traversal.Y(ii),new_traversal.Yaw(ii),...
%     new_traversal.segmentLength(ii),new_traversal.X(ii+1),new_traversal.Y(ii+1));
% 
% end
% figure();
% plot(eudis,'o',LineWidth=4);
% title('Discrepancy between calculated end point and given end point');



% update total length of the road
roadData.OpenDRIVE.road{1}.Attributes.length = new_traversal.Station(end);

%% write the output file
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roadData);
myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
% Write the XODR structure to an XML formatted file
struct2xml(roadData,myFilename)
% Move the output file so that it has an XODR file extension
movefile([myFilename '.xml'],[myFilename '.xodr'])
% output file name
fileName = myFilename ;




end