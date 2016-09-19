%%  Demonstration of PSM Exploring Unknown Surface
%   This experiment is to scan the surface of the enviroment
%%  Intialize and Home the robot
PSM_CMD = Initialize_PSM_CMD('GoHome','on');
% PSM_CMD = Initialize_PSM_CMD;
[homePos,homeQuat] = Task_space_get_pose_cur(PSM_CMD);
fprintf('Robot at home pose, hit any key to continue\n');
pause;
%%  Move to the starting point of the pre-defined exploration trajectory
%   Switch the tra
Task_space_set_mode(PSM_CMD,2);
Hybrid_adm_config(PSM_CMD,'n',[0;0;0]);
Hybrid_adm_config(PSM_CMD,'sine_go',0);
Hybrid_adm_config(PSM_CMD,'trajectory mode','path');
Hybrid_adm_set_trajectory(PSM_CMD,'load trajectory','ExplrMapRaster');
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory speed',4);
Hybrid_adm_set_goal_pose(PSM_CMD,[0;0;0],[1;0;0;0],'MotionMode','relative');
fprintf('Robot is moving to the start poing of the pre-defined path\n');
fprintf('hit any key to continue when reaching the position ... \n');
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','ready');
pause;
fprintf('Robot is reaching to the surface ... hit any key to continu ...\n');
Hybrid_adm_config(PSM_CMD,'K_adm',eye(3)*35);
Hybrid_adm_config(PSM_CMD,'f_bias',0.25);
Hybrid_adm_config(PSM_CMD,'n',[0;0;1]);
pause;

%%  Start raster scan trajectory
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','go');
