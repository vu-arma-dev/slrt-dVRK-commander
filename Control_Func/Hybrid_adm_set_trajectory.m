function Hybrid_adm_set_trajectory(tg,paramName,paramValue)
%%  Set the trajectory properties under "Hybrid admittance controller"
%   By Long Wang, 2015/9/18
%%  paramName and paramValue include:
switch paramName
    case 'load trajectory'
        path_file_name = paramValue;
        Config_mat_path = [getenv('PSMCMD'),'/Config_Mat'];
        pathdata = load([Config_mat_path,'/',path_file_name]);
        paramValue = pathdata.PATH.DATA;
        id = tg.getparamid('','LinInterpDesiredTraj');
        tg.setparam(id,paramValue);
    case 'trajectory speed' % [mm/s]
        id = tg.getparamid('','LinInterpTrajSpeed');
        tg.setparam(id,paramValue);
    case 'ready time'
        Traj_block_name = ...
            'Hybrid Position Force Admittance Control/Desired Trajectory';
        id_ready_time = tg.getparamid(...
            [Traj_block_name,'/Linear Interp Trajectory Generator/READY_TIME'],...
            'Value');
        tg.setparam(id_ready_time,paramValue);
    case 'trajectory state'
        % trajectory state are defined and used in the embedded block
        % "Desired Trajectory/Linear Interp Trajectory Generator"
        %   1 -> moving toward starting position
        %   2 -> ready to execute
        %   3 -> running
        %   4 -> finished
        Traj_block_name = ...
            'Hybrid Position Force Admittance Control/Desired Trajectory';
        id_state = tg.getparamid(...
            [Traj_block_name,'/PathState'],...
            'Value');
        id_pause = tg.getparamid(...
            [Traj_block_name,'/Linear Interp Trajectory Generator/pause'],...
            'Value');
        if strcmp(paramValue,'ready')
            setState = 1;
            tg.setparam(id_state,setState );
            pause(0.05);
            setState = 2;
            tg.setparam(id_state,setState);
        elseif strcmp(paramValue,'go')
            setState = 4;
            tg.setparam(id_state,setState);
        elseif strcmp(paramValue,'stop')
            setState = 0;
            tg.setparam(id_state,setState);
        elseif strcmp(paramValue,'pause')
            setPause = 1;
            tg.setparam(id_pause,setPause);
        elseif strcmp(paramValue,'resume')
            setPause = 0;
            tg.setparam(id_pause,setPause);
        end
end
end