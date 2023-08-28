function fileName = fcn_convertDataPointsToARoad(enuData,varargin)
% fcn_convertDataPointsToARoad.m
% This function converts a set of data points into a road representation. Specifically, 
% each pair of consecutive data points forms a small line segment within the geometry, 
% which when combined, create the entire road.
%
% FORMAT:
%
%       fileName = fcn_convertDataPointsToARoad(enuData)
%
% INPUTS:
%       enuData: A set of data points in ENU (East, North, Up) coordinates.
%
% OUTPUTS:
%       fileName: The name of the generated .xodr file representing the road.
%
% DEPENDENCIES:
%       - fcn_RoadSeg_convertXODRtoMATLABStruct
%       - fcn_Path_convertPathToTraversalStructure
%       - fcn_Path_newTraversalByStationResampling
%       - fcn_RoadSeg_XODRSegmentChecks
%       - struct2xml
%
% EXAMPLES:
%
%       % Use the function with a set of ENU coordinates:
%       fileName = fcn_convertDataPointsToARoad(enuCoordinates);
%
% This function was written by Wushuang
% Questions or comments? Contact wxb41@psu.edu
%
% REVISION HISTORY:
%
% 2023-05-20: Initial creation of the function.
% 2023-05-21: Added comments.
% 2023-05-23: Utilized path class for traversal calculation.
% 2023-05-25: Removed data shifting.
% 2023-06-01: Implemented path data resampling function.
%
% TO DO:
%       - add a flag to indicate whether user need to close the loop. 

flag_do_debug = 1; % Flag to show function info in UI
flag_do_plots = 0; % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
end

% Does user want to show the plots?
if 2 == nargin
    fig_num = varargin{1};
    figure(fig_num);
    flag_do_plots = 1;
else
    if flag_do_debug
        fig = figure;
        fig_num = fig.Number;
        flag_do_plots = 1;
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
% Load template xodr file
roadData = fcn_RoadSeg_convertXODRtoMATLABStruct('manual_stitchPointsForTestTrack.xodr');  

% convert from path to traversal
input_traversal = fcn_Path_convertPathToTraversalStructure(enuData);
interval = 10; % default resampling interval is set to 10 meters; 
new_stations    = (0:interval:input_traversal.Station(end))';
new_traversal = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);

% close the gap after resampling
x1= new_traversal.X(end);
y1 = new_traversal.Y(end);
x2 = new_traversal.X(1);
y2 = new_traversal.Y(1);
gapPath = [x1,y1;x2,y2];
gapTraversal = fcn_Path_convertPathToTraversalStructure(gapPath);

new_traversal.X(end+1) = x2;
new_traversal.Y(end+1) = y2;
new_traversal.Z(end+1) = new_traversal.Z(1);
new_traversal.Diff(end+1,:) = gapTraversal.Diff(end,:);
new_traversal.Station(end+1) = gapTraversal.Station(end) + new_traversal.Station(end);
new_traversal.Yaw(end+1) = gapTraversal.Yaw(end);

new_traversal.Yaw = real(new_traversal.Yaw);
new_traversal.segmentLength = diff(new_traversal.Station);



% write the new_traversal into open drive struct 
for ii = 1:length(new_traversal.segmentLength)
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.hdg = new_traversal.Yaw(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.length = new_traversal.segmentLength(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.s = new_traversal.Station(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.x = new_traversal.X(ii);
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.y = new_traversal.Y(ii);    
    roadData.OpenDRIVE.road{1}.planView.geometry{ii}.line = struct; 
end
% update total length of the road
roadData.OpenDRIVE.road{1}.Attributes.length = new_traversal.Station(end);
% write the output file
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roadData);
myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
struct2xml(ODRStruct,myFilename);
movefile([myFilename '.xml'],[myFilename '.xodr']);
fileName = myFilename ;

%% Any debugging?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 1==flag_do_plots
figure(fig_num);

plot(new_traversal.X,new_traversal.Y,'bo','LineWidth',2);
xlabel('xEast [meters]');
ylabel('yNorth [meters]');
legend('Resampled ENU data');
axis equal;
end
end
