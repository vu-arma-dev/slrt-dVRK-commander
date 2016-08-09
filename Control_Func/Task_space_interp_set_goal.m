function Task_space_interp_set_goal(tg,det_p,det_quat,tf,varargin)
%%  By Long Wang, 2015/7/6
%   For set convenient, p => Incremental position
%   quat => absolute orientaion
%%  Parse the input
MotionMode= 'absolute';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'MotionMode')
            MotionMode = propertyValue;
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
end