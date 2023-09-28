function outputFilename = fcn_ParseXODR_convertODRstructToXODRFile(data,varargin)
% fcn_convertODRstructToXODRFile converts a MATLAB struct to a XODR file.
% This function is designed to facilitate the conversion of road network
% data from MATLAB struct format to the XODR file format.
%
% Input:
%   data: MATLAB structure you want to convert
%
% FORMAT:
%   myFilename = fcn_convertODRstructToXODRFile(data,varargin)
%
% INPUTS:
%   data: MATLAB structure containing road network data
%
% (optional)
%   varargin: Additional optional arguments, in string  
%             If given, it works as the file name.
%
% OUTPUTS:
%   myFilename: Name of the generated XODR file
%
% DEPENDENCIES:
%   struct2xml: Required function to convert struct to XML format
%
% EXAMPLES:
%   % Convert a sample road network structure to XODR format
%   myFilename = fcn_convertODRstructToXODRFile(roadNetwork);
%
% This function was written on Wushuang Bai
% Questions or comments? contact wxb41@psu.edu
%
% REVISION HISTORY:
%   20230927 - Initial creation of the function

% TO DO:
%   -- Allow user to specify file name.
%   -- Add error handling for invalid input structures.

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
    if nargin < 1 || nargin > 2
        error('Incorrect number of input arguments')
    end
    
    if isempty(varargin)
        % Define a filename based on the time to avoid accidentally overwriting previous files
        myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
    else
        myFilename = varargin{1};
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

% Write the XODR structure to an XML formatted file
struct2xml(data,myFilename);

% Move the output file so that it has an XODR file extension
movefile([myFilename '.xml'],[myFilename '.xodr']);
outputFilename = [myFilename,'.xodr'];

%% Any debugging?
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



end
