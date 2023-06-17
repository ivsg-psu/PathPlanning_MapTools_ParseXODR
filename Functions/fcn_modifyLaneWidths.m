function fileName = fcn_modifyLaneWidths(road_num, lane_ID, lane_width, lane_sOffset, filePath)
% This function modifies the widths of a specified lane in an OpenDRIVE .xodr file.
%
% Inputs:
%   road_num: the ID of the road you want to modify, integer.
%   lane_ID: the ID of the lane you want to modify, integer.
%   lane_width: the new width for the specified lane, float.
%   filePath: the path to the .xodr file, string.
%
% Outputs:
%   fileName: the output xodr file name, string.

% For more info, see https://www.asam.net/index.php?eID=dumpFile&t=f&f=3495&token=56b15ffd9dfe23ad8f759523c806fc1f1a90a0e8
% Author: Wushuang Bai
% Revision history:
% 20230606 first write of the code
% 20230607 added comments
% 20230615 added feature to modify lane width as per station

% This function converts the XML file into a MATLAB struct.
roadData = fcn_RoadSeg_convertXODRtoMATLABStruct(filePath);

% Get all 'laneSection' elements from the struct.
% Each laneSection represents a segment of the road that has a constant
% number of lanes.
laneSections = roadData.OpenDRIVE.road{road_num}.lanes.laneSection;

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
            % Check the ID of the lane and modify its width if it matches.
            if strcmp(lane.Attributes.id,num2str(lane_ID))
                if 0 == lane_sOffset
                    lane.width.Attributes.a = num2str(lane_width);
                else
                    temp = lane.width;
                    lane.width = [];
                    lane.width{1} = temp;
                    lane.width{2}.Attributes.a = num2str(lane_width);
                    lane.width{2}.Attributes.b = num2str(0);
                    lane.width{2}.Attributes.c = num2str(0);
                    lane.width{2}.Attributes.d = num2str(0);
                    lane.width{2}.Attributes.sOffset = num2str(lane_sOffset);
                end
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
            if strcmp(lane.Attributes.id,num2str(lane_ID))
                if 0 == lane_sOffset
                    lane.width.Attributes.a = num2str(lane_width);
                else
                    temp = lane.width;
                    lane.width = [];
                    lane.width{1} = temp;
                    lane.width{2}.Attributes.a = num2str(lane_width);
                    lane.width{2}.Attributes.b = num2str(0);
                    lane.width{2}.Attributes.c = num2str(0);
                    lane.width{2}.Attributes.d = num2str(0);
                    lane.width{2}.Attributes.sOffset = num2str(lane_sOffset);
                end
            end

            rightLanes{j} = lane;
        end
        laneSection.right.lane = rightLanes;
    end

    % Update the laneSections array with the modified laneSection.
    laneSections{i} = laneSection;

end


% Update the struct with the modified laneSections.
roadData.OpenDRIVE.road{road_num}.lanes.laneSection = laneSections;

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
