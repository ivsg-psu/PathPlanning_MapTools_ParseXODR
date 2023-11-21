% script_xodrLoopTest.m 
% This script performs loop tests for different types of roads. It converts
% the road into matlab structure from xodr, it converts it back to xodr
% format. 
%
% DEPENDENCIES:
% Various functions including:
% - fcn_RoadSeg_convertXODRtoMATLABStruct
% - fcn_convertODRstructToXODRFile
%
% This script was written by Wushuang
% Questions or comments? Contact wxb41@psu.edu
%
% REVISION HISTORY:
%
% 2023 09 26: first write of the code 
% -- Added initialization scripting

% Add the current directory and all its subdirectories to MATLAB's path.
% This is useful for ensuring that all functions and scripts in the current directory and its subdirectories are accessible to MATLAB.
addpath(genpath([pwd,'\']));


%% Case 1: Handling a Simple Line Shape Road
% This section processes a road with a straightforward linear shape.

% Read the XODR (OpenDRIVE format) file for the line-shaped road and convert it to a MATLAB structure.
road = fcn_RoadSeg_convertXODRtoMATLABStruct('testXODR_23-03-29T20-32-27_100m_line.xodr');

% Convert the MATLAB structure back to an XODR file, potentially for verification or other purposes.
outputFileName = fcn_ParseXODR_convertODRstructToXODRFile(road,'lineShape'); 

%% Case 2: Handling a Simple Arc Shape Road
% This section processes a road with an arc shape.

% Read the XODR file for the arc-shaped road and convert it to a MATLAB structure.
road = fcn_RoadSeg_convertXODRtoMATLABStruct('testXODR_23-03-29T20-37-43_100m_arc.xodr');

% Convert the MATLAB structure back to an XODR file.
outputFileName = fcn_ParseXODR_convertODRstructToXODRFile(road,'arcShape'); 

%% Case 3: Handling a Simple Spiral Shape Road
% This section processes a road with a spiral shape.

% Read the XODR file for the spiral-shaped road and convert it to a MATLAB structure.
road = fcn_RoadSeg_convertXODRtoMATLABStruct('testXODR_23-03-29T20-40-32_spiral.xodr');

% Convert the MATLAB structure back to an XODR file.
outputFileName = fcn_ParseXODR_convertODRstructToXODRFile(road,'spiralShape'); 

%% Case 4: Handling a Comprehensive Road: change of lane marker in the center
% This section processes a more complex road, which might include features like highways, shoulders, driving lanes, and lane markers.

% Read the XODR file for the comprehensive road and convert it to a MATLAB structure.
road = fcn_RoadSeg_convertXODRtoMATLABStruct('RR_RoadMarkChange_20230926_removeUserdata.xodr');

% Convert the MATLAB structure back to an XODR file.
outputFileName = fcn_ParseXODR_convertODRstructToXODRFile(road,'roadMarkChange'); 

%% Case 5: Handling a Comprehensive Road: change from one driving lane to two driving lanes 
% This section processes a more complex road, where the right driving lane
% changes from one to two 

% Read the XODR file for the comprehensive road and convert it to a MATLAB structure.
road = fcn_RoadSeg_convertXODRtoMATLABStruct('RR_20230926_1LaneTo2Lane.xodr');

% Convert the MATLAB structure back to an XODR file.
outputFileName = fcn_ParseXODR_convertODRstructToXODRFile(road,'1Laneto2Lane'); 


