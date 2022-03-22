function [ODRStruct,fullPath] = fcn_RoadSeg_parseXODR(varargin)

% Make sure that the xml to structure dependency file is available
addpath('./dependencies/xml2struct/')
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