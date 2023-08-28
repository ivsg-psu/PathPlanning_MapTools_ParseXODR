% Function fcn_parseCenterLine.m 
% This function is used to parse a OpenDRIVE file, in .xodr format, and
% extract the centerline of it. 
% Note: for now it only works for the OpenDRIVE file that's generated using
% <line> geometry elements by small road approximation. 
function [S,X,Y] = fcn_extractCenterLine(filePath)
roadData = fcn_RoadSeg_convertXODRtoMATLABStruct(filePath);

for ii = 1:length(roadData.OpenDRIVE.road{1}.planView.geometry)
    S(ii) = str2num(roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.s);
    X(ii) = str2num(roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.x);
    Y(ii) = str2num(roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.y);
end


S = S';
X = X';
Y = Y'; 

end