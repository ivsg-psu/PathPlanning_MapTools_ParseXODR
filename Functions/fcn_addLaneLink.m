function [editedPredecessorStruct,editedSuccessorStruct] = fcn_addLaneLink(predecessorStruct, successorStruct)
% This function adds <successor> or <predecessor> under <link>, then add
% this <link> to a <lane> element. 

% INPUTS:
% predecessorStruct: this is a MATLAB struct loaded from the predecessor road xodr file by fcn_RoadSeg_convertXODRtoMATLABStruct
% successorStruct: this is a MATLAB struct loaded from the successor road xodr file by fcn_RoadSeg_convertXODRtoMATLABStruct
% connectionType: this is either 'predecessor' or 'successor'. Format:
% string

% OUTPUTS:
% editedPredecessorStruct: the predecessor struct after being added <link>
% editedSuccessorStruct:  the successor struct after being added <link>

% Created by: Wushuang Bai
% Revision history:
% 20230423 first write of the code

%%%%%%%%%%%%%%%%%%%%%%predecessor road%%%%%%%%%%%%%%%%%%%%%%%%
predecessorLaneName = fieldnames(predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1});
if ~isempty(find(strcmp(predecessorLaneName,'left')))
predecessorLeftLaneNum = length(predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane);
for ii = 1:predecessorLeftLaneNum
    predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{ii}.link.successor.Attributes.id = ...
        successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{ii}.Attributes.id ;
end
end



if ~isempty(find(strcmp(predecessorLaneName,'right')))
predecessorRightLaneNum = length(predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane);
for ii = 1:predecessorRightLaneNum
    predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{ii}.link.successor.Attributes.id = ...
        successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{ii}.Attributes.id ;
end
end

%%%%%%%%%%%%%%%%%%%%%%successor road%%%%%%%%%%%%%%%%%%%%%%%%

successorLaneName = fieldnames(successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1});
if ~isempty(find(strcmp(successorLaneName,'left')))
successorLeftLaneNum = length(successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane);
for ii = 1:successorLeftLaneNum
    successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{ii}.link.predecessor.Attributes.id = ...
        predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.left.lane{ii}.Attributes.id ;
end
end

if ~isempty(find(strcmp(successorLaneName,'right')))
successorRightLaneNum = length(successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane);
for ii = 1:successorRightLaneNum
    successorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{ii}.link.predecessor.Attributes.id = ...
        predecessorStruct.OpenDRIVE.road{1}.lanes.laneSection{1}.right.lane{ii}.Attributes.id ;
end
end


editedPredecessorStruct = predecessorStruct;
editedSuccessorStruct = successorStruct;
end