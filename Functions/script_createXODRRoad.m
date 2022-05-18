% Script to test the process of creating an OpenDRIVE file via command line
% interface
clearvars

% Start a figure in order to plot the geometry as the user enters it
figure(1)
clf
hold on
grid on
axis equal
xlabel('East (m)')
ylabel('North (m)')

% Add the path
addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR'));

% Start an XODR structure to capture the road geometry that is entered
%ODRStruct = struct;

ODRStruct.OpenDRIVE.header.Attributes.revMajor = '1';
ODRStruct.OpenDRIVE.header.Attributes.revMinor = '7';
ODRStruct.OpenDRIVE.header.Attributes.date = datestr(now,'yyyy-mm-ddTHH:MM:SS');
ODRStruct.OpenDRIVE.header.Attributes.vendor = 'PSU-IVSG';

ODRStruct.OpenDRIVE.road{1}.Attributes.s = '0';
ODRStruct.OpenDRIVE.road{1}.Attributes.id = '1';
ODRStruct.OpenDRIVE.road{1}.planView = struct;
ODRStruct.OpenDRIVE.road{1}.planView.geometry = cell(1);


%startCoords = inputdlg({'E Coordinate (m)','N Coordinate (m)','Heading (rad)'},...
%    'Enter Road Start Coordinates',[1 20; 1 20; 1 20],{'0'; '0'; '0'});
%uiwait(startCoords)
startCoords = [0, 0, 0];

% Create a variable to track the cumulative length of the road as entered
% by the user
roadLength = 0;

% Create variables to keep track of the end of each segment (x,y,heading)
segEndX = startCoords(1);
segEndY = startCoords(2);
segEndH = startCoords(3);

% Continue to add road geometry segments until the user indicates that they
% are done adding geometry, adding a new segment each time
doneFlag = 0;
segmentCounter = 0;
while ~doneFlag
  % Increment the segment counter
  segmentCounter = segmentCounter + 1;
  
  % Reset the segTypeChar variable to get another segment type from the
  % user
  segTypeChar = 'n';
  while ~strcmp(segTypeChar,'l') && ~strcmp(segTypeChar,'a') && ~strcmp(segTypeChar,'s')
    segTypeChar = lower(input('Enter line/arc/spiral segment type [l/a/s]: ','s'));
  end
  
  % Request a segment length from the user
  segLength = '';
  while ~isnumeric(segLength)
    segLength = input('Enter road length along reference line, in meters: ');
  end
  
  % If the segment type is a line segment, all of the required
  % information is already available, so write it into the structure
  if segTypeChar == 'l'
    % Create the line field (no additional properties are necessary)
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.line = struct;
    % Copy over the length of the segment into the structure
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.length = num2str(segLength);
    % Use the end position and heading of the last segment as the start
    % of this segment
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.s = num2str(roadLength);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.x = num2str(segEndX);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.y = num2str(segEndY);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.hdg = num2str(segEndH);
    % Plot the resulting segment
    plot([segEndX segEndX + segLength*cos(segEndH)],...
      [segEndY segEndY + segLength*sin(segEndH)],'o-','linewidth',1);
    % Calculate the end conditions of the current segment
    segEndX = segEndX + segLength*cos(segEndH);
    segEndY = segEndY + segLength*sin(segEndH);
    %segEndH = segEndH; % unnecessary, but here for completeness
  elseif strcmp(segTypeChar,'a')
    % Request the segment curvature parameter from the user
    segCurvature = '';
    while ~isnumeric(segCurvature)
      segCurvature = input('Enter arc curvature, in 1/meters: ');
    end
    % Create the arc field
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.arc.Attributes.curvature = ...
      num2str(segCurvature);
    % Copy over the length of the segment into the structure
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.length = num2str(segLength);
    % Use the end position and heading of the last segment as the start
    % of this segment
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.s = num2str(roadLength);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.x = num2str(segEndX);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.y = num2str(segEndY);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.hdg = num2str(segEndH);
    % Calculate points along the arc, including the start and end
    s = (roadLength:0.1:roadLength+segLength)';
    % Make sure that the last point is indeed the station coordinate of
    % the end of the arc (due to fractional segments)
    if s(end) ~= roadLength+segLength
      s = [s; roadLength+segLength];
    end
    % Get the x,y coordinates at the centerline of the road
    t = zeros(size(s));
    [x,y,h] = fcn_RoadSeg_findXYfromST('arc',segEndX,segEndY,...
      segEndH,roadLength,segLength,s,t,segCurvature);
    % Plot the resulting segment
    plot(x,y,'o-','linewidth',1);
    % Calculate the end conditions of the current segment
    segEndX = x(end);
    segEndY = y(end);
    segEndH = h(end);
  elseif strcmp(segTypeChar,'s')
    % Request a segment length from the user
    segCurvStart = '';
    while ~isnumeric(segCurvStart)
      segCurvStart = input('Enter spiral curvature at the start, in 1/meters: ');
    end
    segCurvEnd = '';
    while ~isnumeric(segCurvEnd)
      segCurvEnd = input('Enter spiral curvature at the end, in 1/meters: ');
    end
    % Create the spiral fields
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.spiral.Attributes.curvStart = num2str(segCurvStart);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.spiral.Attributes.curvEnd = num2str(segCurvEnd);
    % Copy over the length of the segment into the structure
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.length = num2str(segLength);
    % Use the end position and heading of the last segment as the start
    % of this segment
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.s = num2str(roadLength);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.x = num2str(segEndX);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.y = num2str(segEndY);
    ODRStruct.OpenDRIVE.road{1}.planView.geometry{segmentCounter}.Attributes.hdg = num2str(segEndH);
    % Calculate points along the arc, including the start and end
    s = (roadLength:0.1:roadLength+segLength)';
    if s(end) ~= roadLength+segLength
      s = [s; roadLength+segLength];
    end
    t = zeros(size(s));
    [x,y,h] = fcn_RoadSeg_findXYfromST('spiral',segEndX,segEndY,...
      segEndH,roadLength,segLength,s,t,segCurvStart,segCurvEnd);
    % Plot the resulting segment
    plot(x,y,'o-','linewidth',1);
    % Calculate the end conditions of the current segment
    segEndX = x(end);
    segEndY = y(end);
    segEndH = h(end);
  end
  
  % Add the segment length to the total road length
  roadLength = roadLength + segLength;
  
  doneString = input('Enter additional road geometry segments? Y/N [N]:','s');
  if ~strcmp(doneString,'Y') && ~strcmp(doneString,'y')
    doneFlag = 1;
  end
