function structs_are_same = ...
    fcn_ParseXODR_compareTwoStructs(...
    struct_1, ...
    struct_2, ...
    varargin)
%% fcn_ParseXODR_compareTwoStructs
% compares two structures
%
% FORMAT:
%
% structs_are_same = ...
% fcn_ParseXODR_compareTwoStructs(...
% struct_1, ...
% struct_2, ...
% {template_struct},...
% {flag_be_verbose},...
% {search_depth},...
% {fig_num})
%
% INPUTS:
%
%       struct_1: the first structure to compare
% 
%       struct_2: the second structure to compare.
%
%      (OPTIONAL INPUTS)
%
%      template_struct: a structure that acts as a template for both
%      inputs. The template is used to define which fields must be in
%      both struct_1 and struct_2 AND which fields must match. If either
%      struct_1 or struct_2 are missing any template fields, then the
%      structures are not equivalent, even if they are technically equal.
%      And if two structures are exactly the same in the template fields,
%      they are considered equal even if other non-template fields are
%      not the same.
% 
%      flag_be_verbose: set to 1 to show which portions of structures are
%      same and different
% 
%      depth: current depth of the search
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
% See the script: script_test_fcn_ParseXODR_compareTwoStructs
% for a full test suite.
%
% This function was written on 2024_03_12 by S. Brennan
% Questions or comments? sbrennan@psu.edu 

% Revision history:
% 2024_03_12 - S. Brennan
% -- wrote the code

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==6 && isequal(varargin{end},-1))
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
        narginchk(2,6);

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

% Does user want to specify station_tolerance?
flag_use_template = 0; % Default is to have no template
if (3<= nargin) 
    temp = varargin{1};
    if ~isempty(temp)
        struct_template = temp;
        flag_use_template = 0; 
    end
end

% Does user want to specify flag_be_verbose?
flag_be_verbose = 0; % Default is to have no template
if (4<= nargin) 
    temp = varargin{2};
    if ~isempty(temp)
        flag_be_verbose = temp;
    end
end

% Does user want to specify depth?
search_depth = 0; % Default is to have no depth
if (5<= nargin) 
    temp = varargin{3};
    if ~isempty(temp)
        search_depth = temp;
    end
end


% Does user want to specify fig_num?
fig_num = []; %#ok<NASGU>
flag_do_plots = 0;
if (0==flag_max_speed) && (6<= nargin) 
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

% Structures are the same until proven otherwise!
structs_are_same = true;

% Grab input variable names
input1_name = inputname(1);
input2_name = inputname(2);

% Print leading tabs
if flag_be_verbose
    fcn_INTERNAL_printTabs(search_depth);
end

% is this a variable comparison, or a structure comparison?
if ~isstruct(struct_1) || ~isstruct(struct_2)
    % This must be a variable comparison
    if ~isequal(struct_1, struct_2)
        structs_are_same = false;
    end

    % Print results
    if flag_be_verbose
        fprintf(1,'Checking %s ',input1_name);
        if structs_are_same
            fprintf(1,'<--- agree\n');
        else
            fprintf(1,'<--- DISAGREE\n');
        end
    end

else
    % This is a structure

    % Grab the fields in both structures
    fields_in_1 = fieldnames(struct_1);
    fields_in_2 = fieldnames(struct_2);

    % Are the two structures absolutely identical?
    if (flag_use_template == 0) && (isequal(struct_1, struct_2))
        if flag_be_verbose
            fprintf(1,'Entire structure is absolutely identical\n ');
        end
    else
        % They are not absolutely identical - loop through subfields to
        % check each.

        % Define which reference structure to use
        if flag_use_template == 1
            % Use the template
            reference_fields = fieldnames(struct_template);
        else
            % Use the common fields
            reference_fields = intersect(fields_in_1,fields_in_2);
        end

        % List what is being used as reference
        if flag_be_verbose && (0==search_depth)
            fprintf(1,'Checking structures against ');
            if flag_use_template
                fprintf(1,'template fields.\n');
            else
                fprintf(1,'common fields.\n');
            end
            fcn_INTERNAL_printTabs(search_depth);
        end

        % Loop through reference fields to check which are in agreement
        for ith_field = 1:length(reference_fields)
            field_name = reference_fields{ith_field};
            if flag_be_verbose
                fcn_INTERNAL_printTabs(search_depth+1);
                fprintf(1,'Field %s \n',field_name);
            end

            sustructures_are_same = fcn_ParseXODR_compareTwoStructs(...
                struct_1.(field_name), ...
                struct_2.(field_name), ...
                [],...
                flag_be_verbose,...
                search_depth+1,...
                []);
            if ~sustructures_are_same
                structs_are_same = false;
            end
        end

        % Check fields that are not in agreement?
        if 1==0  % flag_use_template
            % Check struct_1
            sustructures_are_same = fcn_INTERNAL_checkSubstructure(struct_1, reference_fields, input1_name, flag_be_verbose, search_depth);
            if ~sustructures_are_same
                structs_are_same = false;
            end

            % Check struct_2
            sustructures_are_same = fcn_INTERNAL_checkSubstructure(struct_2, reference_fields, input2_name, flag_be_verbose, search_depth);
            if ~sustructures_are_same
                structs_are_same = false;
            end
        end

    end

end

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

%% fcn_INTERNAL_checkSubstructure
function sustructures_are_same = fcn_INTERNAL_checkSubstructure(input_name, reference_fields, flag_be_verbose,search_depth)

if flag_be_verbose
    fprintf(1,'Checking %s for structure 1\n',input_name);
    fcn_INTERNAL_printTabs(search_depth);
end

% Loop through common reference fields in 1
for ith_field = 1:length(reference_fields)
    field_name = reference_fields{ith_field};
    sustructures_are_same = fcn_ParseXODR_compareTwoStructs(...
        struct_1.(field_name), ...
        struct_2.(field_name), ...
        template_struct.(field_name),...
        flag_be_verbose,...
        search_depth+1,...
        fig_num);
end
end % Ends fcn_INTERNAL_checkSubstructure