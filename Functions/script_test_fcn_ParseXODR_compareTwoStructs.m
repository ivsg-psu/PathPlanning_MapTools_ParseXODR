% script_test_fcn_ParseXODR_compareTwoStructs.m
% Exercises the function: fcn_ParseXODR_compareTwoStructs.m

% Revision history:
% 2024_03_06 - S. Brennan
% -- wrote the code

close all;
clc;


%% BASIC test - two simple structures that are the same
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;

structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct);

% Check that the key elements are there
assert(structs_are_same);

%% BASIC test - fast mode
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;

structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,[],[],[], -1);

% Check that the key elements are there
assert(structs_are_same);

%% BASIC test - two simple structures that are not the same
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
second_struct.level_1_struct2.level_2_struct.var = 6;

structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct);

% Check that the key elements are there
assert(~structs_are_same);

%% BASIC test - two simple structures that are the same, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;


template_structure = [];
flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(structs_are_same);

%% BASIC test - two simple structures that are not the same, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
second_struct.level_1_struct2.level_2_struct.var = 6;

template_structure = [];
flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(~structs_are_same);

%% BASIC test - two simple structures that are not the same, but same in template, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
second_struct.level_1_struct2.level_2_struct.var = 6;

template_structure.level_1_a = 2;
template_structure.level_1_b = 2;
template_structure.level_1_struct1.level_2_x = 3;
template_structure.level_1_struct1.level_2_y = 5;
template_structure.level_1_struct2.level_2_i = 5;

flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(structs_are_same);

%% BASIC test - two simple structures that are not the same, and different in template, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
second_struct.level_1_a = 3;
second_struct.level_1_struct2.level_2_struct.var = 6;

template_structure.level_1_a = 2;
template_structure.level_1_b = 2;
template_structure.level_1_struct1.level_2_x = 3;
template_structure.level_1_struct1.level_2_y = 5;
template_structure.level_1_struct2.level_2_i = 5;

flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(~structs_are_same);

%% BASIC test - two simple structures that are the same, and template has extra field, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
% second_struct.level_1_a = 3;
% second_struct.level_1_struct2.level_2_struct.var = 6;

template_structure.level_1_a = 2;
template_structure.level_1_b = 2;
template_structure.level_1_c = 7;  % <--- EXTRA FIELD
template_structure.level_1_struct1.level_2_x = 3;
template_structure.level_1_struct1.level_2_y = 5;
template_structure.level_1_struct2.level_2_i = 5;

flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(~structs_are_same);

%% BASIC test - two simple structures that are different because only 1 is missing field relative to template, template, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
second_struct = rmfield(second_struct,'level_1_b');

template_structure.level_1_a = 2;
template_structure.level_1_b = 2;
template_structure.level_1_struct1.level_2_x = 3;
template_structure.level_1_struct1.level_2_y = 5;
template_structure.level_1_struct2.level_2_i = 5;

flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(~structs_are_same);

%% BASIC test - two simple structures that are different because one has value that is different, template, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = first_struct;
second_struct.level_1_b = 7;

template_structure.level_1_a = 2;
template_structure.level_1_b = 2;
template_structure.level_1_struct1.level_2_x = 3;
template_structure.level_1_struct1.level_2_y = 5;
template_structure.level_1_struct2.level_2_i = 5;

flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(~structs_are_same);

%% BASIC test - two simple structures that completely different, template, VERBOSE
clear first_struct second_struct template_structure

first_struct.level_1_a = 2;
first_struct.level_1_b = 2;
first_struct.level_1_struct1.level_2_x = 3;
first_struct.level_1_struct1.level_2_y = 5;
first_struct.level_1_struct2.level_2_i = 5;
first_struct.level_1_struct2.level_2_j = 'abc';
first_struct.level_1_struct2.level_2_struct.var = 5;

second_struct = 42; % Not even a structure

template_structure.level_1_a = 2;
template_structure.level_1_b = 2;
template_structure.level_1_struct1.level_2_x = 3;
template_structure.level_1_struct1.level_2_y = 5;
template_structure.level_1_struct2.level_2_i = 5;

flag_verbose_mode = 1;
structs_are_same = fcn_ParseXODR_compareTwoStructs(first_struct, second_struct,template_structure,flag_verbose_mode);

% Check that the key elements are there
assert(~structs_are_same);
%% UNUSED
% %% Test 2: many vectors
% fig_num = 2;
% input_vectors = randn(10,2); 
% unit_vectors = fcn_geometry_calcUnitVector(input_vectors, fig_num);
% 
% % Check that they are all unit length
% length_errors = ones(length(unit_vectors(:,1)),1) - sum(unit_vectors.^2,2).^0.5;
% assert(all(abs(length_errors)<(eps*100)));
% 
% %% Test 2: many 3D vectors
% fig_num = 3;
% input_vectors = randn(10,3); 
% unit_vectors = fcn_geometry_calcUnitVector(input_vectors, fig_num);
% 
% % Check that they are all unit length
% length_errors = ones(length(unit_vectors(:,1)),1) - sum(unit_vectors.^2,2).^0.5;
% assert(all(abs(length_errors)<(eps*100)));
% 
% %% Testing fast mode
% % Perform the calculation in slow mode
% fig_num = [];
% REPS = 1000; minTimeSlow = Inf;
% tic;
% for i=1:REPS
%     tstart = tic;
%     unit_vectors = fcn_geometry_calcUnitVector(input_vectors, (fig_num));
%     telapsed = toc(tstart);
%     minTimeSlow = min(telapsed,minTimeSlow);
% end
% averageTimeSlow = toc/REPS;
% 
% % Perform the operation in fast mode
% fig_num = -1;
% REPS = 1000; minTimeFast = Inf; 
% tic;
% for i=1:REPS
%     tstart = tic;
%     unit_vectors = fcn_geometry_calcUnitVector(input_vectors, (fig_num));
%     telapsed = toc(tstart);
%     minTimeFast = min(telapsed,minTimeFast);
% end
% averageTimeFast = toc/REPS;
% 
% fprintf(1,'Comparison of fast and slow modes of fcn_geometry_calcUnitVector:\n');
% fprintf(1,'N repetitions: %.0d\n',REPS);
% fprintf(1,'Slow mode average speed per call (seconds): %.8f\n',averageTimeSlow);
% fprintf(1,'Slow mode fastest speed over all calls (seconds): %.8f\n',minTimeSlow);
% fprintf(1,'Fast mode average speed per call (seconds): %.8f\n',averageTimeFast);
% fprintf(1,'Fast mode fastest speed over all calls (seconds): %.8f\n',minTimeFast);
% fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
% fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);

%% Fail conditions
if 1==0
    %% FAIL 1: points not long enough
    points = [2 3];
    [slope,intercept] = fcn_geometry_calcUnitVector(points,fig_num);
    fprintf(1,'\n\nSlope is: %.2f, Intercept is: %.2f\n',slope,intercept);
end