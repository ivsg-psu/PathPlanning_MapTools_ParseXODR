function [roads,new_traversal] = fcn_ParseXODR_fillPlanView(roads,roadCenterLine,interval)


input_traversal = fcn_Path_convertPathToTraversalStructure(roadCenterLine);
%interval = 10; % default resampling interval is set to 10 meters; 
new_stations    = (0:interval:input_traversal.Station(end))';
new_traversal = fcn_Path_newTraversalByStationResampling(input_traversal, new_stations);
new_traversal.segmentLength = diff(new_traversal.Station);


% write the new_traversal into open drive struct 
for ii = 1:length(new_traversal.segmentLength)
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.hdg = num2str(real(new_traversal.Yaw(ii)));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.length =num2str(new_traversal.segmentLength(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.s = num2str(new_traversal.Station(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.x = num2str(new_traversal.X(ii));
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.Attributes.y = num2str(new_traversal.Y(ii));    
    roads.OpenDRIVE.road{1}.planView.geometry{ii}.line = struct; 
end
% update total length of the road
roads.OpenDRIVE.road{1}.Attributes.length = new_traversal.Station(end);
end