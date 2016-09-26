function paramValue = Hybrid_adm_get_trajectory(tg,paramName)
%%  Get the trajectory properties under "Hybrid admittance controller"
%   By Long Wang, 2015/9/18
%%  paramName and paramValue include:
switch paramName
    case 'load trajectory'
        id = tg.getparamid('','LinInterpDesiredTraj');
        paramValue = tg.getparam(id);
    case 'trajectory speed' % [mm/s]
        id = tg.getparamid('','LinInterpTrajSpeed');
        paramValue = tg.getparam(id);
    case 'trajectory state'
        % trajectory state are defined and used in the embedded block
        % "Desired Trajectory/Linear Interp Trajectory Generator"
        %   1 -> moving toward starting position
        %   2 -> ready to execute
        %   3 -> running
        %   4 -> finished
        id = tg.getsignalid(...
            'Hybrid Position Force Admittance Control/Desired Trajectory/Linear Interp Trajectory Generator/Path Planning/p2');
        paramValue = tg.getsignal(id);
end
end