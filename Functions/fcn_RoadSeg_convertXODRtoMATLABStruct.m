function [ODRStruct,fullPath] = fcn_RoadSeg_convertXODRtoMATLABStruct(varargin)
% fcn_RoadSeg_convertXODRtoMATLABStruct 
% A function to convert XODR descriptions of a road system and associated
% objects into a nested MATLAB structure
%
% FORMAT:
%
%       [ODRStruct,fullPath] = fcn_RoadSeg_convertXODRtoMATLABStruct({fullPath})
%
% INPUTS:
%
%       fullPath: a string containing a complete file path to an XODR map
%
% OUTPUTS:
%
%       ODRStruct: a nested structure containing the XDOR map elements
%       fullPath: a string containing a complete file path to an XODR map
%
%
% DEPENDENCIES:
%
%      xml2struct_fex28518
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_parsingProcess.m for
%       a full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu

% Revision history:
%     2022_03_20
%     -- wrote the code

flag_do_debug = 0; % Flag to plot the results for debugging
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
  st = dbstack; %#ok<*UNRCH>
  fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin > 0
  if ~ischar(varargin{1})
    error('Input argument is not a string.');
  else
    fullPath = varargin{1};
  end
else
  [filename,pathname] = uigetfile('.xodr','Choose an ASAM OpenDrive XML file to parse.');
  fullPath = fullfile(pathname,filename);
end

%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make sure that the xml to structure dependency file is available
addpath('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Functions/dependencies/xml2struct/')
if ~exist('xml2struct_fex28518','file')
  addpath(uigetdir('.','Provide missing path to xml2struct_fex28518'));
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
  % Check for a single lane segment element in the road structure
  NlaneSegs = length(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection);
  if 1 == NlaneSegs
    % If there is only a single geometry element, fix the structure by
    % creating a temporary copy and then adding it back to the structure as
    % the only element in a cell array in the original field.
    temp = ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection;
    ODRStruct.OpenDRIVE.road{roadInd}.lanes = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes,'laneSection');
    ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{1} = temp;
  end
  if isfield(ODRStruct.OpenDRIVE.road{roadInd},'objects')
    if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects,'object')
      Nobjects = length(ODRStruct.OpenDRIVE.road{roadInd}.objects.object);
      if 1 == Nobjects
        % If there is only a single geometry element, fix the structure by
        % creating a temporary copy and then adding it back to the structure as
        % the only element in a cell array in the original field.
        temp = ODRStruct.OpenDRIVE.road{roadInd}.objects.object;
        ODRStruct.OpenDRIVE.road{roadInd}.objects = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.objects,'object');
        ODRStruct.OpenDRIVE.road{roadInd}.objects.object{1} = temp;
      end
      objInd = 1;
      while objInd <= Nobjects
        % Check for object repeats
        if isfield(ODRStruct.OpenDRIVE.road{1}.objects.object{objInd},'repeat')
          % Object is actually a repeated object definition and needs to be
          % broken up into individual objects for the MATLAB structure
          
          % Repeated objects are defined first by their s coordinates, so
          % grab the s coordinate of the first instance from the repeat
          % structure (if it exists) or the root object structure
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat,'s')
            sStart = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.s);
          else
            sStart = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes.s);
          end
          % The interval is defined by the repeat field distance
          sInterval = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.distance);
          % The end of the s range of the objects is defined by the field
          % length
          sEnd = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.length);
          % Define the array of instances of the objects by s coordinate
          sArray = sStart:sInterval:sEnd+sStart;
          % Determine the number of objects defined by the repeat
          Nrepeats = length(sArray);
          % Determine other characteristics that are varying within the
          % repeat structure (may include height, length, radius, t
          % coordinate, width, zOffset)
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'heightStart')
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'heightEnd')
              hArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.heightStart),...
                str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.heightEnd),Nrepeats);
            else
              fprintf(1,'In road %s, object %d, repeat parameter heightStart defined without heightEnd\n',...
                ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
            end
          end
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'lengthStart')
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'lengthEnd')
              lArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.lengthStart),...
                str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.lengthEnd),Nrepeats);
            else
              fprintf(1,'In road %s, object %d, repeat parameter lengthStart defined without lengthEnd\n',...
                ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
            end
          end
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'radiusStart')
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'radiusEnd')
              rArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.radiusStart),...
                str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.radiusEnd),Nrepeats);
            else
              fprintf(1,'In road %s, object %d, repeat parameter radiusStart defined without radiusEnd\n',...
                ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
            end
          end
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'tStart')
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'tEnd')
              tArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.tStart),...
                str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.tEnd),Nrepeats);
            else
              fprintf(1,'In road %s, object %d, repeat parameter tStart defined without tEnd\n',...
                ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
            end
          end
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'widthStart')
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'widthEnd')
              wArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.widthStart),...
                str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.widthEnd),Nrepeats);
            else
              fprintf(1,'In road %s, object %d, repeat parameter widthStart defined without widthEnd\n',...
                ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
            end
          end
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'zOffsetStart')
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'zOffsetEnd')
              zArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.zOffsetStart),...
                str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.zOffsetEnd),Nrepeats);
            else
              fprintf(1,'In road %s, object %d, repeat parameter zOffsetStart defined without zOffsetEnd\n',...
                ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
            end
          end
          
          % Prune the repeat structure off of the original object
          ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd} = ...
            rmfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd},'repeat');
          % Make room for the repeated objects by shifting any following
          % objects further along in the array
          if objInd < Nobjects
            ODRStruct.OpenDRIVE.road{roadInd}.objects.object(objInd+Nrepeats:objInd+Nrepeats+(Nobjects-objInd)-1) = ...
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object(objInd+1:Nobjects);
            % Update the number of objects (repeating includes the original
            % object, so we add the number of repeated objects minus one
            Nobjects = Nobjects + (Nrepeats - 1);
          end
          % Now fill the repeated objects in the array with the properties
          % of the original one, then modify the varying parameters
          for repInd = 1:Nrepeats
            ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1} = ...
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd};
            ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.s = ...
              num2str(sArray(repInd),'%.16e');
            if exist('hArray')
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.height = ...
              num2str(hArray(repInd),'%.16e');
            end
            if exist('lArray')
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.length = ...
              num2str(lArray(repInd),'%.16e');
            end
            if exist('rArray')
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.radius = ...
              num2str(rArray(repInd),'%.16e');
            end
            if exist('tArray')
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.t = ...
              num2str(tArray(repInd),'%.16e');
            end
            if exist('wArray')
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.width = ...
              num2str(wArray(repInd),'%.16e');
            end
            if exist('zArray')
              ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.zOffset = ...
              num2str(zArray(repInd),'%.16e');
            end
          end
        end
        objInd = objInd + 1;
      end
    else
      fprintf(1,'Error in XODR file. Objects group exists, but there are no object structures within it.\n');
    end
  end
end


