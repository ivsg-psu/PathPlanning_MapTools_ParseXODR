    [S,X,Y] = fcn_extractCenterLine('testTrack_outerTrack.xodr');

    S(end+1) = S(end) + 16.6346;
    X(end+1) = X(1) ;
    Y(end+1) = Y(1) ;



    %%
    data = readtable(['C:\Users\ccctt\OneDrive - The Pennsylvania State University\Documents' ...
        '\GitHub\TrafficSimulators_Project_SUMOSimulationForADSProject\maps\TestENUMap\result.csv']);
    data = fcn_addStation(data);
    vehdata = fcn_getAVData(data,'f_0.10',11);    
    [xnew,ynew] = fcn_coorOffset(X,Y,290.82,209.92);

    %%
    figure();

    plot(xnew,ynew);
    hold on;
    plot(vehdata.vehicle_x,vehdata.vehicle_y,'--');
    


    %%
    tic;
    for ii = 1:height(data)
    point = [data.vehicle_x(ii), data.vehicle_y(ii)];
    pathXY = [xnew,ynew];
    flag_snap_type = 1;

    [closest_path_point,s_coordinate,first_path_point_index,second_path_point_index,percent_along_length,distance_real,distance_imaginary] = ...
        fcn_Path_snapPointOntoNearestPath(point, pathXY,flag_snap_type);
    
    data.snapStation(ii) = s_coordinate;
    end
    
    toc;

    
    temp = data.totalStation - data.snapStation; 
    figure()
    plot(temp); 
%% test snaping ending stations 

    point = [veh1.vehicle_x(908), veh1.vehicle_y(908)];
    pathXY = [xnew,ynew];
    flag_snap_type = 1;
    
    fignum = 111;
    [closest_path_point,s_coordinate,first_path_point_index,second_path_point_index,percent_along_length,distance_real,distance_imaginary] = ...
        fcn_Path_snapPointOntoNearestPath(point, pathXY,flag_snap_type,fignum);
    fprintf(1,['Figure: %d,\n\t\t Closest point is: %.2f %.2f \n' ...
        '\t\t Matched to the path segment given by indices %d and %d, \n' ...
        '\t\t S-coordinate is: %.2f, \n' ...
        '\t\t percent_along_length is: %.2f\n' ...
        '\t\t real distance is: %.2f\n, ' ...
        '\t\t imag distance is %.2f\n, '],...
        fignum, closest_path_point(1,1),closest_path_point(1,2),...
        first_path_point_index,second_path_point_index, ...
        s_coordinate, percent_along_length,...
        distance_real,distance_imaginary);


    
    

