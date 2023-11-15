function roads= fcn_ParseXODR_fillRoadType(roads,speedLimit)
roads.OpenDRIVE.road{1}.type.Attributes.s = '0';
roads.OpenDRIVE.road{1}.type.Attributes.type = 'town';
roads.OpenDRIVE.road{1}.type.speed.Attributes.max = num2str(speedLimit);
roads.OpenDRIVE.road{1}.type.speed.Attributes.unit = 'mph';


end