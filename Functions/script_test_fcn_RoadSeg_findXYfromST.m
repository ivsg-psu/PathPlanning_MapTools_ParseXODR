% Script to test the plotting of objects from an xODR structure
clear all
close all

% Enumerate some constants for later convenience and code readability
E = 1; N = 2;

% Load an example file with just one arc road segment and some objects
% along the road
ODRStruct = fcn_RoadSeg_parseXODR('/Users/cbeal/Documents/MATLAB/DOT_PlotXODR/Data/workzone_150m_double_curve_barrels.xodr');

% Plot the road segment
fcn_RoadSeg_plotODRRoadGeometry(ODRStruct);

% Get the road segment information (specific to this roadway)
currentRoad = ODRStruct.OpenDRIVE.road;

% Create a segment table
segTable = nan(length(currentRoad.planView.geometry),1);
for i = 1:length(currentRoad.planView.geometry)
  segTable(i,1) = str2double(currentRoad.planView.geometry{i}.Attributes.s);
end


%% Get the object points to be found from the file
objects = currentRoad.objects.object;
Nobj = length(objects);
sPts = nan(Nobj,1);
tPts = nan(Nobj,1);
lObj = nan(Nobj,1);
wObj = nan(Nobj,1);
segIdx = nan(Nobj,1);

for objInd = 1:Nobj
  sPts(objInd) = str2double(objects{objInd}.Attributes.s);
  tPts(objInd) = str2double(objects{objInd}.Attributes.t);
  lObj(objInd) = str2double(objects{objInd}.Attributes.length);
  wObj(objInd) = str2double(objects{objInd}.Attributes.width);
  segIdx(objInd) = find(segTable < sPts(objInd),1,'last');
end

%% Run the function to find the XY points of each of the objects

for objInd = 1:Nobj
  geomElement = currentRoad.planView.geometry{segIdx(objInd)};
  p0 = [str2double(geomElement.Attributes.x), str2double(geomElement.Attributes.y)];
  h0 = str2double(geomElement.Attributes.hdg);
  l0 = str2double(geomElement.Attributes.length);
  s0 = str2double(geomElement.Attributes.s);
  if isfield(geomElement,'arc')
    K0 = str2double(geomElement.arc.Attributes.curvature);
    [xPts,yPts] = fcn_RoadSeg_findXYfromST('arc',p0(E),p0(N),h0,s0,sPts(objInd),tPts(objInd),K0);
  elseif isfield(geomElement,'spiral')
    K0 = str2double(geomElement.spiral.Attributes.curvStart);
    KF = str2double(geomElement.spiral.Attributes.curvEnd);
    [xPts,yPts] = fcn_RoadSeg_findXYfromST('spiral',p0(E),p0(N),h0,s0,sPts(objInd),tPts(objInd),K0,KF);
  end
  objGeom = [xPts-5*lObj(objInd)/2 yPts-5*wObj(objInd)/2 5*lObj(objInd) 5*wObj(objInd)];
  rectangle('Position',objGeom,'curvature',[1 1],'Facecolor',[1 0.4 0])
end