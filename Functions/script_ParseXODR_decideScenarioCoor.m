fig_num = 2343;
figure(fig_num);
clf;

[ObjectClusterNames,ApplicationTypeStrings] = fcn_LoadWZ_nameObjectClusters;

% FORMAT: [flags_whichIsSelected] = fcn_LoadWZ_findSelectedTraces(TraceNames,cell_string_array_to_select,cell_string_array_to_avoid)
isPlotted = fcn_LoadWZ_findSelectedTraces(ObjectClusterNames,{'Scenario_1_1'},{});

application_string = 'AlignedDesign';

N_ObjectClusters = length(ObjectClusterNames);
for ith_objectCluster = 1:N_ObjectClusters
    if isPlotted(ith_objectCluster)
        objectClusterName = ObjectClusterNames{ith_objectCluster};
        objectCluster = fcn_LoadWZ_loadObjectCluster(objectClusterName, application_string, 1, fig_num);
        title(sprintf('Object cluster %.0d: %s',ith_objectCluster, objectClusterName),'Interpreter','none');

    end
end
set(gca,'ZoomLevel',19.5,'MapCenter',[40.863330947182654 -77.832394523710860]);
title(sprintf('All Scenario_1_1 object clusters defined for %s',application_string),'Interpreter','none');

