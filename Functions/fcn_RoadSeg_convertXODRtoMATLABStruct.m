function [ODRStruct,fullPath] = fcn_RoadSeg_convertXODRtoMATLABStruct(varargin)

% Make sure that the xml to structure dependency file is available
addpath('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Functions/dependencies/xml2struct/')
if ~exist('xml2struct_fex28518','file')
  addpath(uigetdir('.','Provide missing path to xml2struct_fex28518'));
end

% Get a path to the xodr file to be parsed
if nargin > 0
  fullPath = varargin{1};
else
  [filename,pathname] = uigetfile('.xodr','Choose an ASAM OpenDrive XML file to parse.');
  fullPath = fullfile(pathname,filename);
end

% Use the xml2struct utility to create a nested structure of the XODR
% attributes
ODRStruct = xml2struct_fex28518(fullPath);

% Unify the formatting of the MATLAB data structure so that single roads or
% single geometry segments are in cell arrays (of a single element) to be
% consistent with the data structure when there are multiple roads and/or
% multiple geometry elements

% Determine the number of roads in the map
Nroads = length(ODRStruct.OpenDRIVE.road);
% Check for a single road in the file
if 1 == Nroads
    % If the road is a single one, fix the structure by creating a
    % temporary copy and then adding it back to the structure as the only
    % element in a cell array in the original field.
    temp = ODRStruct.OpenDRIVE.road;
    ODRStruct.OpenDRIVE = rmfield(ODRStruct.OpenDRIVE,'road');
    ODRStruct.OpenDRIVE.road{1} = temp;
end
for roadInd = 1:Nroads
  NgeomElems = length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry);
  % Check for a single geometry element in the road structure
  if 1 == NgeomElems
    % If there is only a single geometry element, fix the structure by
    % creating a temporary copy and then adding it back to the structure as
    % the only element in a cell array in the original field.
    temp = ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry;
    ODRStruct.OpenDRIVE.road{roadInd}.planView = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.planView,'geometry');
    ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{1} = temp;
  end
end