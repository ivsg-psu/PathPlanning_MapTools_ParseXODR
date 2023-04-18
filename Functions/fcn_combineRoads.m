%function fcn_combineRoads(predecessorRoad,successorRoad)
% This function combines two roads defined by independent xodr files.
% INPUTS:
% successorRoad: a file that defines the successor road, in .xodr
% predecessorRoad: a file that defines the predecessor road, in .xodr
% To combine two roads, the following elements have to bee updated:
% 1. the "id" fields in <road>
% 2. a level 3 <link> under <road> to define the successor/predecessor
% roads
% 3. a level 7 <link> under <lane> to define the successor/predecessor
% lanes 
% 4. <geometry> attributes of the successor road 
% 5. update the bounding box 

% Author: Wushuang
% Revision history:
% 20230408 first write of the code
% 20230412 added comments

testCase = 1;
if 1 == testCase % one lane, one way,no shoulder road
predecessorRoad = 'testXODR_23-03-21T15-02-19_100mLine_oneLane_noShoulder.xodr';
successorRoad = 'testXODR_23-03-21T15-02-19_100mLine_oneLane_noShoulder.xodr';

elseif 2 == testCase % two lane, two way with shoulder road
predecessorRoad = 'testXODR_23-03-21T15-02-19_100mLine.xodr';
successorRoad = 'testXODR_23-03-21T15-02-19_100mLine.xodr';

end

predecessorStruct = fcn_RoadSeg_convertXODRtoMATLABStruct(predecessorRoad);
successorStruct = fcn_RoadSeg_convertXODRtoMATLABStruct(successorRoad);



%% update the id in <road> for successor road. (not needed for predecessor)
successorStruct.OpenDRIVE.road{1}.Attributes.id = str2double(successorStruct.OpenDRIVE.road{1}.Attributes.id) + 1;
successorStruct.OpenDRIVE.road{1}.Attributes.id = num2str(successorStruct.OpenDRIVE.road{1}.Attributes.id);

%% update the <link> under <road> in predecessor road.
predecessorStruct.OpenDRIVE.road{1}.link.successor.Attributes.elementType = 'road';
predecessorStruct.OpenDRIVE.road{1}.link.successor.Attributes.elementId = ...
    successorStruct.OpenDRIVE.road{1}.Attributes.id;
predecessorStruct.OpenDRIVE.road{1}.link.successor.Attributes.contactPoint = 'start';

%% update the <link> under <road> in successor road.
successorStruct.OpenDRIVE.road{1}.link.predecessor.Attributes.elementType = 'road';
successorStruct.OpenDRIVE.road{1}.link.predecessor.Attributes.elementId = ...
    predecessorStruct.OpenDRIVE.road{1}.Attributes.id;
successorStruct.OpenDRIVE.road{1}.link.predecessor.Attributes.contactPoint = 'end';

%% update the <link> under <lane> in predecessor road.
predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.link.successor.Attributes.id = '-1';

%% update the <link> under <lane> in successor road.
successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.link.predecessor.Attributes.id = '-1';

%% update <geometry> attributes in the predecessor road

geomFieldNames = fieldnames(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1})
%       geomtype: a string containing 'line', 'arc', or 'spiral' to denote
%         the type of path and therefore the appropriate computation
geomType = geomFieldNames{1};
%       x0: a scalar parameter denoting the x-coordinate of the path at
%         the s = 0 point
x0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.x)
%       y0: a scalar parameter denoting the y-coordinate of the path at
%         the s = 0 point
y0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.y)
%       h0: a scalar parameter denoting the heading of the path at the
%         s = 0 point
h0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.hdg)
%       s0: a scalar parameter denoting the start point of the path in s
%         coordinates
s0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.s) % is 0 if this is a new road
%       l0: a scalar parameter denoting the maximum extent of the path, in
%         station coordinates, relative to s = 0
l0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.length) % the length of the road 
%       s: a vector of station coordinates along the path at which to
%         compute the x,y coordinates. s is NOT assumed to start at zero.
s = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.length)  
%       t: a vector of station coordinates perpendicular to the path at
%         which to compute the x,y coordinates.
t = 0;                       % zero since we want the coordinates at the centerline of the path

if strcmp(geomType,'line')
    k0 = 0;                  % no curvature for a line
    [sucGeoX,sucGeoY,sucGeoH] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,k0)
elseif strcmp(geomType,'arc')
    k0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.arc.Attributes.curvature);
    [sucGeoX,sucGeoY,sucGeoH] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,k0)
elseif strcmp(geomType,'spiral')
    k0 = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.spiral.Attributes.curvStart);
    kf = str2double(predecessorStruct.OpenDRIVE.road{1}.planView.geometry{1}.spiral.Attributes.curvEnd);
    [sucGeoX,sucGeoY,sucGeoH] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,k0,kf)
end

% write the geometry attributes to successor road
successorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.x = sucGeoX;
successorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.y = sucGeoY;
successorStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.hdg = sucGeoH;

%% add the successor road to predecessor one
predecessorStruct.OpenDRIVE.road{2} = successorStruct.OpenDRIVE.road{1};
%% plot
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(predecessorStruct);
% Now check all of the work by calling the plotting utility on the
% structure created to this point
figure(1)
clf
hold on
grid on
axis tight
axis equal
xlabel('East (m)')
ylabel('North (m)')
% Plot the realistic looking road on the figure
fcn_RoadSeg_plotRealisticRoad(ODRStruct,0.5,1);

% Use the axis bounding box to find the extents of the data (this can be
% replaced by more specific code since this could theoretically miss a
% point on a curve in between plot points that has a slightly larger value
% in one of the cardinal directions)
%% update bounding box 
axis tight
axlims = axis;
ODRStruct.OpenDRIVE.header.Attributes.west = num2str(axlims(1));
ODRStruct.OpenDRIVE.header.Attributes.east = num2str(axlims(2));
ODRStruct.OpenDRIVE.header.Attributes.south = num2str(axlims(3));
ODRStruct.OpenDRIVE.header.Attributes.north = num2str(axlims(4));
% Restore the proportionality of the axes
axis equal;
%% export the result file
myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
% Write the XODR structure to an XML formatted file
struct2xml(ODRStruct,myFilename)
% Move the output file so that it has an XODR file extension
movefile([myFilename '.xml'],[myFilename '.xodr'])



%end