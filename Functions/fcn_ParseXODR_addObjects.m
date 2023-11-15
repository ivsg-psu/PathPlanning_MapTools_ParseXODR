function ODRstruct = fcn_ParseXODR_addObjects(ODRstruct, referenceENU, objectsENU, objectsRadius)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fcn_ParseXODR_addObjects
% Take input XODR file, reference ENU, and object clusters, then add objects
% to the road and output an updated XODR file.
%
% FORMAT:
%
%       fcn_ParseXODR_addObjects(inputXODR, referenceENU, objectCluster, outputFileName)
%
% INPUTS:
%
%      inputXODR      : XODR file to be parsed.
%
%      referenceENU   : Reference East-North-Up data.
%
%      objectCluster  : Struct containing object cluster data.
%
%      outputFileName : Name of the output XODR file.
%
% OUTPUTS:
%
%      An updated XODR file with added objects.
%
% DEPENDENCIES:
%
%      fcn_Path_convertXY2St.m
%
% EXAMPLES:
%
%      see script_test_fcn_ParseXODR_addObjects.m
%
% This function was written by Wushuang Bai
% Questions or comments? wxb41@psu.edu
%
% Revision history:
% 2023 10 14 first write of the code
% 2023 10 17 added comments


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
    if nargin ~= 4
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
objectEN = objectsENU(:,1:2);

% Loop through each object's EN coordinates
for ii = 1:length(objectEN)
    XY_points = objectEN(ii,:);
    referencePath = referenceENU(:,1:2);
    flag_snap_type = 1;  % Define snap type for conversion
    
    St_points = fcn_Path_convertXY2St(referencePath, XY_points, flag_snap_type);

    %% Write objects into road struct
    % Update road data with object attributes
    ODRstruct.OpenDRIVE.road{1}.objects.object{ii} = fcn_UpdateObjectAttributes(ODRstruct, ii, St_points, objectsRadius);
end

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

function object = fcn_UpdateObjectAttributes(ODRstruct, idx, St_points, objectsRadius)
% Helper function to set object attributes in the road structure.

object.Attributes.id = num2str(idx);
object.Attributes.name = 'TrafficCone01';
object.Attributes.s = num2str(St_points(1));
object.Attributes.t = num2str(St_points(2));
object.Attributes.zoffset = '0';
object.Attributes.hdg = '0';
object.Attributes.roll = '0';
object.Attributes.pitch = '0';
object.Attributes.orientation = '-';
object.Attributes.type = 'obstacle';
object.Attributes.height = '1';
object.Attributes.radius = num2str(objectsRadius);
object.Attributes.validLength = '0';
object.Attributes.dynamic = 'no';

end % Ends helper function
