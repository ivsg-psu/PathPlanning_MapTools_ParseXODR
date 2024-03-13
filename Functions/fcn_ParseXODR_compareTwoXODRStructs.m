function structs_are_same = ...
    fcn_ParseXODR_compareTwoXODRStructs(...
    struct_1, ...
    struct_2, ...
    struct_template,...
    varargin)
%% fcn_ParseXODR_compareTwoXODRStructs
% compares two XODR structures relative to a template
%
% FORMAT:
%
% structs_are_same = ...
% fcn_ParseXODR_compareTwoXODRStructs(...
% struct_1, ...
% struct_2, ...
% struct_template,...
% {error_tolerance},...
% {flag_be_verbose},...
% {search_depth},...
% {fig_num})
%
% INPUTS:
%
%      struct_1: the first structure to compare
%
%      struct_2: the second structure to compare.
%
%      struct_template: a structure that acts as a template for both
%      inputs that defines which fields are compared for equality.
%      Specifically, the template is used to define which fields must 1) be
%      in both struct_1 and struct_2 AND 2) these fields and only these
%      fields must be equivalent. If either struct_1 or struct_2 are
%      missing any template fields, then the structures are not equivalent,
%      even if they are technically equal. Furhter if two structures are
%      exactly the same in the template fields, but not the same in
%      non-template fields, then they are considered equal - even if other
%      non-template fields are not the same.
%
%      (OPTIONAL INPUTS)
%
%      error_tolerance: the allowable difference in meters between position
%      specifications in one XODR file versus the other for the two
%      definitions to be considered equivalent. If not specified, default
%      is 0.1 meters (10 cm)
%
%      flag_be_verbose: set to 1 to print to the screen the comparisons
%
%      depth: current depth of the search (used in recursion)
%
%      fig_num: a figure number to plot the results.
%
% OUTPUTS:
%
%      structs_are_same: returns 1 if the structures are the same in either
%      all fields or the template fields.
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
% See the script: script_test_fcn_ParseXODR_compareTwoXODRStructs
% for a full test suite.
%
% This function was written on 2024_03_13 by S. Brennan using
% fcn_ParseXODR_compareTwoXODRStructs as a starter
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2024_03_13 - S. Brennan
% -- wrote the code

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==7 && isequal(varargin{end},-1))
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
        narginchk(3,7);

        % % Check the lane_centerlines_start input to have 1 column
        % fcn_DebugTools_checkInputsToFunctions(...
        %     lane_centerlines_start, '1column_of_numbers');
        %
        % % Check the lane_centerlines_end input to have 1 column and same
        % % number of rows as the start values
        % fcn_DebugTools_checkInputsToFunctions(...
        %     lane_centerlines_end, '1column_of_numbers',length(lane_centerlines_start(:,1)));


    end
end

% Does user want to specify error_tolerance?
error_tolerance = 0.1; % Default is 10 cm
if (4<= nargin)
    temp = varargin{1};
    if ~isempty(temp)
        error_tolerance = temp; 
    end
end

% Does user want to specify flag_be_verbose?
flag_be_verbose = 0; % Default is to have no template
variable_name = '';
if (5<= nargin)
    temp = varargin{2};
    if ~isempty(temp)
        if temp~=0
            flag_be_verbose = 1;
        else
            flag_be_verbose = 0;
        end
        if ischar(temp)
            variable_name = temp;
        end
    end
end

% Does user want to specify depth?
search_depth = 0; % Default is to have no depth
if (6<= nargin)
    temp = varargin{3};
    if ~isempty(temp)
        search_depth = temp;
    end
end


