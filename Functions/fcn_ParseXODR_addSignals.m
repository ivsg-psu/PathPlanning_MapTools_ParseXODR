function ODRstruct = fcn_ParseXODR_addSignals(ODRstruct, referenceENU, signalENU,signalID,signalName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_addSignals
% Take input XODR file, reference ENU, and object clusters, then add objects
% to the road and output an updated XODR file.
%
% FORMAT:
%
%       fcn_ParseXODR_addObjects(inputXODR, referenceENU, objectCluster, outputFileName)
%
% INPUTS:
%
%      ODRstruct     : matlab struct for xodr file
%
%      referenceENU   : Reference East-North-Up data for road center line
%
%      signalENU  : ENU coordinate for the object/signal
%
%      signalID: the ID for the signal
%   
%      signalName: the name for the signal, for example "road work ahead sign"
% OUTPUTS:
%
%      ODRstruct: an updated struct that contains the signal added
%
% DEPENDENCIES:
%
%      NA
%
% EXAMPLES:
%
%      See script_ParseXODR_createScenario1_5.m for a comprehensive test
%      suite. 
%
% This function was written by Wushuang Bai
% Questions or comments? wxb41@psu.edu
%
% Revision history:
% 2023 10 14 first write of the code
% 2023 10 17 added comments
% 2023 11 20 updated comments

flag_do_debug = 1; % Flag to show function info in UI
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if flag_check_inputs == 1
    % Are there the right number of inputs?
    if nargin ~= 5
        error('Incorrect number of input arguments')
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Convert xy to st
% Extract object's East-North (EN) coordinates
objectEN = signalENU(:,1:2);
XY_points = objectEN;
referencePath = referenceENU(:,1:2);
flag_snap_type = 1;  % Define snap type for conversion
St_points = fcn_Path_convertXY2St(referencePath, XY_points, flag_snap_type);

%% Write objects into road struct
% Update road data with object attributes
ODRstruct.OpenDRIVE.road{1}.signals.signal{signalID} = fcn_UpdateObjectAttributes(signalID, St_points,signalName);

%% Convert updated road struct back to XODR file format.
% fcn_ParseXODR_convertODRstructToXODRFile(ODRstruct, outputFileName);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NA.

end % Ends main function



%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

function signal = fcn_UpdateObjectAttributes(signalID, St_points,signalName)
% Helper function to set object attributes in the road structure.

signal.Attributes.dynamic = 'no';
signal.Attributes.hOffset = '0';
signal.Attributes.height = '1';
signal.Attributes.id = num2str(signalID);
signal.Attributes.name = signalName;
signal.Attributes.orientation =  '-';
signal.Attributes.pitch = '0';
signal.Attributes.roll = '0';
signal.Attributes.s=num2str(St_points(1));
signal.Attributes.subtype= '-1';
signal.Attributes.t=num2str(St_points(2));
signal.Attributes.type= '-1';
signal.Attributes.width = '0.608';
signal.Attributes.zOffset= '0';
end % Ends helper function
