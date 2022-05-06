function [xPts,yPts] = fcn_RoadSeg_plotODRRoadGeometry(ODRStruct,maxPlotGap,varargin)
% fcn_RoadSeg_plotODRRoadGeometry
% Plots a visual representation of the road geometry defined in an XODR
% file
%
% FORMAT:
%
%       fcn_RoadSeg_plotODRRoadGeometry(ODRStruct,maxPlotGap,{fig_num})
%
% INPUTS:
%
%      ODRStruct: a nested structure containing the XDOR map elements
%      maxPlotGap: a scalar parameter defining the maximum distance (in
%         meters) between adjacent plot points (to make sure that any
%         curves have sufficient definition)
%
%      (OPTIONAL INPUTS)
%      fig_num: a figure number to plot into
%
% OUTPUTS:
%
%       No outputs. A figure will be created or populated with the XODR
%         map road geometry segments.
%
% DEPENDENCIES:
%
%      fcn_RoadSeg_findXYfromSTandSegment from the ParseXODR library
%
% EXAMPLES:
%
%       See the script: script_test_fcn_RoadSeg_plotODRRoadGeometry.m for a
%       full test suite.
%
% This function was written by C. Beal
% Questions or comments? cbeal@bucknell.edu

% Revision history:
%     2022_03_01
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
  if nargin < 2 || nargin > 3
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

% Did the user provide a figure number?
if 2 < nargin
  fig_num = varargin{1};
  figure(fig_num);
else
  % Make or freshen up figure for plotting the map
  figure
  clf
  hold on
  grid on
  axis equal
  xlabel('E (m)')
  ylabel('N (m)')
end
% Determine the axis limits according to the bounding box given in the XODR
% header element
axLimEast = str2double(ODRStruct.OpenDRIVE.header.Attributes.east);
axLimWest = str2double(ODRStruct.OpenDRIVE.header.Attributes.west);
axLimNorth = str2double(ODRStruct.OpenDRIVE.header.Attributes.north);
axLimSouth = str2double(ODRStruct.OpenDRIVE.header.Attributes.south);
% Check to make sure the map bounding box is valid (may be incorrect,
% but needs to be valid for the axis command to succeed)
if axLimWest >= axLimEast || axLimSouth >= axLimNorth
  % If the map bounding box is invalid, set the axes bounds to auto
  axis auto
else
  % If the map bounding box is valid, compute 5% margins for the map plot
  EWmargin = (axLimEast-axLimWest)*0.05;
  NSmargin = (axLimNorth-axLimSouth)*0.05;
  % Set the axes limits to match the map bounding box plus the margins
  axis([axLimWest-EWmargin, axLimEast+EWmargin, ...
    axLimSouth-NSmargin, axLimNorth+NSmargin])
end

% Iterate through all of the roads in the network
Nroads = length(ODRStruct.OpenDRIVE.road);
for roadIndex = 1:Nroads
  % Store the current road to a temporary variable to cut down indexing. If
  % there is only one road, then brace indexing is not supported and needs
  % to be handled differently.
  currentRoad = ODRStruct.OpenDRIVE.road{roadIndex};
  
  % Determine the number of geometry elements in the reference line of the
  % current road
  NgeomElems = length(currentRoad.planView.geometry);
  
  % Create a series of points for plotting, taking into account the
  % maximum gap allowed in the series of points. This is the set of station
  % points on the reference line for which the reference line geometry as
  % well as all of the lanes will be calculated. Note that these
  % s-coordinates form a grid in the s,t space upon which all of the x,y
  % points for continuous features such as lanes, etc. will be calculated
  lRoad = str2double(currentRoad.Attributes.length);
  Npts = ceil(lRoad/maxPlotGap);
  sPts = linspace(0,lRoad,Npts)';
  tRef = zeros(length(sPts),1);
  % Preallocate a t-coordinate vector for the center lane (which is
  % different than the reference line). This will be zero when the center
  % lane is not offset, but offsets may shift it. All other lane positions
  % are referenced to this position
  tCenter = zeros(Npts,1);
  % Preallocate some left and right width matrices with NaNs. These will be
  % filled with widths of lanes (in sequence, building away from the
  % center lane)
  tLeft = nan(length(sPts),10);
  tRight = nan(length(sPts),10);
  
  % Iterate through all of the geometry elements to determine the extents
  % of each of the elements and plot them
  for geomIndex = 1:NgeomElems
    % Address the current geometry element.
    geomElement = currentRoad.planView.geometry{geomIndex};
    
    % Determine the start station and the end station of the element
    l0 = str2double(geomElement.Attributes.length);
    s0 = str2double(geomElement.Attributes.s);
    
    % Determine the indices of the reference points that are within the
    % element range
    elemInds = find(sPts > s0 & sPts < s0+l0);
    
    % Use the parsing function to determine the x,y point locations from
    % the geometry of the road segment and the array of s points
    [xPts,yPts] = fcn_RoadSeg_findXYfromSTandSegment(geomElement,sPts(elemInds),tRef(elemInds));
    % Make the actual plot of the center line of the segment
    plot(xPts,yPts,'-.','color',0.4*[1 1 1]);
  end
  
end
