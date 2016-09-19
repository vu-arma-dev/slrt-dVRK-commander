%%  Demonstration of PSM Exploring Unknown Surface
%   This experiment is to scan the surface of the enviroment
% PSM_CMD = Initialize_PSM_CMD('GoHome','on');
PSM_CMD = Initialize_PSM_CMD;
[homePos,homeQuat] = Task_space_get_pose_cur(PSM_CMD);
fprintf('Experiment at home above organ, hit any key to descend\n');
pause;
fprintf('Moving above the bottom of the hill ...');
AboveHillBottomPos = [-17.5193;-4.4077;-140.3847];
AboveHillBottomQuat = [0.0223;0.1343;0.9622;-0.2358];
Task_space_interp_set_goal(PSM_CMD,...
    AboveHillBottomPos ,AboveHillBottomQuat,10,'MotionMode','absolute','CheckCompletion','yes');
fprintf('[ok]\n');

fprintf('Ready to enable force control, hit any key to continue\n');
pause;

%% Turn on admittance controller
Task_space_set_mode(PSM_CMD,2);
Hybrid_adm_config(PSM_CMD,'n',[0;0;0]);
Hybrid_adm_config(PSM_CMD,'sine_go',0);
% Hybrid_adm_config(PSM_CMD,'n',[0;0;1]);
% Hybrid_adm_config(PSM_CMD,'f_bias',0.15);
% Hybrid_adm_set_goal_pose(PSM_CMD,[0;0;0],[1;0;0;0],...
%     'MotionMode','relative');
Hybrid_adm_config(PSM_CMD,'trajectory mode','path');
Hybrid_adm_set_trajectory(PSM_CMD,'load trajectory','RasterPath');
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory speed',2);
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','ready');