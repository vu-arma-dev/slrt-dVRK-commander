function Hybrid_admitance_set_goal_pose(tg,det_p,det_quat,varargin)
%%  By Long Wang, 2015/7/6
%   For set convenient, p => Incremental position
%   quat => absolute orientaion

dtudp=0.004;
%%  Parse the input
MotionMode= 'absolute';
LogName='nolog';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'MotionMode')
            MotionMode = propertyValue;
        elseif strcmp(propertyName,'LogName')
            LogName= propertyValue;
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
p_f=p_f(:);
tg.setparam(id,p_f);
%%  Set orientation
id = tg.getparamid('Hybrid Position Force Admittance Control/quat_ref','Value');
tg.setparam(id,quat_f);
id = tg.getparamid('Hybrid Position Force Admittance Control/quat_f','Value');
tg.setparam(id,quat_f);
%%  Set Go
logger=dvrk_logger;
Hybrid_admittance_config(tg,'go',1);
if ~strcmp(LogName,'nolog')
    fprintf('\nLogging...\n');
    reverseStr = [];
    while Get_robot_status(tg,'motionGoing')
%         Get and log position, force, quaternion
        t0=tic;
        [pos,quat]=Task_space_get_pose_cur(tg);
        force=Task_space_get_force_cur(tg);
        logger.log_position_force_quat(pos,force,quat);
% Wait for the next UDP call
        while toc(t0)<dtudp
        end
        msg = sprintf('%d poses generated ... ',logger.current_log_idx);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end
    logger.end_log;
    save(LogName,'logger');
end