% Does user want to specify fig_num?
fig_num = []; %#ok<NASGU>
flag_do_plots = 0;
if (0==flag_max_speed) && (7<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp; %#ok<NASGU>
        flag_do_plots = 1;
    end
end


%% Solve for the circle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Need to test for line, arc, spiral


% Structures are the same until proven otherwise!
structs_are_same = true;

% Print leading tabs
if flag_be_verbose
    fcn_INTERNAL_printTabs(search_depth);
end

% is this a variable comparison, or a structure comparison?
if ~isstruct(struct_1) || ~isstruct(struct_2)
    % Print results
    if flag_be_verbose && (0==search_depth)
        fprintf(1,'\n\nONE INPUT IS NOT A STRUCTURE: \n');
        if ~isstruct(struct_1)
            fprintf(1,'Input 1 ');
            fcn_DebugTools_cprintf('*Red','<--- NOT A STRUCTURE\n');
        end
        if ~isstruct(struct_2)
            fprintf(1,'Input 2 ');
            fcn_DebugTools_cprintf('*Red','<--- NOT A STRUCTURE\n');
        end

        variable_name = cat(2,inputname(1),' versus ',inputname(2));
    end


    % This must be a variable comparison
    if ~isequal(struct_1, struct_2)
        structs_are_same = false;
    end

    if flag_be_verbose
        fprintf(1,'Checking variable: %s ',variable_name);
        if structs_are_same
            fprintf(1,'<--- agree\n');
        else
            fcn_DebugTools_cprintf('*Red','<--- DO NOT MATCH\n');
        end
    end

else
    % This is a structure

    % Use the template to define which fields to check
    reference_fields = fieldnames(struct_template);

    % List what is being used as reference
    if flag_be_verbose && (0==search_depth)
        fprintf(1,'\n\nCHECKING ENTIRE STRUCTURE: using template fields. ');
    elseif flag_be_verbose
        fprintf(1,'Checking structure: %s ',variable_name);
    end

    % Are the two structures absolutely identical?
    % Loop through subfields to check each.
    if flag_be_verbose
        fprintf(1,'<--Structures are not absolutely identical.\n');
        fcn_INTERNAL_printTabs(search_depth);
        fprintf(1,'Iterating through fields to find difference:\n');
    end

    % Loop through reference fields to check which are in agreement
    for ith_field = 1:length(reference_fields)
        field_name = reference_fields{ith_field};

        % Check that field exists in both structures
        if ~isfield(struct_1,field_name) || ~isfield(struct_2,field_name)
            if ~isfield(struct_1,field_name)
                fcn_INTERNAL_printTabs(search_depth);
                fprintf(1,'Field: %s ',field_name);
                fcn_DebugTools_cprintf('*Red','<--- IN TEMPLATE BUT DOES NOT EXIST IN STRUCTURE 1 \n');
            end
            if ~isfield(struct_2,field_name)
                fcn_INTERNAL_printTabs(search_depth);
                fprintf(1,'Field: %s ',field_name);
                fcn_DebugTools_cprintf('*Red','<--- IN TEMPLATE BUT DOES NOT EXIST IN STRUCTURE 2 \n');
            end
            structs_are_same = false;

        else
            % Both structures have field that is searched for in reference - check them
            if length(struct_1.(field_name)) ~= length(struct_2.(field_name))
                fcn_INTERNAL_printTabs(search_depth);
                fprintf(1,'Field: %s ',field_name);
                fcn_DebugTools_cprintf('*Red','<--- FIELDS HAVE DIFFERENT LENGTHS \n');
                structs_are_same = false;

            else

                % Check if the input is a cell array. If so, we need to
                % pull out the data from this carefully. The template
                % will only every have 1 input value. NOTE: this
                % assumes that the ordering is the same on the fields -
                % this might not always be true.
                if iscell(struct_template.(field_name))
                    % Loop through the structures
                    for ith_iteration = 1:length(struct_1.(field_name))

                        input1 = struct_1.(field_name){ith_iteration};
                        input2 = struct_2.(field_name){ith_iteration};
                        input_template = struct_template.(field_name){1};

                        if flag_be_verbose
                            % Verbose mode
                            fcn_INTERNAL_printTabs(search_depth);
                            fprintf(1,'Field: %s \n',field_name);
                            sustructures_are_same = fcn_ParseXODR_compareTwoXODRStructs(...
                                input1, ...
                                input2, ...
                                input_template,...
                                error_tolerance,...
                                field_name,...
                                search_depth+1,...
                                []);
                        else
                            % NOT verbose
                            sustructures_are_same = fcn_ParseXODR_compareTwoXODRStructs(...
                                input1, ...
                                input2, ...
                                input_template,...
                                error_tolerance,...
                                0,...
                                search_depth+1,...
                                []);

                        end % Ends if statement on verbose


                        if ~sustructures_are_same
                            structs_are_same = false;
                        end
                    end % Ends loop through cells
                else

                    % NOT Cell arrays
                    input1 = struct_1.(field_name);
                    input2 = struct_2.(field_name);
                    input_template = struct_template.(field_name);

                    if flag_be_verbose
                        % Verbose mode
                        fcn_INTERNAL_printTabs(search_depth);
                        fprintf(1,'Field: %s \n',field_name);
                        sustructures_are_same = fcn_ParseXODR_compareTwoXODRStructs(...
                            input1, ...
                            input2, ...
                            input_template,...
                            error_tolerance,...
                            field_name,...
                            search_depth+1,...
                            []);
                    else
                        % NOT verbose
                        sustructures_are_same = fcn_ParseXODR_compareTwoXODRStructs(...
                            input1, ...
                            input2, ...
                            input_template,...
                            error_tolerance,...
                            0,...
                            search_depth+1,...
                            []);

                    end % Ends if statement on verbose


                    if ~sustructures_are_same
                        structs_are_same = false;
                    end
                end % Ends if statement checking if cell arrays
            end % Ends if statement checking if lengths are same
        end % Ends if statement checking if both have field we are looking for

    end % Ends looping through fields
end % Ends if statement checking of both are structures


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
    % Not implemented yet
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

%% fcn_INTERNAL_printTabs
function fcn_INTERNAL_printTabs(search_depth)
for ith_tab = 1:search_depth
    fprintf(1,'\t');
end % Ends fcn_INTERNAL_printTabs
end

