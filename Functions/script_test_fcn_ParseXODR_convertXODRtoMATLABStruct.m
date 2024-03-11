%% script_test_fcn_ParseXODR_convertXODRtoMATLABStruct
% Script to demonstrate loading of an XODR file.
% Tests function fcn_ParseXODR_convertXODRtoMATLABStruct
%
% This script was written by S. Brennan from
% "script_test_fcn_ParseXODR_plotXODRinENU" as a starter.
% Questions or comments? sbrennan@psu.edu

% Revision history:
%     2024_03_10
%     -- wrote the code

clearvars

%% Load an example file from a static file path
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

assert(isstruct(ODRStruct));


%% Load an example file from a static file path, and plot result
fig_num = 1;
ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset.xodr', fig_num);
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Gains.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Simple_Lane_Offset_Reversed.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('Ex_Complex_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_100m_Lane_Offset.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('workzone_50m_curve_barrels.xodr');
% ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct('testTrack_outerTrack.xodr');

assert(isstruct(ODRStruct));


%% Manual case (commented out)
if 1==0
    %% Empty inputs
    ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct;
    assert(isstruct(ODRStruct));

    %% Empty input, explicit
    ODRStruct = fcn_ParseXODR_convertXODRtoMATLABStruct([],2);
    assert(isstruct(ODRStruct));
end