% This script tests the function fcn_modifyLaneWidths. 
% For details, please see fcn_modifyLaneWidths.m


%% case 1, a two way, two lane line-shape road

road1 = fcn_modifyLaneWidths(4,2,'testXODR_23-03-21T15-02-19_100mLine.xodr');

%% case 2, a two way, two lane, line-arc-spiral road

road2 = fcn_modifyLaneWidths(4,2,'testXODR_23-03-21T15-17-43_300mArc_Line_Spiral.xodr');

%% case 3, test track

road3 = fcn_modifyLaneWidths(20,2,'TestTrackConvertedFromLL.xodr'); 