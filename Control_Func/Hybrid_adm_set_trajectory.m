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
    case 'trajectory speed' % [mm/s]
        id = tg.getparamid('','LinInterpTrajSpeed');
    case 'trajectory state'
        % trajectory state are defined and used in the embedded block
        % "Desired Trajectory/Linear Interp Trajectory Generator"
        %   1 -> moving toward starting position
        %   2 -> ready to execute
        %   3 -> running
        %   4 -> finished
        if strcmp(paramValue,'ready')
            setState = 2;
        elseif strcmp(paramValue,'go')
            setState = 4;
        end
        paramValue = setState;
        id = tg.getparamid(...
            'Hybrid Position Force Admittance Control/Desired Trajectory/PathState',...
            'Value');
end
tg.setparam(id,paramValue);
end