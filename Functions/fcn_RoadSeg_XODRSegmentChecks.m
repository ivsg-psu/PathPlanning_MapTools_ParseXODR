function ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct)
% fcn_RoadSeg_XODRSegmentChecks
% A function to check a structure imported from XODR into MATLAB to make
% sure that segments are in order by station, that beginning and end points
% of segments match up, and that the map bounding values are correct
% Plots a visual representation of the road geometry defined in an XODR
% file
%
% FORMAT:
%
%       ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct))
%
% INPUTS:
%
%      ODRStruct: a nested structure containing the XDOR map elements
%
% OUTPUTS:
%
%      ODRStruct: a nested structure containing the XDOR map elements, with
%         the proper characteristics confirmed
%
% DEPENDENCIES:
%
%      None
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_parsingProcess.m for a
%       full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu

% Revision history:
%     2022_03_20
%     -- wrote the code

flag_do_debug = 1; % Flag to plot the results for debugging
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
  % Are there the right number of inputs?
  if nargin > 1
    error('Incorrect number of input arguments')
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
  fprintf(1,'1) Checking XODR structure for road geometry segment order...\n');
end
% Determine the number of roads in the map
Nroads = length(ODRStruct.OpenDRIVE.road);
% Preallocate a vector to store the number of geometry segments in each
% road
NgeomElems = zeros(Nroads,1);

% Iterate through all of the roads
for roadInd = 1:Nroads
  % Determine the number of geometry segments in the active road
  NgeomElems(roadInd) = length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry);
  % Create a blank vector of segment station start values to fill
  sVals = zeros(NgeomElems(roadInd),1);
  % Iterate through all of the geometry segments
  for geomInd = 1:NgeomElems(roadInd)
    % populate the station start vector
    sVals(geomInd) = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.Attributes.s);
  end
  % Check to see if there are any negative differences between subsequent
  % segments, indicating an out of order segment (by station)
  if any(sign(diff(sVals)) < 0)
    if flag_do_debug
      fprintf(1,'   Warning: XODR file is malformed. Road %s has geometry segments with non-monotonically increasing stations.\n',ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id)
    end
    % Create an index vector in order by starting station
    [~,sortInds] = sort(sVals);
    % Create a temporary copy of the road geometry
    temp = ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry;
    % Iterate through the total number of geometry segments in the active
    % road
    for geomInd = 1:NgeomElems(roadInd)
      % Place the geometry from the temporary copy back into the original
      % cell array of geometry elements, but in order by the sort indices
      ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd} = temp{sortInds(geomInd)};
    end
    if flag_do_debug
      fprintf(1,'   Segments reordered. Checking downstream results recommended.\n');
    end
  end
end
if flag_do_debug
  fprintf(1,'   Road geometry segment order check complete.\n');
end

% Check to see if end points of segments align in location and heading with
% the following segment
headingDiffThreshold = 0.2*pi/180;  % max 0.2 degree heading mismatch allowed
positionDiffThreshold = 0.1;        % max 0.1 meter position mismatch allowed

% Gather the segment geometry data for the "current" segment
xN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{1}.Attributes.x);
yN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{1}.Attributes.y);
lN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{1}.Attributes.length);
hN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{1}.Attributes.hdg);

if flag_do_debug
  fprintf(1,'2) Checking XODR road geometry segments for continuity of start/end point positions and headings...\n');
end
for roadInd = 1:Nroads
  for geomInd = 1:NgeomElems(roadInd)-1
    % Shift the data from the previous "next" variables into the "current"
    % variables
    xC = xN; yC = yN; lC = lN; hC = hN;
    % Gather the segment geometry data for the "next" segment
    xN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd+1}.Attributes.x);
    yN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd+1}.Attributes.y);
    lN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd+1}.Attributes.length);
    hN = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd+1}.Attributes.hdg);
    if isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd},'line')
      % Calculate the segment endpoint location and heading for the current
      % segment
      xF = xC + lC*cos(hC);
      yF = yC + lC*sin(hC);
      hF = hC;
    elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd},'arc')
      KC = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.arc.Attributes.curvature);
      [xF,yF] = fcn_RoadSeg_findXYfromXODRArc(lC,hC,xC,yC,KC);
      hF = hC + KC*lC;
    elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd},'spiral')
      KCstart = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.spiral.Attributes.curvStart);
      KCend = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.spiral.Attributes.curvEnd);
      [xF,yF] = fcn_RoadSeg_findXYfromXODRSpiral(lC,lC,hC,xC,yC,KCstart,KCend);
      %hF = (KCend-KCstart)/lC*lC^2/2 + KCstart*lC + hC;
      hF = (KCend-KCstart)*lC/2 + KCstart*lC + hC;
    else
    end
    % Compare the segment endpoint data to the start data for the next
    % segment
    if abs(xF - xN) > positionDiffThreshold
      if flag_do_debug
        fprintf(1,'   X coordinate of road %s, geometry segment %d, does not match the following segment.\n',...
          ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,geomInd);
      end
    end
    if abs(yF - yN) > positionDiffThreshold
      if flag_do_debug
        fprintf(1,'   Y coordinate of road %s, geometry segment %d, does not match the following segment.\n',...
          ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,geomInd);
      end
    end
    if abs(hF - hN) > headingDiffThreshold
      if flag_do_debug
        fprintf(1,'   Heading of road %s, geometry segment %d, does not match the following segment.\n',...
          ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,geomInd);
      end
    end
  end