end
% Record the final road centerline length
ODRStruct.OpenDRIVE.road{1}.Attributes.length = num2str(roadLength);

% Query whether the user would like to enter any lane offsets in the file
doneString = input('Are there any lane offset sections? Y/N [N]: ','s');
if strcmp(doneString,'Y') || strcmp(doneString,'y')
  doneFlag = 0;
else
  doneFlag = 1;
end
% Initialize a lane offset section counter
laneOffsetCounter = 0;
while ~doneFlag
  % Increment the lane offset counter
  laneOffsetCounter = laneOffsetCounter + 1;
  
  % Request the offset start station parameter from the user
  laneOffsetStart = '';
  while ~isnumeric(laneOffsetStart)
    laneOffsetStart = input('Enter lane offset start station, in meters: ');
  end
  ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{laneOffsetCounter}.Attributes.s = ...
    num2str(laneOffsetStart);
  
  % Request the offset cubic parameters (a, b, c, d) from the user. A
  % natural extension of this would be to include a secondary set of fields
  % that would calculate a, b, c, and d from a lane shift in s and t
  % coordinates assuming dt/ds = 0 at each end point
  offsetParams = inputdlg({'a','b','c','d'},'Enter Lane Offset Parameters',...
    [1 20; 1 20; 1 20; 1 20],{'0'; '0'; '0'; '0'});
  ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{laneOffsetCounter}.Attributes.a = offsetParams{1};
  ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{laneOffsetCounter}.Attributes.b = offsetParams{2};
  ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{laneOffsetCounter}.Attributes.c = offsetParams{3};
  ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{laneOffsetCounter}.Attributes.d = offsetParams{4};
  
  % Check to see if the user would like to add additional lane offset
  % sections
  doneString = input('Enter additional lane offset sections? Y/N [N]: ','s');
  if ~strcmp(doneString,'Y') && ~strcmp(doneString,'y')
    doneFlag = 1;
  end
end

