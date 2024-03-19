% script_test_fcn_ParseXODR_checkStructureFields
% Script to test structure contents
% Tests function fcn_ParseXODR_checkStructureFields
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" written by C. Beal.
% Questions or comments? sbrennan@psu.edu
%
% Revision history:
%     2024_03_18
%     -- wrote the code

close all


%% Basic example - all required
structure_to_check = struct('required_field1',1,'required_field2',2);
required_fields = {'required_field1','required_field2'};
optional_fields = {};
flag_verbose = 1;
flag_good_match = fcn_ParseXODR_checkStructureFields(structure_to_check, required_fields, optional_fields, flag_verbose);

assert(isequal(flag_good_match,1));

%% Basic example - all required, one extra
structure_to_check = struct('required_field1',1,'required_field2',2,'extra1',3);
required_fields = {'required_field1','required_field2'};
optional_fields = {'extra1'};
flag_verbose = 1;
flag_good_match = fcn_ParseXODR_checkStructureFields(structure_to_check, required_fields, optional_fields, flag_verbose);

assert(isequal(flag_good_match,1));

%% Basic example - missing one required
structure_to_check = struct('required_field1',1,'required_field2',2);
required_fields = {'required_field1','required_field2','required_field3'};
optional_fields = {};
flag_verbose = 1;
flag_good_match = fcn_ParseXODR_checkStructureFields(structure_to_check, required_fields, optional_fields, flag_verbose);

assert(isequal(flag_good_match,0));

%% Basic example - all required, one extra
structure_to_check = struct('required_field1',1,'required_field2',2,'extra1',3);
required_fields = {'required_field1','required_field2'};
optional_fields = {'extra2'};
flag_verbose = 1;
flag_good_match = fcn_ParseXODR_checkStructureFields(structure_to_check, required_fields, optional_fields, flag_verbose);

assert(isequal(flag_good_match,0));