end
if flag_do_debug
  fprintf(1,'   Geometry segment consistency check complete.\n');
end

if flag_do_debug
  fprintf(1,'3) Checking ODR bounding box values...\n');
end
% Pull the min and max values for both the East and North directions. If
% the header attribute does not exist, add the bounding box elements to the
% header structure with zeros and output a warning
if isfield(ODRStruct.OpenDRIVE.header.Attributes,'west')
  west = str2double(ODRStruct.OpenDRIVE.header.Attributes.west);
else
  west = 0;
  ODRStruct.OpenDRIVE.header.Attributes.west = num2str(west);
  warning('Non-compliant XODR file, missing west bounding box value in header');
end
if isfield(ODRStruct.OpenDRIVE.header.Attributes,'east')
  east = str2double(ODRStruct.OpenDRIVE.header.Attributes.east);
else
  east = 0;
  ODRStruct.OpenDRIVE.header.Attributes.east = num2str(east);
  warning('Non-compliant XODR file, missing east bounding box value in header');
end
if isfield(ODRStruct.OpenDRIVE.header.Attributes,'south')
  south = str2double(ODRStruct.OpenDRIVE.header.Attributes.south);
else
  south = 0;
  ODRStruct.OpenDRIVE.header.Attributes.south = num2str(south);
  warning('Non-compliant XODR file, missing south bounding box value in header');
end
if isfield(ODRStruct.OpenDRIVE.header.Attributes,'north')
  north = str2double(ODRStruct.OpenDRIVE.header.Attributes.north);
else
  north = 0;
  ODRStruct.OpenDRIVE.header.Attributes.north = num2str(north);
  warning('Non-compliant XODR file, missing north bounding box value in header');
end

