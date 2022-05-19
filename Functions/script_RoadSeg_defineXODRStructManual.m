% Script to demonstrate how to programatically fill an XODR structure in
% MATLAB and then have it written to an XODR file
clearvars

% Set this flag to write to an XODR file when done, leave clear to end the
% script before writing to a file (e.g. while building the geometry)
flag_write_XODR_file = 0;

% Start with the OpenDRIVE header. Make sure to fill out the following
% attributes: Date, OpenDRIVE Major Revision Number, OpenDRIVE Minor
% Revision Number, Vendor Name. You can also include the version of the
% file in case it is revised.
ODRStruct.OpenDRIVE.header.Attributes.revMajor = '1';
ODRStruct.OpenDRIVE.header.Attributes.revMinor = '7';
ODRStruct.OpenDRIVE.header.Attributes.date = datestr(now,'yyyy-mm-ddTHH:MM:SS');
ODRStruct.OpenDRIVE.header.Attributes.vendor = 'PSU-IVSG';
ODRStruct.OpenDRIVE.header.Attributes.version = '1';
% The header also needs to have the bounding box attributes (West, East,
% South, North) filled, but it is easier to do this after all of the
% geometry is defined as it is a bit tricky to find the extremes, taking
% into account all of the reference line geometry plus any lane widths
% and/or objects that lie along or outside of the roadway.


% Next, define the basic attributes of the first road to be defined in this
% OpenDRIVE XODR file. Give the road ID, junction number (-1 if there is no
% junction), name of the road, and driving rule
ODRStruct.OpenDRIVE.road{1}.Attributes.id = '1';
ODRStruct.OpenDRIVE.road{1}.Attributes.junction = '-1';
ODRStruct.OpenDRIVE.road{1}.Attributes.name = 'PSU Example Road';
ODRStruct.OpenDRIVE.road{1}.Attributes.rule = 'RHT';
% The total length of the road is also included as an attribute, but is
% easier to add once the entire road reference line is defined.


% Next, define the road reference line. Everything goes under the
% "planView" element, and can be of type line, arc, or spiral. OpenDRIVE
% also supports cubic polynomials and parametric cubic polynomials, but
% these are not used by highway designers and are thus not supported by the
% rest of the PSU OpenDRIVE-MATLAB tool suite. % Examples for each of the
% three types are given here, assuming that we are going to create the
% first road, though this can be followed by additional road definitions.
% Create the empty structure for the planView, to be filled subsequently
ODRStruct.OpenDRIVE.road{1}.planView = struct;
% Create the first geometry element as a cell array element so that there
% can be multiple elements as needed. If there is only one, it should still
% be treated as a one element cell array for consistency and so that code
% the uses brace indexing of the cell array will continue to work
ODRStruct.OpenDRIVE.road{1}.planView.geometry = cell(1);
% Enter the path length of the geometry segment. All attributes are entered
% as strings, even if numeric in value.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.length = '100';
% Enter the starting coordinates and heading for the geometry element. If
% there are multiple geometry elements, these should all match the end of
% the previous segment. fcn_RoadSeg_findXYfromST() may be used to determine
% the values of the x,y and heading coordinates at the end of a element if
% the station of the end of the element and zero t-coordinate are provided
% as arguments (see definition of second element below). In this example,
% we'll start the first element at (E,N) = (0,0), with a heading of zero
% and a station of zero as well.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.s = '0';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.x = '0';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.y = '0';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.Attributes.hdg = '0';
% Once the basic geometry element parameters are defined, specify the
% particular parameters of the element. For a line, there are no additional
% parameters, but the field needs to exist in the XODR structure. For an
% arc, a single curvature parameter needs to be defined, and for a spiral,
% the start and end curvature values are the parameters.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{1}.line = struct;

% Now we'll create a second road geometry element. This one will be an arc
% with radius 50 meters (thus curvature of 1/50 1/m). 
% Enter the path length of the geometry segment. All attributes are entered
% as strings, even if numeric in value.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.length = '80';
% Since the math is easy here, we'll simply determine the parameters of the
% start point by inspection of the previous element. We moved 20 meters
% along the path, which was a straight line in the x direction. Thus, we
% have (E,N) = (20,0) and an unchanged heading of zero.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.s = '100';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.x = '100';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.y = '0';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.hdg = '0';
% Now we enter the parameter for the arc
ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.arc.Attributes.curvature = num2str(1/150);

