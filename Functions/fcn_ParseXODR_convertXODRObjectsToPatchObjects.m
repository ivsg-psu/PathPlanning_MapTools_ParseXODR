function objectPatches = fcn_ParseXODR_convertXODRObjectsToPatchObjects(ODRStruct,maxPtSpacing)
%% fcn_ParseXODR_convertXODRObjectsToPatchObjects
% A function to export XODR descriptions of objects into an array of patch
% structures
%
% FORMAT:
%
%       objectPatches = fcn_ParseXODR_convertXODRObjectsToPatchObjects(ODRStruct,maxPtSpacing)
%
% INPUTS:
%
%       ODRStruct: a nested structure containing the XDOR map elements
%       maxPtSpacing: a scalar parameter defining the maximum gap between
%         points on the produced boundaries of the patch objects
%
% OUTPUTS:
%
%       objectPatches: an array containing patch structures with the
%         properties of the objects defined in the XODR file
%
% DEPENDENCIES:
%
%      fcn_ParseXODR_extractXYfromSTandGeometries
%
% EXAMPLES:
%
%       See the script: ????????.m for
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

if flag_check_inputs == 1
    if nargin < 2
        error('Incorrect number of input arguments');
    end
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

% Check for out of order segments (by station) and reorder properly
if flag_do_debug
    fprintf(1,'Converting XODR objects to patch objects...\n');
end
% Determine the number of roads in the map
Nroads = length(ODRStruct.OpenDRIVE.road);

% Initialize the number of objects to zero
Nobjects = 0;
% Iterate through all of the roads to determine how many total objects
% there are
for roadInd = 1:Nroads
    if isfield(ODRStruct.OpenDRIVE.road{roadInd},'objects')
        if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects,'object')
            % Determine the number of objects defined in the active road
            Nobjects = length(ODRStruct.OpenDRIVE.road{roadInd}.objects.object);
        end
    end
end
% Create the empty scalar structure for the patches
objectPatches = struct('id',{},'color',{},'primitive',{},'primparams',{},'aabb',{},'pointsX',{},'pointsY',{});
if Nobjects <= 0
    fprintf(1,'No objects to convert in this file, returning empty structure\n');
    objectPatches = [];
    return;
end

