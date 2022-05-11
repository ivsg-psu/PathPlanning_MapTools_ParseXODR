% Script to test the extraction of the sizes and segmentation of an xODR
% structure, using fcn_RoadSeg_extractXODRSegments
%
% This script was written by C. Beal
% Questions or comments? cbeal@bucknell.edu 
%
% Revision history:
%     2022_05_10
%     -- wrote the code

clearvars
close all

% Load an example file from a static file path
ODRStruct = fcn_RoadSeg_convertXODRtoMATLABStruct('/Users/cbeal/Documents/MATLAB/DOT_ParseXODR/Data/Ex_Simple_Lane_Offset.xodr');

% Check the structure
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(ODRStruct);

% Select a road for which to extract the sizes and segments
ODRRoad = ODRStruct.OpenDRIVE.road{1};

% Extract the sizes and segments for the selected road
[RoadSegmentStations,LaneOffsetStations,LaneSectionStations] = ...
  fcn_RoadSeg_extractXODRSegments(ODRRoad);