for roadInd = 1:Nroads
  for geomInd = 1:NgeomElems(roadInd)
    % Gather the segment geometry data for the "next" segment
    xC = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.Attributes.x);
    yC = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.Attributes.y);
    lC = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.Attributes.length);
    hC = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.Attributes.hdg);
    % Determine whether any of the initial points expand the known bounding
    % box of the map in any of the four cardinal directions
    if xC < west
      west = xC;
    end
    if xC > east
      east = xC;
    end
    if yC < south
      south = yC;
    end
    if yC > north
      north = yC;
    end
    
    if isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd},'line')
      % Calculate the segment endpoint location and heading for the fijnal
      % segment. All other segments will have the endpoint tested as the
      % initial point of the following segment
      %if geomInd == NgeomElems(roadInd)
      xMinMax = xC + lC*cos(hC);
      yMinMax = yC + lC*sin(hC);
      %end
      
    elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd},'arc')
      KC = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.arc.Attributes.curvature);
      
      % x = sin(K0*s + h0)/K0 -> dxds = cos(K0*s + h0) -> zero when
      % pi/2 = K0*s + h0 -> s = (pi/2 - h0)/K0 or s = (3*pi/2 - h0)/K0
      % Similarly, y is at a max or min at pi or 2*pi
      
      % Make sure any headings are bounded between 0 and 2*pi to avoid
      % issues with multiple solutions in the following calcs
      while hC > 2*pi
        hC = hC - 2*pi;
      end
      while hC < 0
        hC = hC + 2*pi;
      end
      % Determine the s values associated with the critical angles in the x
      % and y directions
      candSValuesX = [(pi/2-hC)/KC; (3*pi/2-hC)/KC];
      candSValuesY = [(pi-hC)/KC; (2*pi-hC)/KC];
      % If this is the last road segment, test the end point in addition.
      % The rest of the end points will get tested as the initial points of
      % the next geometry segment.
      if geomInd == NgeomElems(roadInd)
        candSValuesX = [candSValuesX; lC];
        candSValuesY = [candSValuesY; lC];
      end
      % Find the X,Y points associated with the min and max s values
      [xMinMax,~] = fcn_RoadSeg_findXYfromXODRArc(candSValuesX(candSValuesX <= lC & candSValuesX > 0),hC,xC,yC,KC);
      [~,yMinMax] = fcn_RoadSeg_findXYfromXODRArc(candSValuesY(candSValuesY <= lC & candSValuesX > 0),hC,xC,yC,KC);
      
    elseif isfield(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd},'spiral')
      KCstart = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.spiral.Attributes.curvStart);
      KCend = str2double(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{geomInd}.spiral.Attributes.curvEnd);
      % Make sure any headings are bounded between 0 and 2*pi to avoid
      % issues with multiple solutions in the following calcs
      while hC > 2*pi
        hC = hC - 2*pi;
      end
      while hC < 0
        hC = hC + 2*pi;
      end
      
      % The max and min x coordinates will be located at points where
      % cos((KF-K0)/sF*s^2/2 + K0*s + h0) = 0, or where
      % (KF-K0)/sF*s^2/2 + K0*s + h0 = pi/2 or 3*pi/2
      % Similarly, the max and min y coordinates will be located where
      % sin((KF-K0)/sF*s^2/2 + K0*s + h0) = 0, or where
      % (KF-K0)/sF*s^2/2 + K0*s + h0 = pi/2 or 3*pi/2
      
      % Determine the s values associated with the critical angles in the x
      % and y directions
      if KCstart^2 - 4*(KCend-KCstart)/(2*lC)*(hC-pi/2) > 0
        candSValuesX = roots([(KCend-KCstart)/(2*lC) KCstart hC-pi/2]);
      end
      if KCstart^2 - 4*(KCend-KCstart)/(2*lC)*(hC-3*pi/2) > 0
        candSValuesX = [candSValuesX; roots([(KCend-KCstart)/(2*lC) KCstart hC-3*pi/2])];
      end
      if KCstart^2 - 4*(KCend-KCstart)/(2*lC)*(hC-pi) > 0
        candSValuesY = roots([(KCend-KCstart)/(2*lC) KCstart hC-pi]);
      end
      if KCstart^2 - 4*(KCend-KCstart)/(2*lC)*(hC-2*pi) > 0
        candSValuesY = [candSValuesY; roots([(KCend-KCstart)/(2*lC) KCstart hC-2*pi])];
      end
      
      % If this is the last road segment, test the end point in addition.
      % The rest of the end points will get tested as the initial points of
      % the next geometry segment.
      if geomInd == NgeomElems(roadInd)
        candSValuesX = [candSValuesX; lC];
        candSValuesY = [candSValuesY; lC];
      end
      % Find the X,Y points associated with the min and max s values
      if ~isempty(candSValuesX(candSValuesX <= lC & candSValuesX > 0))
        [xMinMax,~] = fcn_RoadSeg_findXYfromXODRSpiral(candSValuesX(candSValuesX <= lC & candSValuesX > 0),lC,hC,xC,yC,KCstart,KCend);
      end
      if ~isempty(candSValuesY(candSValuesY <= lC & candSValuesY > 0))
        [~,yMinMax] = fcn_RoadSeg_findXYfromXODRSpiral(candSValuesY(candSValuesY <= lC & candSValuesY > 0),lC,hC,xC,yC,KCstart,KCend);
      end
    else
      if flag_do_debug
        fprintf(1,'Boundary checks not implemented for polynomial road geometry segments\n');
      end
    end
    % Determine whether the endpoint of the geometry segment expands
    % the known bounding box of the map in any of the four cardinal
    % directions
    if min(xMinMax) < west
      west = min(xMinMax);
    end
    if max(xMinMax) > east
      east = max(xMinMax);
    end
    if min(yMinMax) < south
      south = min(yMinMax);
    end
    if max(yMinMax) > north
      north = max(yMinMax);
    end
  end
end
% Write the bounding box info back to the header substructure
bbTol = 0.001; % m
if abs(str2double(ODRStruct.OpenDRIVE.header.Attributes.east) - east) > bbTol
  if flag_do_debug
    fprintf(1,'   East bounds incorrect. Updating bounding box on east edge.\n');
  end
  ODRStruct.OpenDRIVE.header.Attributes.east = num2str(east);
end
if abs(str2double(ODRStruct.OpenDRIVE.header.Attributes.west) - west) > bbTol
  if flag_do_debug
    fprintf(1,'   West bounds incorrect. Updating bounding box on west edge.\n');
  end
  ODRStruct.OpenDRIVE.header.Attributes.west = num2str(west);
end
if abs(str2double(ODRStruct.OpenDRIVE.header.Attributes.south) - south) > bbTol
  if flag_do_debug
    fprintf(1,'   South bounds incorrect. Updating bounding box on south edge.\n');
  end
  ODRStruct.OpenDRIVE.header.Attributes.south = num2str(south);
end
if abs(str2double(ODRStruct.OpenDRIVE.header.Attributes.north) - north) > bbTol
  if flag_do_debug
    fprintf(1,'   North bounds incorrect. Updating bounding box on north edge.\n');
  end
  ODRStruct.OpenDRIVE.header.Attributes.north = num2str(north);
end
if flag_do_debug
  fprintf(1,'   Bounding box check complete.\n');
end