% Iterate through all of the roads
for roadInd = 1:Nroads

    % Create a segment table for the road to locate the objects against the
    % geometry segments of different types (lines, arcs, spirals)
    segTable = nan(length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry),1);

    % Also capture the segment type so that it is not necessary to pull it
    % out of the XODR structure on each loop iteration
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

    for objInd = 1:Nobjects(roadInd)
        % Index into the array of objects, which goes in order by road and then
        % by object index
        objArrayInd = sum(Nobjects(1:roadInd-1)) + objInd;
        % Create a copy of the current object portion of the structure to
        % reduce the amount of indexing and structure addressing
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
        segIdx = find(segTable < str2double(currentObject.Attributes.s),1,'last');

        % Get the geometry information for the geometry segment within
        % which the object is located
        geomElement = ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{segIdx};
        % Determine the origin of the object in E,N coordinates
        objSCoord = str2double(currentObject.Attributes.s);
        objTCoord = str2double(currentObject.Attributes.t);
        [xo,yo,ho] = fcn_ParseXODR_extractXYfromSTandGeometries(geomElement,objSCoord,objTCoord);

        % Create a flag to determine whether an outline of the object is
        % determined successfully or whether the object should be defined by
        % the bounding box geometry
        flag_outline_defined = 0;
        % Check to see if there is an XODR element with nested elements:
        % outlines and outline to define the shape of the object
        if isfield(currentObject,'outlines')
            if isfield(currentObject.outlines,'outline')
                % Determine whether the outline is defined by cornerRoad vertices
                if isfield(currentObject.outlines.outline,'cornerRoad')
                    if flag_do_debug
                        fprintf(1,'   Handling object %d using the cornerRoad vertices.\n',objInd)
                    end
                    % Determine the number of vertices
                    Nvertices = length(currentObject.outlines.outline.cornerRoad);
                    % Preallocate vectors to store the s and t coordinates of the
                    % vertices
                    objSCoord = nan(Nvertices,1);
                    objTCoord = nan(Nvertices,1);
                    % Iterate through the vertices and fill the vectors from the XODR
                    % file
                    for vertexInd = 1:Nvertices
                        % Extract the coordinates of the object vertices in (s,t) coordinates
                        objSCoord(vertexInd) = str2double(currentObject.outlines.outline.cornerRoad{vertexInd}.Attributes.s);
                        objTCoord(vertexInd) = str2double(currentObject.outlines.outline.cornerRoad{vertexInd}.Attributes.t);
                    end
                    % Convert the vertex coordinates to (E,N) space
                    [xPts,yPts] = fcn_ParseXODR_extractXYfromSTandGeometries(geomElement,objSCoord,objTCoord);
                    % Add the vertex coordinates to the patch object
                    objectPatches(objArrayInd).pointsX = xPts;
                    objectPatches(objArrayInd).pointsY = yPts;
                    % Set the flag to confirm that an outline has been extracted
                    flag_outline_defined = 1;
                elseif isfield(currentObject.outlines.outline,'cornerLocal')
                    if flag_do_debug
                        fprintf(1,'   Handling object %d using the cornerLocal vertices.\n',objInd)
                    end
                    Nvertices = length(currentObject.outlines.outline.cornerLocal);
                    % Preallocate vectors to store the u and v coordinates of the
                    % vertices
                    objUCoord = nan(Nvertices,1);
                    objVCoord = nan(Nvertices,1);
                    % Extract the heading of the object coordinate u-axis relative to
                    % the E,N coordinate system
                    objUVheading = str2double(currentObject.Attributes.hdg) + ho;
                    % Iterate through the vertices and fill the vectors from the XODR
                    % file
                    for vertexInd = 1:Nvertices
                        % Extract the coordinates of the object vertices in (u,v) coordinates
                        objUCoord(vertexInd) = str2double(currentObject.outlines.outline.cornerLocal{vertexInd}.Attributes.u);
                        objVCoord(vertexInd) = str2double(currentObject.outlines.outline.cornerLocal{vertexInd}.Attributes.v);
                    end
                    % Convert the vertex coordinates to projected space
                    xPts = objUCoord*cos(objUVheading) - objVCoord*sin(objUVheading) + xo;
                    yPts = objUCoord*sin(objUVheading) + objVCoord*cos(objUVheading) + yo;
                    % Add the vertex coordinates to the patch object
                    objectPatches(objArrayInd).pointsX = xPts;
                    objectPatches(objArrayInd).pointsY = yPts;
                    % Set the flag to confirm that an outline has been extracted
                    flag_outline_defined = 1;
                else
                    if flag_do_debug
                        fprintf(1,'   Object %d has outlines and outline elements, but no cornerRoad or cornerLocal elements defined\n',objInd);
                    end
                end
            else
                if flag_do_debug
                    fprintf(1,'   Object %d has an outlines element, but no outline elements defined\n',objInd);
                end
            end
        end
        if ~flag_outline_defined
            if isfield(currentObject.Attributes,'radius')
                if flag_do_debug
                    fprintf(1,'   Handling object %d using the radius bounding box.\n',objInd);
                end
                % Obtain the radius of the object bounding box
                objRadius = str2double(currentObject.Attributes.radius);
                % Define a series of angles over which to create bounding points
                objAngles = (0:maxPtSpacing/objRadius:2*pi)';
                % Calculate and write the points into the the object structure
                objectPatches(objArrayInd).pointsX = objRadius*cos(objAngles)+xo;
                objectPatches(objArrayInd).pointsY = objRadius*sin(objAngles)+yo;
            elseif isfield(currentObject.Attributes,'length') && ...
                    isfield(currentObject.Attributes,'width')
                % Extract the heading of the object coordinate u-axis relative to
                % the E,N coordinate system
                objUVheading = str2double(currentObject.Attributes.hdg) + ho;
                % Extract the length and width of the object
                objLength = str2double(currentObject.Attributes.length);
                objWidth = str2double(currentObject.Attributes.width);
                % Create a box in the u,v space that represents the object, taking
                % into account the maximum spacing between adjacent boundary points
                NptsLength = ceil(objLength/maxPtSpacing);
                objUCoord = linspace(-objLength/2,objLength/2,NptsLength)';
                NptsWidth = ceil(objWidth/maxPtSpacing);
                objVCoord = linspace(-objWidth/2,objWidth/2,NptsWidth)';
                % Compose a complete boundary of the object, starting from the
                % (+,+) corner in u,v coordinates. We drop the duplicate corner
                % points from the verticals (the second and fourth sub-vectors in
                % the overall coordinate vectors) to make sure the patch plots
                % properly
                objUCoord = [flip(objUCoord); -objLength/2*ones(NptsWidth-2,1); ...
                    objUCoord; objLength/2*ones(NptsWidth-2,1)];
                objVCoord = [objWidth/2*ones(NptsLength,1); flipud(objVCoord(2:end-1)); ...
                    -objWidth/2*ones(NptsLength,1); objVCoord(2:end-1)];

                % Convert the vertex coordinates to projected space
                xPts = objUCoord*cos(objUVheading) - objVCoord*sin(objUVheading) + xo;
                yPts = objUCoord*sin(objUVheading) + objVCoord*cos(objUVheading) + yo;
                % Add the vertex coordinates to the patch object
                objectPatches(objArrayInd).pointsX = xPts;
                objectPatches(objArrayInd).pointsY = yPts;
                % Communicate that an outline has been extracted
                if flag_do_debug
                    fprintf(1,'   Handling object %d using the length/width bounding box.\n',objInd)
                end
            else
                if flag_do_debug
                    fprintf(1,'   No geometry specified for object %d, leaving unpopulated.\n',objInd);
                end
            end
        end
    end
end
if flag_do_debug
    fprintf(1,'Object conversion process complete.\n');
end
