function sectionStruct = fcn_ParseXODR_createStructForLaneSection(numOfLeftLane, ...
    numOfRightLane,speedlimit)

widthStruct.Attributes.a = '3.65';
widthStruct.Attributes.b = '0';
widthStruct.Attributes.c = '0';
widthStruct.Attributes.d = '0';
widthStruct.Attributes.sOffset = '0';


markStruct.Attributes = struct();
markStruct.Attributes.color = 'white';
markStruct.Attributes.laneChange = 'none';
markStruct.Attributes.material = 'standard';
markStruct.Attributes.sOffset = '0';
markStruct.Attributes.type = 'solid';
markStruct.Attributes.weight = 'standard';
markStruct.Attributes.width = '0.125';


speedStruct.Attributes = struct();
speedStruct.Attributes.max = num2str(speedlimit);
speedStruct.Attributes.sOffset = '0';
speedStruct.Attributes.unit = 'mph';

if numOfRightLane>=1

rightWidthStruct(1:numOfRightLane) = widthStruct; 
rightMarkStruct(1:numOfRightLane) = markStruct;
rightSpeedStruct(1:numOfRightLane) = speedStruct;

sectionStruct.rightWidthStruct = rightWidthStruct;
sectionStruct.rightMarkStruct = rightMarkStruct;
sectionStruct.rightSpeedStruct = rightSpeedStruct;
end

if numOfLeftLane>=1
leftWidthStruct(1:numOfLeftLane) = widthStruct; 
leftMarkStruct(1:numOfLeftLane) = markStruct;
leftSpeedStruct(1:numOfLeftLane) = speedStruct;

sectionStruct.leftWidthStruct = leftWidthStruct;
sectionStruct.leftMarkStruct = leftMarkStruct;
sectionStruct.leftSpeedStruct= leftSpeedStruct;

end

% Define the center lane marking parameters
sectionStruct.centerMarkStruct(1).Attributes = struct();
sectionStruct.centerMarkStruct(1).Attributes.color = 'yellow';
sectionStruct.centerMarkStruct(1).Attributes.laneChange = 'none';
sectionStruct.centerMarkStruct(1).Attributes.material = 'standard';
sectionStruct.centerMarkStruct(1).Attributes.sOffset = '0';
sectionStruct.centerMarkStruct(1).Attributes.type = 'solid solid';
sectionStruct.centerMarkStruct(1).Attributes.weight = 'standard';
sectionStruct.centerMarkStruct(1).Attributes.width = '0.125';


if numOfRightLane>=2
for ii = 1:numOfRightLane-1
rightMarkStruct(ii).Attributes.type = 'broken';
end
end

if numOfLeftLane>=2
for ii = 1:numOfLeftLane-1
leftMarkStruct(ii).Attributes.type = 'broken';
end
end






end