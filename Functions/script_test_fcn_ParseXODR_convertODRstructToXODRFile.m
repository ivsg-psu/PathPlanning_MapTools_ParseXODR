%% script_test_fcn_ParseXODR_convertODRstructToXODRFile
% Script to demonstrate creation of an XODR file using MATLAB struct.
% Tests function fcn_ParseXODR_convertODRstructToXODRFile
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_convertXODRtoMATLABStruct" as a starter.
% Questions or comments? sbrennan@psu.edu

% Revision history:
%     2024_03_10 - S. Brennan
%     -- wrote the code

clearvars

%% BASIC Example - no filename given

% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

% Convert and save the OpenDRIVE structure to an .xodr file
fileName = fcn_ParseXODR_convertODRstructToXODRFile(ODRStruct);
assert(ischar(fileName));
assert(exist(fileName,'file'));

%% BASIC Example - filename given

% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

% Set up file info
% Set the base name for the output scenario file
scenarioName = 'Example_scenario';

% Define the save directory
XODR_save_directory = fullfile(cd,'Data',filesep,'XODR_outputs');

% Get the current date and time in a specific format ('YYYY_MM_DDTHH_MM_SS')
% and convert it to a string. 'T' is a literal character.
datetimeString = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy_MM_dd''T''HH_mm_ss'));

% Concatenate the scenario name with the current date and time to form the output file name
outputFileName = strcat(scenarioName,'_',datetimeString);

% Name the subdirectory for storage
if exist(XODR_save_directory,'dir')~=7
    warning('backtrace','on')
    warning('Unable to find storage directory %s for XODR file - quitting.',XODR_save_directory);
    error('Unable to find directory: %s',XODR_save_directory);
end

% Add the save directory to the filename
full_filename = fullfile(XODR_save_directory,outputFileName);

% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(ODRStruct, full_filename);

%% BASIC Example - filename given, fig_num given
fig_num = 1; % Optional

% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

% Set up file info
% Set the base name for the output scenario file
scenarioName = 'Example_scenario';

% Define the save directory
XODR_save_directory = fullfile(cd,'Data',filesep,'XODR_outputs');

% Get the current date and time in a specific format ('YYYY_MM_DDTHH_MM_SS')
% and convert it to a string. 'T' is a literal character.
datetimeString = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy_MM_dd''T''HH_mm_ss'));

% Concatenate the scenario name with the current date and time to form the output file name
outputFileName = strcat(scenarioName,'_',datetimeString);

% Name the subdirectory for storage
if exist(XODR_save_directory,'dir')~=7
    warning('backtrace','on')
    warning('Unable to find storage directory %s for XODR file - quitting.',XODR_save_directory);
    error('Unable to find directory: %s',XODR_save_directory);
end

% Add the save directory to the filename
full_filename = fullfile(XODR_save_directory,outputFileName);

% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(ODRStruct, full_filename, fig_num);

%% BASIC Example - filename given, fast mode fig_num
fig_num = -1;

% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

% Set up file info
% Set the base name for the output scenario file
scenarioName = 'Example_scenario';

% Define the save directory
XODR_save_directory = fullfile(cd,'Data',filesep,'XODR_outputs');

% Get the current date and time in a specific format ('YYYY_MM_DDTHH_MM_SS')
% and convert it to a string. 'T' is a literal character.
datetimeString = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy_MM_dd''T''HH_mm_ss'));

% Concatenate the scenario name with the current date and time to form the output file name
outputFileName = strcat(scenarioName,'_',datetimeString);

% Name the subdirectory for storage
if exist(XODR_save_directory,'dir')~=7
    warning('backtrace','on')
    warning('Unable to find storage directory %s for XODR file - quitting.',XODR_save_directory);
    error('Unable to find directory: %s',XODR_save_directory);
end

% Add the save directory to the filename
full_filename = fullfile(XODR_save_directory,outputFileName);

% Convert and save the OpenDRIVE structure to an .xodr file with the specified output file name
fcn_ParseXODR_convertODRstructToXODRFile(ODRStruct, full_filename, fig_num);

%% Manual case (commented out)
if 1==0
    %% No test here
end