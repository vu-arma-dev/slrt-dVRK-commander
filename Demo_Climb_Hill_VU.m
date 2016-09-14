%%  Demonstration of PSM Climbing a steep hill
%   This experiment is to scan the surface of the enviroment
%   Start the communication
PSM_CMD = Initialize_PSM_CMD('GoHome','on');
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

%% Turn on admittance controller and sinusoid motion
Task_space_set_mode(PSM_CMD,2);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;0]);
Hybrid_admittance_config(PSM_CMD,'sine_go',0);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;1]);
Hybrid_admittance_config(PSM_CMD,'f_bias',0.15);
Hybrid_admitance_set_goal_pose(PSM_CMD,[0;0;0],[1;0;0;0],...
    'MotionMode','relative');
fprintf('Robot is ready to climb the hill , hit any key to continue\n');
pause;
Hybrid_admitance_set_goal_pose(PSM_CMD,[-5;-20;0],[1;0;0;0],...
    'MotionMode','relative');

fprintf('Robot is ready to going down the hill , hit any key to continue\n');
pause;
Hybrid_admitance_set_goal_pose(PSM_CMD,[5;20;0],[1;0;0;0],...
    'MotionMode','relative');
