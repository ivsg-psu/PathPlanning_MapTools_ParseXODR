function fileName = fcn_modifyLaneWidths(driving_lane_width,shoulder_width,filePath)
% This function modifies the widths of driving lanes and shoulder lanes
% in an OpenDRIVE .xodr file.
%
% Inputs:
%   shoulder_width: the new width for the shoulder lanes.
%   driving_lane_width: the new width for the driving lanes.
%   filepath: the path to the .xodr file.
%
% Outputs:
%   fileName: the output xodr file name;
% 
% Author: Wushuang Bai
% Revision history:
% 20230606 first write of the code
% 20230607 added comments

% Load the XML file using xml2struct_fex28518 function.
% This function converts the XML file into a MATLAB struct.
roadData = fcn_RoadSeg_convertXODRtoMATLABStruct(filePath);

% Get all 'laneSection' elements from the struct.
% Each laneSection represents a segment of the road that has a constant
% number of lanes.
laneSections = roadData.OpenDRIVE.road{1}.lanes.laneSection;

% Iterate over all laneSections in the struct.
for i = 1:numel(laneSections)
    laneSection = laneSections{i};

    % Check if this laneSection has left lanes.
    if isfield(laneSection, 'left')
        % Get all left lanes from this laneSection.
        leftLanes = laneSection.left.lane;

        % Iterate over all left lanes in this laneSection.
        for j = 1:numel(leftLanes)
            lane = leftLanes{j};

            % Check the type of the lane and modify its width accordingly.
            if strcmp(lane.Attributes.type, 'driving')
                lane.width.Attributes.a = num2str(driving_lane_width);
            elseif strcmp(lane.Attributes.type, 'shoulder')
                lane.width.Attributes.a = num2str(shoulder_width);
            end

            % Update the leftLanes array with the modified lane.
            leftLanes{j} = lane;
        end

        % Update the laneSection with the modified left lanes.
        laneSection.left.lane = leftLanes;
    end

    % Repeat the process for right lanes.
    if isfield(laneSection, 'right')
        rightLanes = laneSection.right.lane;
        for j = 1:numel(rightLanes)
            lane = rightLanes{j};
            if strcmp(lane.Attributes.type, 'driving')
                lane.width.Attributes.a = num2str(driving_lane_width);
            elseif strcmp(lane.Attributes.type, 'shoulder')
                lane.width.Attributes.a = num2str(shoulder_width);
            end
            rightLanes{j} = lane;
        end
        laneSection.right.lane = rightLanes;
    end

    % Update the laneSections array with the modified laneSection.
    laneSections{i} = laneSection;
end

% Update the struct with the modified laneSections.
roadData.OpenDRIVE.road{1}.lanes.laneSection = laneSections;

% Write the modified struct back to the XML file
ODRStruct = fcn_RoadSeg_XODRSegmentChecks(roadData);
myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
% Write the XODR structure to an XML formatted file
struct2xml(ODRStruct,myFilename)
% Move the output file so that it has an XODR file extension
movefile([myFilename '.xml'],[myFilename '.xodr'])
% output file name
fileName = myFilename ;

end
