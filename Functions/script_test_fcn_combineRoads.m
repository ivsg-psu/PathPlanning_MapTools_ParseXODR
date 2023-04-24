% script_test_fcn_combineRoads.m 
% This is the script to test the function fcn_combineRoads.m. For more
% details, please see fcn_combineRoads.m

%% Test case 1: combine two one-lane, one-way no shoulder roads.
predecessorRoad = 'testXODR_23-03-21T15-02-19_100mLine_oneLane_noShoulder.xodr';
successorRoad = 'testXODR_23-03-21T15-02-19_100mLine_oneLane_noShoulder.xodr';

fcn_combineRoads(predecessorRoad,successorRoad);

%% Test case 2: combine two two-lane, two-way with shoulder roads
predecessorRoad = 'testXODR_23-03-21T15-02-19_100mLine.xodr';
successorRoad = 'testXODR_23-03-21T15-02-19_100mLine.xodr';

fcn_combineRoads(predecessorRoad,successorRoad);