% The final element will be a spiral, which will straighten the road back
% out from the 1/50 1/m curvature to zero curvature over 100 m of path
% length. 
% Enter the path length of the geometry segment. All attributes are entered
% as strings, even if numeric in value.
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.Attributes.length = '100';
% Since the previous arc element is non-trivial to determine the end point,
% we'll use the road segment function to determine the start location and
% orientation of this element from the previous segment
[x0,y0,h0] = fcn_RoadSeg_findXYfromST('arc',...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.x),...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.y),...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.hdg),...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.s),...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.length),...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.s)+...
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.Attributes.length),...
  0,... % zero since we want the coordinates at the centerline of the path
  str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{2}.arc.Attributes.curvature));  
% Now, using the calculated values, we'll fill out the values of this
% third spiral element
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.Attributes.s = '180';
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.Attributes.x = num2str(x0);
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.Attributes.y = num2str(y0);
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.Attributes.hdg = num2str(h0);
% Now we enter the curvStart and curvEndO parameters for the spiral
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.spiral.Attributes.curvStart = num2str(1/150);
ODRStruct.OpenDRIVE.road{1}.planView.geometry{3}.spiral.Attributes.curvEnd = num2str(0);
% At this point, we have a road reference line that runs from (0,0) along a
% 20 m line, along a 50 m arc, and then along a 100 m spiral, ending up at
% some (yet unknown) point in (E,N) space with a (yet unknown) non-zero
% heading. If more geometry elements were to be added, the same process as
% above would be employed repeatedly. 


% Once the road reference line geometry is complete, only the total path
% length needs to be written back to the road element attributes. This can
% be computed by summing the length attributes of the geometry elements
totalLength = 0;
for geomElemInd = 1:length(ODRStruct.OpenDRIVE.road{1}.planView.geometry)
  totalLength = totalLength + str2double(ODRStruct.OpenDRIVE.road{1}.planView.geometry{geomElemInd}.Attributes.length);
end
ODRStruct.OpenDRIVE.road{1}.Attributes.length = num2str(totalLength);


% The next aspect of the file to be written is the lane structure. Lanes
% are set up as left lanes, a center lane, and right lanes. The center lane
% has zero width itself but may have road markings with non-zero width. The
% center lane is defined by default with a lateral offset of zero from the
% road reference line but may be offset with various sections of offset
% geometry. 

% We'll start by defining an example offset, which will shift the center
% lane 1.5 meters to the left, starting at 20 meters along the reference
% line with a sweeping curve that has reached 1.5 meters of offset after 30
% meters along the reference line. The next 20 meters will have a constant
% offset of 1.5 meters, after which there will be a 30 meter section that
% will sweep the center lane back to the reference line. The remaining
% portion of the road will have zero offset.
% SECTION 1: 20 m no offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{1}.Attributes.s = '0'; % start station
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{1}.Attributes.a = '0'; % constant offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{1}.Attributes.b = '0'; % linear offset coef
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{1}.Attributes.c = '0'; % quadratic offset coef
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{1}.Attributes.d = '0'; % cubic offset coef
% SECTION 2: Leftward 1.5 m sweep over 30 meters station distance
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{2}.Attributes.s = '10';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{2}.Attributes.a = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{2}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{2}.Attributes.c = '-1.0833e-2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{2}.Attributes.d = '2.4074e-04';
% SECTION 3: 20 m constant 1.5 m offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{3}.Attributes.s = '40';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{3}.Attributes.a = '-3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{3}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{3}.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{3}.Attributes.d = '0';
% SECTION 4: Rightward 1.5 m sweep over 30 meters station distance
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{4}.Attributes.s = '60';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{4}.Attributes.a = '-3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{4}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{4}.Attributes.c = '1.0833e-2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{4}.Attributes.d = '-2.4074e-04';
% SECTION 5: remainder of road is constant with no offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{5}.Attributes.s = '90';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{5}.Attributes.a = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{5}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{5}.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{5}.Attributes.d = '0';
% And we'll repeat the same thing again with a rightward offset
% SECTION 6: 20 m no offset (note that this is redundant since it does not
% change from the previous section)
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{6}.Attributes.s = '120'; % start station
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{6}.Attributes.a = '0'; % constant offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{6}.Attributes.b = '0'; % linear offset coef
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{6}.Attributes.c = '0'; % quadratic offset coef
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{6}.Attributes.d = '0'; % cubic offset coef
% SECTION 7: Rightward 1.5 m sweep over 30 meters station distance
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{7}.Attributes.s = '140';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{7}.Attributes.a = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{7}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{7}.Attributes.c = '1.0833e-02';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{7}.Attributes.d = '-2.4074e-04';
% SECTION 8: 20 m constant 1.5 m offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{8}.Attributes.s = '170';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{8}.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{8}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{8}.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{8}.Attributes.d = '0';
% SECTION 9: Leftward 1.5 m sweep over 30 meters station distance
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{9}.Attributes.s = '210';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{9}.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{9}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{9}.Attributes.c = '-1.0833e-02';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{9}.Attributes.d = '2.4074e-04';
% SECTION 10: remainder of road is constant with no offset
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{10}.Attributes.s = '240';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{10}.Attributes.a = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{10}.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{10}.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneOffset{10}.Attributes.d = '0';

