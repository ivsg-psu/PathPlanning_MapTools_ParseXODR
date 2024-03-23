function [ODRStruct, fullPath] = fcn_ParseXODR_convertXODRtoMATLABStruct(varargin)
%% fcn_ParseXODR_convertXODRtoMATLABStruct
% Converts XODR descriptions of a road system and associated objects into a
% nested MATLAB structure. If no input is given in fullPath, a prompt is
% given for user to enter the file.
%
% FORMAT:
%
%       [ODRStruct,fullPath] = fcn_ParseXODR_convertXODRtoMATLABStruct({fullPath},{fig_num})
%
% INPUTS:
%
%      (OPTIONAL INPUTS)
%
%      fullPath: a string containing a complete file path to an XODR file.
%      If empty, then a prompt is given for the user to enter the file.
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%       ODRStruct: a nested structure containing the XDOR map elements
%       fullPath: a string containing a complete file path to an XODR map
%
% DEPENDENCIES:
%
%      xml2struct_fex28518
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_convertXODRtoMATLABStruct.m for
%       a full test suite.
%
% This function was written by C. Beal on 2022_03_20,
% and is maintained by S. Brennan.
% Questions or comments? cbeal@bucknell.edu or sbrennan@psu.edu

% Revision history:
% 2022_03_20 - C. Beal
% -- wrote the code
% 2023_03_27 - C. Beal
% --muted codes for checking objects. This is not needed for plotting roads.
% 2024_03_10 - S. Brennan
% -- renamed function from fcn_RoadSeg_convertXODRtoMATLABStruct
% -- added environment variable debugging flags
% -- cleaned up comments
% -- added fig_num
% -- fixed bug where output is not returned if user does not enter at
% prompt



