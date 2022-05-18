% Script to plot a realistic road environment defined in an XODR file
%
% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu
%
% Revision history:
%     2022_05_10
%     -- wrote the code

clearvars

% Load an example file from a static file path
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Gains.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset_Reversed.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Complex_Lane_Offset.xodr');
%ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/workzone_100m_Lane_Offset.xodr');
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/ODRViewerEx.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Create a blank figure in which to plot the roads
figure(1)
clf
hold on
grid on
axis equal
xlabel('East (m)')
ylabel('North (m)')

% Determine how many roads are defined in the XODR file
Nroads = length(ODRStruct.OpenDRIVE.road);

% Choose a minimum spacing of the points defining the road geometries
minPlotGap = 0.2; % (m)

% Call the plotting function
fcn_RoadSeg_plotRealisticRoad(ODRStruct,minPlotGap,1);