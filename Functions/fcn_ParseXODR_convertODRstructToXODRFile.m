function outputFilename = fcn_ParseXODR_convertODRstructToXODRFile(XODR_structure,varargin)
%% fcn_convertODRstructToXODRFile converts a MATLAB struct to a XODR file.
% Converts a specialized MATLAB struct format compliant with ASAM OpenDRIVE
% to an XODR file.
% 
% FORMAT:
%
%       outputFilename = fcn_ParseXODR_convertODRstructToXODRFile(XODR_structure,{filename},{fig_num})
%
% INPUTS:
%
%      XODR_structure: MATLAB structure containing road network structure
%
%      (OPTIONAL INPUTS)
% 
%      filename: the name of the XODR file to create. If left empty, a
%      filename is auto-generated based on the date. The filename is
%      entered without the XODR extension.
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      outputFilename: the resulting file name, with XODR extension
%
% DEPENDENCIES:
%
%      struct2xml: Required function to convert struct to XML format
%
% EXAMPLES:
%
%      See script_test_fcn_ParseXODR_convertODRstructToXODRFile.m for a comprehensive test
%      suite.
%
% This function was originally written by Wushuang Bai, on 2023_09_27
% It is currently maintained by S. Brennan.
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_09_27 - W. Bai.
% -- Added initial code structure
% 2024_03_10 - S. Brennan
% -- reformatted to standard template


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==3 && isequal(varargin{end},-1))
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
        narginchk(1,3);

        % % Check the projection_vector input to be length greater than or equal to 1
        % fcn_DebugTools_checkInputsToFunctions(...
        %     input_vectors, '2or3column_of_numbers');

    end
end


% Does user want the output file name to be auto-generated?
if nargin == 1 || isempty(varargin{1})
    % Define a filename based on the time to avoid accidentally overwriting previous files
    current_time = datetime('now','InputFormat','yyyy-MM-dd HH:mm:ss.SSS');
    current_time.Format = 'yyyy_MM_dd_HH_mm_ss_SSS';
    filename = ['testXODR_' char(current_time)];
end


% Does user want to specify the filename?
if nargin >= 2
    temp = varargin{1};
    if ~isempty(temp)
        filename = varargin{1};
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) && (3<= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end

%% Main
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Write the XODR structure to an XML formatted file
struct2xml(XODR_structure,filename);

% Move the output file so that it has an XODR file extension
movefile([filename '.xml'],[filename '.xodr']);
outputFilename = [filename,'.xodr'];


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

    % Create a blank figure in which to plot the roads
    figure(fig_num)
    clf

    % Choose a minimum spacing of the points defining the road geometries
    minPlotGap = 0.2; % (m)

    flag_plot_road_geometry = [];

    % Call the plotting function
    fcn_ParseXODR_plotXODRinENU(XODR_structure,minPlotGap,flag_plot_road_geometry,fig_num);

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

