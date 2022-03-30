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
      for objInd = 1:Nobjects
        % Check for object repeats
        if isfield(ODRStruct.OpenDRIVE.road{1}.objects.object{objInd},'repeat')
          % Object is actually a repeated object definition and needs to be
          % broken up into individual objects for the MATLAB structure
          
          % Repeated objects are defined first by their s coordinates, so
          % grab the s coordinate of the first instance from the repeat
          % structure (if it exists) or the root object structure
          if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat,'s')
            sStart = str2num(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.s);
          else
            sStart = str2num(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes.s);
          end
          % The interval is defined by the repeat field distance
          sInterval = str2num(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.distance);
          % The end of the s range of the objects is defined by the field
          % length
          sEnd = str2num(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.length);
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
            % CEB: This line doesn't work to transfer multiple cell array
            % objects to other spaces in the cell array
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
      end
    else
      fprintf(1,'Error in XODR file. Objects group exists, but there are no object structures within it.\n');
    end
  end
end


