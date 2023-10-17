% script_test_fcn_ParseXODR_addObjects.m .
% This is to test the function fcn_ParseXODR_addObjects.m
% For details, please see fcn_ParseXODR_addObjects.m

% Revision history:
% 2023 10 17: first write of the code
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
%% Basic Example 1
% Initialize a figure with a given figure number
fig_num = 11000;
figure(fig_num);
clf;  % Clear current figure

% Load a specific lane named 'Scenario_1_1_OuterLoopRoad_m1_MainLoopOuterLane'
LaneName = 'Scenario_1_1_OuterLoopRoad_m1_MainLoopOuterLane';
% Load the lane data and visualize it with 'AlignedDesign' and figure number provided
Lane = fcn_LoadWZ_loadLane(LaneName, 'AlignedDesign', 1, fig_num);

% Specify object cluster name for channelizers
ObjectClusterName = 'Scenario_1_1_Channelizers_FromOutsideWhiteSolidLineShoulder_ToOutsideWhiteSolidLine';
% Increment figure number
fig_num = 1; %fig_num+1;
% Load the object cluster data and visualize it with 'AlignedDesign' and figure number provided
objectCluster = fcn_LoadWZ_loadObjectCluster(ObjectClusterName, 'AlignedDesign', 0, fig_num);

% Define the input XODR file name
inputXODR = 'scenario1_1_doubleYellow.xodr';
% Extract the reference ENU coordinates from the loaded Lane
referenceENU = Lane.LeftMarkerCluster.TraceCenterOfMarkerCluster.ENU;
% Extract the object's ENU coordinates from the loaded object cluster
objectENU = objectCluster.TraceCenterOfObjectCluster.ENU;
% Define the output XODR file name
outputFileName = 'scenario1_1_doubleYellow_withChannelizers_FromOutsideWhiteSolidLineShoulder_ToOutsideWhiteSolidLine';

% Parse the input XODR file, add the loaded objects and save as the defined output file name
fcn_ParseXODR_addObjects(inputXODR, referenceENU, objectCluster, outputFileName);
