% This script tests the function fcn_modifyLaneWidths. 
% For details, please see fcn_modifyLaneWidths.m
% Author: Wushuang
% Revision history:
% 20230530 first write of code
% 20230617 added more test cases since the function updated to change lane
% width at some station offset

% Note: the function may give some information indicating that the heading 
% of predecessor segment is different from the successor segment, and that is OK.
% Because for test track, we are approximating the curve using small <line>
% segments.

%% case 1, update a left shoulder lane width through the whole lane
clear; close all; clc;
road_num = 1;
lane_ID = '2';
lane_width = 10;
lane_sOffset = 0;
filePath = 'testXODR_23-03-21T15-02-19_100mLine.xodr';
road1 = fcn_modifyLaneWidths(road_num,lane_ID,lane_width,lane_sOffset,filePath);

%% case 2, update a right driving lane width through the whole lane

road_num = 1;
lane_ID = '-1';
lane_width = 10;
lane_sOffset = 0;
filePath = 'testXODR_23-03-21T15-02-19_100mLine.xodr';
road2 = fcn_modifyLaneWidths(road_num,lane_ID,lane_width,lane_sOffset,filePath);

%% case 3, update a right driving lane width starting at station = 50 meters

road_num = 1;
lane_ID = '-1';
lane_width = 10;
lane_sOffset = 50;
filePath = 'testXODR_23-03-21T15-02-19_100mLine.xodr';
road3 = fcn_modifyLaneWidths(road_num,lane_ID,lane_width,lane_sOffset,filePath);

%% case 4, update a right driving lane width of test track through the whole lane

road_num = 1;
lane_ID = '-1';
lane_width = 10;
lane_sOffset = 0;
filePath = 'TestTrackConvertedFromENU.xodr';
road4 = fcn_modifyLaneWidths(road_num,lane_ID,lane_width,lane_sOffset,filePath);

%% case 5, update a right driving lane width of test track starting from station = 500 meters 

road_num = 1;
lane_ID = '-1';
lane_width = 10;
lane_sOffset = 500;
filePath = 'TestTrackConvertedFromENU.xodr';
road5 = fcn_modifyLaneWidths(road_num,lane_ID,lane_width,lane_sOffset,filePath);