%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==2 && isequal(varargin{end},-1))
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS");
    MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG = getenv("MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PARSEXODR_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PARSEXODR_FLAG_CHECK_INPUTS);
    end
end

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 34838; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
end

%% check input arguments
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

if 0==flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(0,2);

        % % Check the projection_vector input to be length greater than or equal to 1
        % fcn_DebugTools_checkInputsToFunctions(...
        %     input_vectors, '2or3column_of_numbers');

    end
end

% Does user want to input file path manually?
if nargin == 0 || isempty(varargin{1})
    [filename,pathname] = uigetfile('.xodr','Choose an ASAM OpenDrive XML file to parse.');
    if isequal(filename,0)
        return;
    end
    fullPath = fullfile(pathname,filename);
end


% Does user want to specify the filename?
if nargin >= 1
    temp = varargin{1};
    if ~isempty(temp)
        fullPath = varargin{1};
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) && (2<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end


%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make sure that the xml to structure dependency file is available
results = which("xml2struct_fex28518");

if isempty(results)
    % addpath(uigetdir('.','Provide missing path to xml2struct_fex28518'));
    error('The package: xml2struct_fex28518, was not installed correctly.');
end

% Use the xml2struct utility to create a nested structure of the XODR
% attributes
ODRStruct = xml2struct_fex28518(fullPath);

% Unify the formatting of the MATLAB data structure so that singleton roads
% or singleton geometry segments are in cell arrays (of a single element)
% to be consistent with the data structures where there are multiple roads
% and/or multiple geometry elements

% Determine the number of roads in the map
Nroads = length(ODRStruct.OpenDRIVE.road);
% Check for a single road in the file
if 1 == Nroads
    % If the road is a single one, fix the structure by creating a
    % temporary copy and then adding it back to the structure as the only
    % element in a cell array in the original field.
    temp = ODRStruct.OpenDRIVE.road;
    ODRStruct.OpenDRIVE = rmfield(ODRStruct.OpenDRIVE,'road');
    ODRStruct.OpenDRIVE.road{1} = temp;
end

for roadInd = 1:Nroads
    NgeomElems = length(ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry);

    % Check for a single geometry element in the road structure
    if 1 == NgeomElems
        % If there is only a single geometry element, fix the structure by
        % creating a temporary copy and then adding it back to the structure as
        % the only element in a cell array in the original field.
        temp = ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry;
        ODRStruct.OpenDRIVE.road{roadInd}.planView = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.planView,'geometry');
        ODRStruct.OpenDRIVE.road{roadInd}.planView.geometry{1} = temp;
    end

    % Check for a single lane offset element in the road structure
    if isfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes,'laneOffset')
        NlaneOffsets = length(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneOffset);
        if 1 == NlaneOffsets
            % If there is only a single geometry element, fix the structure by
            % creating a temporary copy and then adding it back to the structure as
            % the only element in a cell array in the original field.
            temp = ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneOffset;
            ODRStruct.OpenDRIVE.road{roadInd}.lanes = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes,'laneOffset');
            ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneOffset{1} = temp;
        end
    end
    % Check for a single lane segment element in the road structure
    NlaneSegs = length(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection);
    if 1 == NlaneSegs
        % If there is only a single geometry element, fix the structure by
        % creating a temporary copy and then adding it back to the structure as
        % the only element in a cell array in the original field.
        temp = ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection;
        ODRStruct.OpenDRIVE.road{roadInd}.lanes = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes,'laneSection');
        ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{1} = temp;
    end
    if NlaneSegs > 0
        for laneSectionInd = 1:NlaneSegs
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd},'left')
                Nleftlanes = length(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.left.lane);
                if 1 == Nleftlanes
                    % If there is only a single left lane element, fix the structure by
                    % creating a temporary copy and then adding it back to the structure as
                    % the only element in a cell array in the original field.
                    temp = ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.left.lane;
                    ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.left = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.left,'lane');
                    ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.left.lane{1} = temp;
                end
            end
            if isfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd},'right')
                Nrightlanes = length(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.right.lane);
                if 1 == Nrightlanes
                    % If there is only a single left lane element, fix the structure by
                    % creating a temporary copy and then adding it back to the structure as
                    % the only element in a cell array in the original field.
                    temp = ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.right.lane;
                    ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.right = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.right,'lane');
                    ODRStruct.OpenDRIVE.road{roadInd}.lanes.laneSection{laneSectionInd}.right.lane{1} = temp;
                end
            end
        end
    end
    %   if isfield(ODRStruct.OpenDRIVE.road{roadInd},'objects')
    %     if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects,'object')
    %       Nobjects = length(ODRStruct.OpenDRIVE.road{roadInd}.objects.object);
    %       if 1 == Nobjects
    %         % If there is only a single geometry element, fix the structure by
    %         % creating a temporary copy and then adding it back to the structure as
    %         % the only element in a cell array in the original field.
    %         temp = ODRStruct.OpenDRIVE.road{roadInd}.objects.object;
    %         ODRStruct.OpenDRIVE.road{roadInd}.objects = rmfield(ODRStruct.OpenDRIVE.road{roadInd}.objects,'object');
    %         ODRStruct.OpenDRIVE.road{roadInd}.objects.object{1} = temp;
    %       end
    %       objInd = 1;
    %       while objInd <= Nobjects
    %         % Check for object repeats
    %         if isfield(ODRStruct.OpenDRIVE.road{1}.objects.object{objInd},'repeat')
    %           % Object is actually a repeated object definition and needs to be
    %           % broken up into individual objects for the MATLAB structure
    %
    %           % Repeated objects are defined first by their s coordinates, so
    %           % grab the s coordinate of the first instance from the repeat
    %           % structure (if it exists) or the root object structure
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat,'s')
    %             sStart = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.s);
    %           else
    %             sStart = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.Attributes.s);
    %           end
    %           % The interval is defined by the repeat field distance
    %           sInterval = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.distance);
    %           % The end of the s range of the objects is defined by the field
    %           % length
    %           sEnd = str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.length);
    %           % Define the array of instances of the objects by s coordinate
    %           sArray = sStart:sInterval:sEnd+sStart;
    %           % Determine the number of objects defined by the repeat
    %           Nrepeats = length(sArray);
    %           % Determine other characteristics that are varying within the
    %           % repeat structure (may include height, length, radius, t
    %           % coordinate, width, zOffset)
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'heightStart')
    %             if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'heightEnd')
    %               hArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.heightStart),...
    %                 str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.heightEnd),Nrepeats);
    %             else
    %               fprintf(1,'In road %s, object %d, repeat parameter heightStart defined without heightEnd\n',...
    %                 ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
    %             end
    %           end
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'lengthStart')
    %             if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'lengthEnd')
    %               lArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.lengthStart),...
    %                 str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.lengthEnd),Nrepeats);
    %             else
    %               fprintf(1,'In road %s, object %d, repeat parameter lengthStart defined without lengthEnd\n',...
    %                 ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
    %             end
    %           end
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'radiusStart')
    %             if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'radiusEnd')
    %               rArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.radiusStart),...
    %                 str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.radiusEnd),Nrepeats);
    %             else
    %               fprintf(1,'In road %s, object %d, repeat parameter radiusStart defined without radiusEnd\n',...
    %                 ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
    %             end
    %           end
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'tStart')
    %             if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'tEnd')
    %               tArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.tStart),...
    %                 str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.tEnd),Nrepeats);
    %             else
    %               fprintf(1,'In road %s, object %d, repeat parameter tStart defined without tEnd\n',...
    %                 ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
    %             end
    %           end
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'widthStart')
    %             if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'widthEnd')
    %               wArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.widthStart),...
    %                 str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.widthEnd),Nrepeats);
    %             else
    %               fprintf(1,'In road %s, object %d, repeat parameter widthStart defined without widthEnd\n',...
    %                 ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
    %             end
    %           end
    %           if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'zOffsetStart')
    %             if isfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes,'zOffsetEnd')
    %               zArray = linspace(str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.zOffsetStart),...
    %                 str2double(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd}.repeat.Attributes.zOffsetEnd),Nrepeats);
    %             else
    %               fprintf(1,'In road %s, object %d, repeat parameter zOffsetStart defined without zOffsetEnd\n',...
    %                 ODRStruct.OpenDRIVE.road{roadInd}.Attributes.id,objInd)
    %             end
    %           end
    %
    %           % Prune the repeat structure off of the original object
    %           ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd} = ...
    %             rmfield(ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd},'repeat');
    %           % Make room for the repeated objects by shifting any following
    %           % objects further along in the array
    %           if objInd < Nobjects
    %             ODRStruct.OpenDRIVE.road{roadInd}.objects.object(objInd+Nrepeats:objInd+Nrepeats+(Nobjects-objInd)-1) = ...
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object(objInd+1:Nobjects);
    %             % Update the number of objects (repeating includes the original
    %             % object, so we add the number of repeated objects minus one
    %             Nobjects = Nobjects + (Nrepeats - 1);
    %           end
    %           % Now fill the repeated objects in the array with the properties
    %           % of the original one, then modify the varying parameters
    %           for repInd = 1:Nrepeats
    %             ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1} = ...
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{objInd};
    %             ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.s = ...
    %               num2str(sArray(repInd),'%.16e');
    %             if exist('hArray')
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.height = ...
    %                 num2str(hArray(repInd),'%.16e');
    %             end
    %             if exist('lArray')
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.length = ...
    %                 num2str(lArray(repInd),'%.16e');
    %             end
    %             if exist('rArray')
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.radius = ...
    %                 num2str(rArray(repInd),'%.16e');
    %             end
    %             if exist('tArray')
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.t = ...
    %                 num2str(tArray(repInd),'%.16e');
    %             end
    %             if exist('wArray')
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.width = ...
    %                 num2str(wArray(repInd),'%.16e');
    %             end
    %             if exist('zArray')
    %               ODRStruct.OpenDRIVE.road{roadInd}.objects.object{repInd+objInd-1}.Attributes.zOffset = ...
    %                 num2str(zArray(repInd),'%.16e');
    %             end
    %           end
    %         end
    %         objInd = objInd + 1;
    %       end
    %     else
    %       fprintf(1,'Error in XODR file. Objects group exists, but there are no object structures within it.\n');
    %     end
    %   end


%% Plot the results (for debugging)?
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
if flag_do_plots
    % Check the structure
    ODRStruct = fcn_ParseXODR_checkXODR(ODRStruct);

    % Create a blank figure in which to plot the roads
    figure(fig_num)
    clf

    % Choose a minimum spacing of the points defining the road geometries
    minPlotGap = 0.2; % (m)

    flag_plot_road_geometry = [];

    % Call the plotting function
    fcn_ParseXODR_plotXODRinENU(ODRStruct,minPlotGap,flag_plot_road_geometry,fig_num);


end % Ends check if plotting

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

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



