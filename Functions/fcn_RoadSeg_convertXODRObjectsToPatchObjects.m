function objectPatches = fcn_RoadSeg_convertXODRObjectsToPatchObjects(ODRStruct)

% A function to export XODR descriptions of objects into an array of patch
% structures

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
  % Iterate through all of the objects
  for objInd = 1:Nobjects(roadInd)
    % Grab the object ID, if it exists
    %objArrayInd = objInd
    % Create a flag to determine whether an outline of the object is
    % determined successfully or whether the object should be defined by
    % the bounding box geometry
    flag_outline_defined = 0;
    if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'outlines')
      if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'outline')
        if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'cornerRoad')
          fprintf(1,'   Handling object %d using the cornerRoad vertices.\n',objInd)
          % Extract the coordinates of the object vertices in (s,t) coordinates
          % Convert the vertex coordinates to (E,N) space
          % Add the vertex coordinates to the patch object
          % Set the flag to confirm that an outline has been extracted
          flag_outline_defined = 1;
        elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'cornerLocal')
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
      if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'radius')
        fprintf(1,'   Handling object %d using the radius bounding box.\n',objInd)
        % Obtain the (s,t) coordinates of the center of the object
        % Obtain the radius of the object bounding box
        % Define a series of points with the specified center and radius
        % Write the points into the the object structure
      elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'length') && ...
          isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes,'width')
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
