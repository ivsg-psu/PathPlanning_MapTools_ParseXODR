function [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromSTandSegment(geomElement,sPts,tPts)
% Wrapper function to call the findXYfromST function with the appropriate
% arguments based on the XODR road geometry element being referenced

% Enumerate some constants for later convenience and code readability
E = 1; N = 2;

% Get the geometry information for the geometry segment within which the
% object is located
p0 = [str2double(geomElement.Attributes.x), str2double(geomElement.Attributes.y)];
h0 = str2double(geomElement.Attributes.hdg);
l0 = str2double(geomElement.Attributes.length);
s0 = str2double(geomElement.Attributes.s);

% Determine the type of road geometry element is being referenced, and call
% the function to determine the X,Y coordinates from the S,T coordinates
% with the proper arguments
if isfield(geomElement,'line')
  [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromST('line',p0(E),p0(N),h0,s0,l0,sPts,tPts);
elseif isfield(geomElement,'arc')
  K0 = str2double(geomElement.arc.Attributes.curvature);
  [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromST('arc',p0(E),p0(N),h0,s0,l0,sPts,tPts,K0);
elseif isfield(geomElement,'spiral')
  K0 = str2double(geomElement.spiral.Attributes.curvStart);
  KF = str2double(geomElement.spiral.Attributes.curvEnd);
  [xPts,yPts,hPts] = fcn_RoadSeg_findXYfromST('spiral',p0(E),p0(N),h0,s0,l0,sPts,tPts,K0,KF);
else
  fprintf(1,'Road segment type not handled by fcn_RoadSeg_findXYfromSTandSegment()\n');
end