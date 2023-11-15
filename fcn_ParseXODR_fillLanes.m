function laneSection = fcn_ParseXODR_fillLanes(laneSection,laneKeyWord,numOfLanes,widthStruct, ...
    roadMarkStruct,speedStruct,shoulderFlag)

if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
if numOfLanes >= 2 % initialize empty lane sections 
    for ii = 2:numOfLanes
        laneSection.(laneKeyWord).lane{1,ii} = laneSection.(laneKeyWord).lane{1};
    end
end
end

if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
for ii = 1:numOfLanes
    % fill lane id
    if strcmp(laneKeyWord,'left')
        laneSection.(laneKeyWord).lane{1,ii}.Attributes.id = num2str(ii);
    elseif strcmp(laneKeyWord,'right')
        laneSection.(laneKeyWord).lane{1,ii}.Attributes.id = num2str(-ii);
    end    
    % fill lane type

        if 1==shoulderFlag && ii == numOfLanes
        laneSection.(laneKeyWord).lane{1,ii}.Attributes.type = 'shoulder';
        else
        laneSection.(laneKeyWord).lane{1,ii}.Attributes.type = 'driving';    
        end   
    % fill lane level
    laneSection.(laneKeyWord).lane{1,ii}.Attributes.level = 'false';
end
end

if strcmp(laneKeyWord,'center')
    laneSection.(laneKeyWord).lane.Attributes.type = 'none';
    laneSection.(laneKeyWord).lane.Attributes.level = 'false';
    laneSection.(laneKeyWord).lane.Attributes.id = '0';
end


if strcmp(laneKeyWord,'left') || strcmp(laneKeyWord,'right')
    for ii = 1:numOfLanes
        laneSection.(laneKeyWord).lane{1,ii}.width = widthStruct(ii);
        laneSection.(laneKeyWord).lane{1,ii}.roadMark = roadMarkStruct(ii);
        laneSection.(laneKeyWord).lane{1,ii}.speed = speedStruct(ii);
    end
end

if strcmp(laneKeyWord,'center')
    laneSection.(laneKeyWord).lane.roadMark = roadMarkStruct;
end

end