% script_test_fcn_ParseXODR_countLanes.m
% This is a script to exercise the function: fcn_ParseXODR_countLanes.m
% This function was written on 2024_01_31 by S. Brennan, sbrennan@psu.edu

% Revision history:
% 2024_01_31 
% -- first write of the code

close all;

%% Basic Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   ____            _        ______                           _      
%  |  _ \          (_)      |  ____|                         | |     
%  | |_) | __ _ ___ _  ___  | |__  __  ____ _ _ __ ___  _ __ | | ___ 
%  |  _ < / _` / __| |/ __| |  __| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \
%  | |_) | (_| \__ \ | (__  | |____ >  < (_| | | | | | | |_) | |  __/
%  |____/ \__,_|___/_|\___| |______/_/\_\__,_|_| |_| |_| .__/|_|\___|
%                                                      | |           
%                                                      |_|          
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Basic%20Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% Basic example 1 - three completely overlapping lines that more/less have same start/end
fig_num = 1;
figure(fig_num);
clf;

lane_centerlines_start = [0; 0; -1];
lane_centerlines_end   = [10; 10; 11];
station_tolerance = 1;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes( lane_centerlines_start, lane_centerlines_end, station_tolerance, (fig_num));


%% Basic example 2 - three lines that have no overlap
fig_num = 2;
figure(fig_num);
clf;

lane_centerlines_start = [0; 6; 14];
lane_centerlines_end   = [4; 10; 17];
station_tolerance = 1;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes( lane_centerlines_start, lane_centerlines_end, station_tolerance, (fig_num));

%% Basic example - lines that have partial overlap
fig_num = 3;
figure(fig_num);
clf;

lane_centerlines_start = [0; 6; 14; 4; 7];
lane_centerlines_end   = [4; 10; 17; 9; 15];
station_tolerance = 1;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes( lane_centerlines_start, lane_centerlines_end, station_tolerance, (fig_num));

%% Basic example - lines that have partial overlap
fig_num = 4;
figure(fig_num);
clf;

lane_centerlines_start = [0; 6; 14; 4; 7];
lane_centerlines_end   = [3; 12; 17; 9; 15];
station_tolerance = 0.5;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes( lane_centerlines_start, lane_centerlines_end, station_tolerance, (fig_num));


%% Basic example - lines that have partial overlap
fig_num = 5;
figure(fig_num);
clf;

lane_centerlines_start = [0; 6; 14; 4; 7];
lane_centerlines_end   = [3; 12; 17; 9; 15];
station_tolerance = 2;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes( lane_centerlines_start, lane_centerlines_end, station_tolerance, (fig_num));

%% Basic example - lines with mixed partial or no overlap
fig_num = 6;
figure(fig_num);
clf;

lane_centerlines_start = [0; 3.5; 9; 16; 26];
lane_centerlines_end   = [3; 10; 15; 25; 30];
station_tolerance = 1;
[station_segments, per_segment_count, in_segment_membership] = fcn_ParseXODR_countLanes( lane_centerlines_start, lane_centerlines_end, station_tolerance, (fig_num));
