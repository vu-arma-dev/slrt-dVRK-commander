function Task_space_interp_set_goal(tg,det_p,det_quat,tf,varargin)
%%  By Long Wang, 2015/7/6
%   For set convenient, p => Incremental position
%   quat => absolute orientaion
%%  Parse the input
MotionMode= 'absolute';
CheckCompletion = 'no';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'MotionMode')
            MotionMode = propertyValue;
        elseif strcmp(propertyName,'CheckCompletion')
            CheckCompletion = propertyValue;
        end
    end
end
id_go = tg.getparamid('Task Space Trajectory Interpolation/go','Value');
tg.setparam(id_go,0);
%%  Set position
if strcmp(MotionMode,'absolute')
    p_f = det_p;
    quat_f = det_quat;
elseif strcmp(MotionMode,'relative')
    [p_cur,quat_cur] = Task_space_get_pose_cur(tg);
    p_f = p_cur + det_p;
    quat_row = quatmultiply(quat_cur',det_quat');
    quat_f = quat_row';
elseif strcmp(MotionMode,'tool frame')
    [p_cur,quat_cur] = Task_space_get_pose_cur(tg);
    R_cur = quat2rot(quat_cur);
    T_cur = [R_cur,p_cur;...
        0,0,0,1];
    p_des_wave = T_cur*[det_p;1];
    p_f = p_des_wave(1:3);
    quat_row = quatmultiply(quat_cur',det_quat');
    quat_f = quat_row';
end
id = tg.getparamid('Task Space Trajectory Interpolation/p_ref','Value');
tg.setparam(id,p_f);
%%  Set orientation
id = tg.getparamid('Task Space Trajectory Interpolation/quat_ref','Value');
tg.setparam(id,quat_f);
%%  Set time
id = tg.getparamid('Task Space Trajectory Interpolation/5th Order Polynomial and Slerp/tf','Value');
tg.setparam(id,tf);
%%  Set Go
tg.setparam(id_go,1);
%%  Check completion if selected
if strcmp(CheckCompletion,'yes')
    t_timeout = 15;
    fprintf('\nPSM 5th Poly Interp moving ... \n')
    t0 = tic;
    reverseStr = [];
    t_run = toc(t0);
    InLoop = 0;
    while(InLoop==0)
        while (Get_robot_status(tg,'motion5thPoly'))
            pause(0.05);
            msg = sprintf('%.2f seconds ... ',t_run);
            fprintf([reverseStr, msg]);
            reverseStr = repmat(sprintf('\b'), 1, length(msg));
            InLoop = 1;
        end
        t_run = toc(t0);
        if (t_run>t_timeout)&&(t_run>tf)
            fprintf('\nPSM failed to execute the desired 5th poly trajectory ...\n');
            pause;
        end
    end
    fprintf(' [ok].\n')
end
end