function Hybrid_admitance_set_goal_pose(tg,det_p,det_quat,varargin)
%%  By Long Wang, 2015/7/6
%   For set convenient, p => Incremental position
%   quat => absolute orientaion
%%  Parse the input
MotionMode= 'absolute';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'Motion Mode')
            MotionMode = propertyValue;
        end
    end
end
Hybrid_admittance_config(tg,'go',0);
Task_space_set_mode(tg,2);
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
id = tg.getparamid('Hybrid Position Force Admittance Control/p_ref','Value');
tg.setparam(id,p_f);
%%  Set orientation
id = tg.getparamid('Hybrid Position Force Admittance Control/quat_ref','Value');
tg.setparam(id,quat_f);
id = tg.getparamid('Hybrid Position Force Admittance Control/quat_f','Value');
tg.setparam(id,quat_f);
%%  Set Go
Hybrid_admittance_config(tg,'go',1);
end