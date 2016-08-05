function Task_space_interp_set_goal(tg,det_p,quat,tf,varargin)
%%  By Long Wang, 2015/7/6
%   For set convenient, p => Incremental position
%   quat => absolute orientaion
%%  Parse the input
MotionMode= 'absolute pos';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'Motion Mode')
            MotionMode = propertyValue;
        end
    end
end
id_go = tg.getparamid('Task Space Trajectory Interpolation/go','Value');
tg.setparam(id_go,0);
%%  Set position
if strcmp(MotionMode,'absolute pos')
    %     [p_cur,~] = Task_space_get_pose_cur(tg);
    p_f = det_p;
elseif strcmp(MotionMode,'relative pos')
    p_cur = rand(3,1);
    p_f = p_cur + det_p;
end
id = tg.getparamid('Task Space Trajectory Interpolation/p_ref','Value');
tg.setparam(id,p_f);
%%  Set orientation
id = tg.getparamid('Task Space Trajectory Interpolation/quat_ref','Value');
tg.setparam(id,quat);
%%  Set time
id = tg.getparamid('Task Space Trajectory Interpolation/5th Order Polynomial and Slerp/tf','Value');
tg.setparam(id,tf);
%%  Set Go
tg.setparam(id_go,1);
end