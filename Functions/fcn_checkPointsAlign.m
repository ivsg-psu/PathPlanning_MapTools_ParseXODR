function euDis = fcn_checkPointsAlign(x1,y1,hdg,length,x2,y2)
% XODR file describes a line segment by using x1,y1 of the origin, hdg and length of the
% segment.
% This function compares the calculated xf and yf of the end point of the segment, and the given 
% coordinates x2 and y2, and find the discrepancy
% INPUTS:
% x1: x of the origin
% y1: y of the origin
% hdg: heading of the line segment
% length: length of the line segment
% x2: given x of the ending point
% y2: given y of the ending point

% OUTPUTS:
% euDis: euclidian distance of the given ending point, and calculated
% ending point

xf = x1 + length*cos(hdg);
yf = y1 + length*sin(hdg);

p1 = [xf,yf];
p2 = [x2,y2];

euDis = pdist2(p1,p2);




end