% Reset the done flag
doneFlag = 0;
% Initialize a lane section counter
laneSectionCounter = 0;
while ~doneFlag
  % Increment the lane section counter
  laneSectionCounter = laneSectionCounter + 1;
  
  % Request the offset start station parameter from the user
  laneSectionStart = '';
  while ~isnumeric(laneSectionStart)
    laneSectionStart = input('Enter lane section start station, in meters: ');
  end
  ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.Attributes.s = num2str(laneSectionStart);
  
  numLeftLanes = '';
  while ~isnumeric(numLeftLanes)
    numLeftLanes = input('Enter the number of left lanes in this section: ');
  end
  for leftLaneInd = 1:numLeftLanes
    % Request the lane width cubic parameters (a, b, c, d) from the user. A
    % natural extension of this would be to include a secondary set of fields
    % that would calculate a, b, c, and d from a lane shift in s and t
    % coordinates assuming dt/ds = 0 at each end point
    laneParams = inputdlg({'a','b','c','d','type'},['Enter Left Lane ' num2str(leftLaneInd) ' Parameters'],...
      [1 20; 1 20; 1 20; 1 20; 1 20],{'0'; '0'; '0'; '0'; 'driving'});
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.left.lane{leftLaneInd}.Attributes.id = num2str(leftLaneInd);
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.left.lane{leftLaneInd}.width.Attributes.a = laneParams{1};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.left.lane{leftLaneInd}.width.Attributes.b = laneParams{2};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.left.lane{leftLaneInd}.width.Attributes.c = laneParams{3};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.left.lane{leftLaneInd}.width.Attributes.d = laneParams{4};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.left.lane{leftLaneInd}.width.Attributes.sOffset = '0';
  end
  
  ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.center.lane.Attributes.id = '0';
  ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.center.lane.Attributes.level = 'false';
  ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.center.lane.Attributes.type = 'none';
  
  numRightLanes = '';
  while ~isnumeric(numRightLanes)
    numRightLanes = input('Enter the number of right lanes in this section: ');
  end
  for rightLaneInd = 1:numRightLanes
    % Request the lane width cubic parameters (a, b, c, d) from the user. A
    % natural extension of this would be to include a secondary set of fields
    % that would calculate a, b, c, and d from a lane shift in s and t
    % coordinates assuming dt/ds = 0 at each end point
    laneParams = inputdlg({'a','b','c','d','type'},['Enter Right Lane ' num2str(rightLaneInd) ' Parameters'],...
      [1 20; 1 20; 1 20; 1 20; 1 20],{'0'; '0'; '0'; '0'; 'driving'});
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.Attributes.id = num2str(-rightLaneInd);
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.width.Attributes.a = laneParams{1};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.width.Attributes.b = laneParams{2};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.width.Attributes.c = laneParams{3};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.width.Attributes.d = laneParams{4};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.width.Attributes.type = laneParams{5};
    ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{laneSectionCounter}.right.lane{rightLaneInd}.width.Attributes.sOffset = '0';
  end
  
  % Check to see if the user would like to add additional lane sections
  doneString = input('Enter additional lane sections? Y/N [N]:','s');
  if ~strcmp(doneString,'Y') && ~strcmp(doneString,'y')
    doneFlag = 1;
  end
end


%% 
figure(2)
clf
hold on
grid on
axis tight
axis equal
xlabel('East (m)')
ylabel('North (m)')
% Plot the realistic looking road on the figure
fcn_RoadSeg_plotRealisticRoad(ODRStruct.OpenDRIVE.road{1},0.5,2);
% Plot the lane section dividers

% Add lane numbers for each section

% % Query the user for the predecessors for each lane
% for laneSectionInd = 1:laneSectionCounter
%   fprintf(
% end

% Use the axis bounding box to find the extents of the data (this can be
% replaced by more specific code since this could theoretically miss a
% point on a curve in between plot points that has a slightly larger value
% in one of the cardinal directions)
axis tight
axlims = axis;
ODRStruct.OpenDRIVE.header.Attributes.west = num2str(axlims(1));
ODRStruct.OpenDRIVE.header.Attributes.east = num2str(axlims(2));
ODRStruct.OpenDRIVE.header.Attributes.south = num2str(axlims(3));
ODRStruct.OpenDRIVE.header.Attributes.north = num2str(axlims(4));
% Restore the proportionality of the axes
axis equal

% Write the XODR structure to an XML formatted file
myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
struct2xml(ODRStruct,myFilename)
movefile([myFilename '.xml'],[myFilename '.xodr'])