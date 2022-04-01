function objectPatches = fcn_RoadSeg_convertXODRObjectsToPatchObjects(ODRStruct,minPtSpacing)
% A function to export XODR descriptions of objects into an array of patch
% structures

% Enumerate some constants for later convenience and code readability
E = 1; N = 2;

% Set a flag to enable some debugging functionality
flag_do_debug = 1;

% Check for out of order segments (by station) and reorder properly
if flag_do_debug
  fprintf(1,'Converting XODR objects to patch objects...\n');
end
% Determine the number of roads in the map
Nroads = length(ODRStruct.OpenDRIVE.road);

% Iterate through all of the roads
for roadInd = 1:Nroads
  % Determine the number of objects defined in the active road
  Nobjects = length(ODRStruct.OpenDRIVE.road{roadInd}.objects.object);
end
% Create the empty scalar structure for the patches
objectPatches = struct('id',{},'color',{},'primitive',{},'primparams',{},'aabb',{},'pointsX',{},'pointsY',{});

% Iterate through all of the roads
for roadInd = 1:Nroads
  
  % Create a segment table for the road to locate the objects against the
  % geometry segments of different types (lines, arcs, spirals)
  segTable = nan(length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry),1);
  segType = cell(length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry),1);
  for i = 1:length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry)
    segTable(i,1) = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{i}.Attributes.s);
    if isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{i},'line')
      segType{i} = 'line';
    elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{i},'arc')
      segType{i} = 'arc';
    elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{i},'spiral')
      segType{i} = 'spiral';
    else
      segType{i} = 'undef';
    end
  end

  % Iterate through all of the objects
  for objInd = 1:Nobjects(roadInd)
    % Index into the array of objects, which goes in order by road and then
    % by object index
    objArrayInd = sum(Nobjects(1:roadInd-1)) + objInd;
    % Create a copy of the current object to reduce the amount of indexing
    % and structure addressing
    currentObject = ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd};
    % Grab the object ID, if it exists. Otherwise, just use the index
    % within this XODR map file
    if isfield(currentObject.Attributes,'id')
      objectPatches(objArrayInd).id = str2double(currentObject.Attributes.id);
    else
      objectPatches(objArrayInd).id = objArrayInd;
    end
    % Assign all objects to be blaze orange (for now)
    objectPatches(objArrayInd).color = [1 0.4 0];
    % Determine within which road geometry segment the object is located
    segIdx = find(segTable < str2num(currentObject.Attributes.s),1,'last');
    % Create a flag to determine whether an outline of the object is
    % determined successfully or whether the object should be defined by
    % the bounding box geometry
    flag_outline_defined = 0;
    if isfield(currentObject.Attributes,'outlines')
      if isfield(currentObject.Attributes,'outline')
        if isfield(currentObject.Attributes,'cornerRoad')
          fprintf(1,'   Handling object %d using the cornerRoad vertices.\n',objInd)
          % Extract the coordinates of the object vertices in (s,t) coordinates
          % Convert the vertex coordinates to (E,N) space
          % Add the vertex coordinates to the patch object
          % Set the flag to confirm that an outline has been extracted
          flag_outline_defined = 1;
        elseif isfield(currentObject.Attributes,'cornerLocal')
          fprintf(1,'   Handling object %d using the cornerLocal vertices.\n',objInd)
          % Extract the coordinates of the object vertices in (u,v)
          % coordinates
          % Determine the (E,N) position and heading of the (u,v) origin
          % Convert the vertex coordinates to (E,N) space
          % Add the vertex coordinates to the patch object
          % Set the flag to confirm that an outline has been extracted
          flag_outline_defined = 1;
        else
          fprintf(1,'   Object %d has outlines and outline elements, but no cornerRoad or cornerLocal elements defined\n',objInd);
        end
      else
        fprintf(1,'   Object %d has an outlines element, but no outline elements defined\n',objInd);
      end
    end
    if ~flag_outline_defined
      if isfield(currentObject.Attributes,'radius')
        fprintf(1,'   Handling object %d using the radius bounding box.\n',objInd)
        % Obtain the (s,t) coordinates of the center of the object
        objSCoord = str2double(currentObject.Attributes.s);
        objTCoord = str2double(currentObject.Attributes.t);
        % Get the geometry information for the geometry segment within
        % which the object is located
        geomElement = ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{segIdx};
        p0 = [str2double(geomElement.Attributes.x), str2double(geomElement.Attributes.y)];
        h0 = str2double(geomElement.Attributes.hdg);
        l0 = str2double(geomElement.Attributes.length);
        s0 = str2double(geomElement.Attributes.s);
        % Determine the center point of the object in E,N coordinates
        if strcmp(segType{segIdx},'line')
          [xc,yc] = fcn_RoadSeg_findXYfromST('line',p0(E),p0(N),h0,s0,l0,objSCoord,objTCoord);
        elseif strcmp(segType{segIdx},'arc')
          K0 = str2double(geomElement.arc.Attributes.curvature);
          [xc,yc] = fcn_RoadSeg_findXYfromST('arc',p0(E),p0(N),h0,s0,l0,objSCoord,objTCoord,K0);
        elseif strcmp(segType{segIdx},'spiral')
          K0 = str2double(geomElement.spiral.Attributes.curvStart);
          KF = str2double(geomElement.spiral.Attributes.curvEnd);
          [xc,yc] = fcn_RoadSeg_findXYfromST('spiral',p0(E),p0(N),h0,s0,l0,objSCoord,objTCoord,K0,KF);
        end
        % Obtain the radius of the object bounding box
        objRadius = str2double(currentObject.Attributes.radius);
        % Define a series of angles over which to create bounding points
        objAngles = (0:minPtSpacing/objRadius:2*pi)';
        % Calculate and write the points into the the object structure
        objectPatches(objArrayInd).pointsX = objRadius*cos(objAngles)+xc;
        objectPatches(objArrayInd).pointsY = objRadius*sin(objAngles)+yc;
      elseif isfield(currentObject.Attributes,'length') && ...
          isfield(currentObject.Attributes,'width')
        fprintf(1,'   Handling object %d using the length/width bounding box.\n',objInd)
      else
        fprintf(1,'   No geometry specified for object %d, leaving unpopulated.\n',objInd);
      end
    end
  end
end
if flag_do_debug
  fprintf(1,'Object conversion process complete.\n');
end
