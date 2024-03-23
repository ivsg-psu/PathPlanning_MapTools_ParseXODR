% Script to test the parsing of objects from an xODR structure, using the
% various functions from this library as well as the PlotXODR library and
% the patch object library (for plotting)

% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu 

% Revision history:
%     2022_04_01
%     -- wrote the code
%     2024_01_29 - S. Brennan
%     -- cleaned up dependencies, made sure it still worked with removal of
%     hard path definitions

clearvars
close all

% Load an example file with a file selection dialog
%ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct;

% Load an example file from a static file path
%ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('ODRViewerEx.xodr');
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_150m_double_curve_barrels_repeat.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_objects.xodr');

% Check the structure
ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

% Create a new figure
hRoad = figure(1);
clf
hold on
grid on
axis equal
xlabel('East (m)')
ylabel('North (m)')

% Define the max gap between plot points on the road, in meters
maxRoadGap = 0.1; 
% Compute the 
lRoad = str2double(ODRStruct.OpenDRIVE.road{1}.Attributes.length);
Npts = ceil(lRoad/maxRoadGap);
sPts = linspace(0,lRoad,Npts)';
% Compute the east and north coordinates from the series of station
% coordinates and an associated vector of zero t-coordinates
[eRef,nRef] = fcn_ParseXODR_extractXYfromSTandCenterline(ODRStruct.OpenDRIVE.road{1}.planView.geometry, sPts, zeros(size(sPts)));


% Plot the road segment in the previously addressed figure
hRef = plot(eRef,nRef,'-.','linewidth',1,'color',[0.5 0.5 0.5]);

% Define the max gap between points on the object outline, in meters
maxObjectVertexGap = 0.05;
% Convert the XODR objects to patch objects in an array
objectArray = fcn_ParseXODR_convertXODRObjectsToPatchObjects(ODRStruct,maxObjectVertexGap);

% Add the path for the patch objects plotting library
% addpath(genpath('/Users/cbeal/Documents/MATLAB/DOT_MapAssoc/'));

% Plot the patch objects on top of the (previously plotted) roadway figure
fcn_ParseXODR_plotPatch(objectArray,hRoad);