% In addition to defining the offset of the center lane (and thus the other
% lanes in relation to it), we need to define the center, left, and right
% lane properties, which are done in "lane sections" that share the same
% layout in terms of lane numbers, types, and width geometries. In a
% section, a lane may *change* width, but the parameters of the polynomial
% defining its shape must remain the same. If the coefficients change, the
% station at which they change defines the lane section boundary.

% We start a first lane section, and need to always have one lane section
% defined for every possible station along the reference line. Also include
% the boolean value for single side, which dictates whether or not there
% will be both left and right lanes or only one or the other
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.s = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.Attributes.singleSide = 'false';
% First, we'll set the center lane with ID = 0 (by definition). A road mark
% can also be defined within the center lane, but the road mark is not
% used in the MATLAB functions handling XODR to this point
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.center.lane.Attributes.id = '0';
% Next we'll define a left lane, which has a positive ID (in accordance
% with their increased t-coordinate and a positive width value. The lane
% will be the outside lane on the left, be defined as a shoulder type, and
% use the superelevation profile of the road (level = false)
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.Attributes.id = '2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.Attributes.type = 'shoulder';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.width.Attributes.a = '1.5';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{1}.width.Attributes.d = '0';
% Now add another lane that is a driving lane with a width of 3.25 m, and
% also uses the superelevation profile of the road
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.Attributes.id = '1';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{2}.width.Attributes.d = '0';
% Now do the same for the right side, adding another lane that is a driving
% lane with a width of 3.25 m, and also uses the superelevation profile of
% the road
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.Attributes.id = '-1';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{1}.width.Attributes.d = '0';
% Finally, add another shoulder lane for the right side with width 1.5 m
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.Attributes.id = '-2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.width.Attributes.a = '1.5';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{2}.width.Attributes.d = '0';

% Now do a second lane section. This lane section will be the same as the
% first section on the left side, but will have a middle lane that starts
% at zero width and grows to a full driving lane width by the end of the
% section. The innermost lane (lowest magnitude ID and closest to the
% centerline) and the shoulder lane will be continuous. Also, since this is
% the second section, each of the lanes except for the lane that is
% appearing will have a predecessor element within the link element.
% The way in which these predecessors are chosen will dictate the final
% geometry of the lane lines, as the lines are formed by the outside
% portion of the lane based on its width description.
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.Attributes.s = '140';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.Attributes.singleSide = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.center.lane.Attributes.id = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.center.lane.link.predecessor.Attributes.id = '0';
% Copy the left portion of the previous lane section into this lane section
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.left = ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left;
% Set the predecessors for each of the lanes, since it was not done in the
% first section
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.left.lane{1}.link.predecessor.Attributes.id = '2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.left.lane{2}.link.predecessor.Attributes.id = '1';
% Now define the lanes for the right side, adding another lane that is a
% driving lane with a width of 3.25 m, and also uses the superelevation
% profile of the road
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.Attributes.id = '-1';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.width.Attributes.d = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{1}.link.predecessor.Attributes.id = '-1';
% Add a lane with ID -2 that has no predecessor and sits between the
% shoulder and the inner driving lane that continues from the previous
% section
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.Attributes.id = '-2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.width.Attributes.a = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.width.Attributes.c = '1.0833e-02';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{2}.width.Attributes.d = '-2.4074e-04';
% Finally, add another shoulder lane for the right side
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.Attributes.id = '-3';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.Attributes.type = 'shoulder';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.width.Attributes.a = '1.5';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.width.Attributes.d = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2}.right.lane{3}.link.predecessor.Attributes.id = '-2';
% Add a third lane section to keep the extra lane at constant width for a
% bit. Since the only difference between this and the previous lane section
% is the constant geometry of the middle (ID = -2) lane and the
% predecessors, copy over section 2 and then modify the relevant parameters
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3} = ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{2};
% The start station changes location, so set it
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.Attributes.s = '170';
% Stop the lane width from changing in the ID = -2 lane in this section
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.right.lane{2}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.right.lane{2}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.right.lane{2}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.right.lane{2}.width.Attributes.d = '0';
% Set the updated predecessor for the middle (driving) lane
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.right.lane{2}.link.predecessor.Attributes.id = '-2';
% Finally, set the updated predecessor for the shoulder
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{3}.right.lane{3}.link.predecessor.Attributes.id = '-3';

