function RedefineHomeRob(tg)
%%  Redefine home pose for PSM
%   By Long Wang, 2016/9/14
%   This func read the current robot pose and redefine this pose as the
%   home pose.
%   The home pose is the pose that the robot is initialized to go.
%   The home pose is NOT the origin of the robot base.
if nargin<1
    address = '192.168.1.201';              % ARMA PC Target Address
    port = '22222';                         % Target Port
    tg = xpc('TcpIp',address,port);    
end
fprintf('Redefining robot home pose ...')
[p,quat] = Task_space_get_pose_cur(tg,'plot','on');
HomeRob.p = p;
HomeRob.R = quat2rotm(quat');
HomeRob.quat = quat;
Config_mat_path = [getenv('PSMCMD'),'/Config_Mat'];
save([Config_mat_path,'/HomeRob'],'HomeRob');
fprintf('[ok]\n');
end

