function flag_good_match = fcn_ParseXODR_checkStructureFields(structure_to_check, required_fields, optional_fields, varargin)
%% fcn_ParseXODR_checkStructureFields
% checks whether the fields in an input structure match required fields
% and/or expected fields
%
% FORMAT:
%
%       flag_good_match = fcn_ParseXODR_checkStructureFields(structure_to_check, required_fields, optional_fields, varargin)
%
% INPUTS:
%
%      structure_to_check: a structure to test
%
%      required_fields: fields that are required,
%
%      optional_fields: fields that are allowed, but optional
%
%      (OPTIONAL INPUTS)
%
%      flag_verbose: set to 1 to print out results, 0 otherwise (default is
%      0)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      flag_good_match: returns 1 if all the fields of the structure
%      include the required_fields or are contained in optional_fields.
%      Returns 0 otherwise.
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script: script_test_fcn_ParseXODR_checkStructureFields.m for a
%       full test suite.
%
% This function was written by S. Brennan and is maintained by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
%     2024_03_18 - S. Brennan
%     -- wrote the code

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==5 && isequal(varargin{end},-1))
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
        narginchk(3,5);

        % % Check the left_or_right_or_center input to be a string
        % if ~isstring(left_or_right_or_center) &&  ~ischar(left_or_right_or_center)
        %     error('The left_or_right_or_center input must be a string or character type');
        % end

    end
end

% Does user want to specify flag_verbose?
flag_verbose = 0;
if (4<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        flag_verbose = temp;
    end
end

% Does user want to specify fig_num?
fig_num = []; % Default is to have no figure
flag_do_plots = 0;
if (0==flag_max_speed) && (5<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
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

flag_good_match = 1;

if flag_do_debug || flag_verbose
    fprintf(1,'\n\n');
end


current_fields = fieldnames(structure_to_check);
[~,in_required,in_tested] = setxor(required_fields,current_fields);

% Check if any required fields are missing
if ~isempty(in_required)
    flag_good_match = 0;

    if flag_do_debug || flag_verbose
        fprintf(1,'Tested structure is missing one or more of the following required fields:\n');
        fprintf(1,'Expected:\n');
        for ith_field = 1:length(required_fields)
            fprintf(1,'\t%s\n',required_fields{ith_field});
        end
        fprintf(1,'Missing:\n');
        for ith_field = 1:length(in_required)
            bad_index = in_required(ith_field);
            unexpected_fieldName = required_fields{bad_index};
            fprintf(1,'\t%s\n',unexpected_fieldName);
        end
    end
else
    if flag_do_debug || flag_verbose
        fprintf(1,'Tested structure has all required fields.\n');
    end
end

% Check optional fields
if ~isempty(in_tested)
    % Fill in extra fields
    extra_fields = cell(length(in_tested),1);
    for ith_copy = 1:length(in_tested)
        index_to_copy = in_tested(ith_copy);
        extra_fields{ith_copy} = current_fields{index_to_copy};
    end

    % Check these extra fields against allowable ones
    [~,~,outside_optional] = setxor(optional_fields,extra_fields);
    if ~isempty(outside_optional)
        flag_good_match = 0;
        if flag_do_debug || flag_verbose

            fprintf(1,'Tested structure has a field that is outside both the required and the optional fields:\n');
            fprintf(1,'Allowable optional fields:\n');
            for ith_field = 1:length(optional_fields)
                fprintf(1,'\t%s\n',optional_fields{ith_field});
            end
            fprintf(1,'Detected outside the optional fields:\n');
            if flag_do_debug || flag_verbose
                for ith_field = 1:length(outside_optional)
                    bad_index = outside_optional(ith_field);
                    unexpected_fieldName = extra_fields{bad_index};
                    fprintf(1,'\t%s\n',unexpected_fieldName);
                end
            end
        end
    else
        if flag_do_debug || flag_verbose
            fprintf(1,'Tested structure has optional fields that are all within allowable optional fields.\n');
        end

    end % Ends check if outside_optional fields found
else
    if flag_do_debug || flag_verbose
        fprintf(1,'Tested structure has no optional fields.\n');
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
    temp_h = figure(fig_num);
    flag_rescale_axis = 0;
    if isempty(get(temp_h,'Children'))
        flag_rescale_axis = 1;
    end
    %
    % hold on;
    % grid on;
    % axis equal
    %
    %
    % % Set up labels and title
    % xlabel('East (m)')
    % ylabel('North (m)')
    % title('XY view')
    %
    %
    % % Nothing to plot
    %
    % Make axis slightly larger?
    if flag_rescale_axis
        temp = axis;
        %     temp = [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2))];
        axis_range_x = temp(2)-temp(1);
        axis_range_y = temp(4)-temp(3);
        percent_larger = 0.3;
        axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);
    end


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