% Add a fourth lane section to collapse the extra lane. In this case, we
% write out all of the XML/XODR elements for clarity, though they could be
% copied from a previous section and modified
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.Attributes.s = '210';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.Attributes.singleSide = 'false';
% First, we'll set the center lane with ID = 0 (by definition). A road mark
% can also be defined within the center lane, but the road mark is not
% used in the MATLAB functions handling XODR to this point
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.center.lane.Attributes.id = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.center.lane.link.predecessor.Attributes.id = '0';
% Next we add the left shoulder
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.Attributes.id = '2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.Attributes.type = 'shoulder';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.width.Attributes.a = '1.5';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.width.Attributes.d = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{1}.link.predecessor.Attributes.id = '2';
% Now add another lane that is a driving lane with a width of 3.25 m, and
% also uses the superelevation profile of the road
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.Attributes.id = '1';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.width.Attributes.d = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.left.lane{2}.link.predecessor.Attributes.id = '1';
% Now do the same for the right side, adding another lane that is a
% driving lane with a width of 3.25 m, and also uses the superelevation
% profile of the road
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.Attributes.id = '-1';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.width.Attributes.d = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{1}.link.predecessor.Attributes.id = '-1';
% profile of the road
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.Attributes.id = '-2';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.Attributes.type = 'driving';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.width.Attributes.a = '3.25';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.width.Attributes.c = '-1.0833e-02';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.width.Attributes.d = '2.4074e-04';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{2}.link.predecessor.Attributes.id = '-2';
% Finally, add another shoulder lane for the right side
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.Attributes.id = '-3';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.Attributes.level = 'false';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.Attributes.type = 'shoulder';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.width.Attributes.sOffset = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.width.Attributes.a = '1.5';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.width.Attributes.b = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.width.Attributes.c = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.width.Attributes.d = '0';
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{4}.right.lane{3}.link.predecessor.Attributes.id = '-3';

% And finally, make a fifth lane section that is the same as the first, but
% starts at a station of 220 m
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{5} = ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{1};
ODRStruct.OpenDRIVE.road{1}.lanes.laneSection{5}.Attributes.s = '240';

% Run a function to check the structure to make sure it is built properly
% and correct any errors that can be easily corrected
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Now check all of the work by calling the plotting utility on the
% structure created to this point
figure(1)
clf
hold on
grid on
axis tight
axis equal
xlabel('East (m)')
ylabel('North (m)')
% Plot the realistic looking road on the figure
fcn_RoadSeg_plotRealisticRoad(ODRStruct.OpenDRIVE.road{1},0.5,1);

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

% Run a function to return the various segment boundaries for the road geometry
[RoadSegmentStations,LaneOffsetStations,LaneSectionStations] = fcn_RoadSeg_extractXODRSegments(ODRStruct.OpenDRIVE.road{1});

% Iterate through the road geometry element boundaries, and plot a red line
% across the road at each boundary
for i = 1:length(RoadSegmentStations)
  [xRoadSeg,yRoadSeg] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},RoadSegmentStations(i)*[1; 1],[-20; 20]);
  hRoadSegs = plot(xRoadSeg,yRoadSeg,'-.','linewidth',2,'color',[0.6 0 0.1]);
end
% Iterate through the lane offset boundaries, and plot a green line across
% the road at each boundary
for i = 1:length(LaneOffsetStations)
  [xOffsetSeg,yOffsetSeg] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},LaneOffsetStations(i)*[1; 1],[-15; 15]);
  hOffsetSegs = plot(xOffsetSeg,yOffsetSeg,'--','linewidth',2,'color',[0.1 0.6 0]);
end
% Iterate through the lane section boundaries, and plot a blue line across
% the road at each boundary
for i = 1:length(LaneSectionStations)
  [xLaneSeg,yLaneSeg] = fcn_RoadSeg_findXYfromSTandODRRoad(ODRStruct.OpenDRIVE.road{1},LaneSectionStations(i)*[1; 1],[-10; 10]);
  hLaneSegs = plot(xLaneSeg,yLaneSeg,':','linewidth',2,'color',[0.1 0 0.6]);
end
% Label the boundary types in the legend
legend([hRoadSegs(1) hOffsetSegs(1) hLaneSegs(1)],...
  {'Road Geometry Element Boundaries','Lane Offset Boundaries','Lane Section Boundaries'})

if flag_write_XODR_file
  % Define a filename based on the time to avoid accidentally overwriting previous files
  myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
  % Write the XODR structure to an XML formatted file
  struct2xml(ODRStruct,myFilename)
  % Move the output file so that it has an XODR file extension
  movefile([myFilename '.xml'],[myFilename '.xodr'])
end