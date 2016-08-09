% Test admittance

% Start the robot

% Go to home position in organ space
% % % % % % % % % % % % % % % % % % % 
homePos=[50;50;30];
homeQuat = rot2quat(rotd([1;0;0],-160)*rotd([0;0;1],35));
% % % % % % % % % % % % % % % % % % % % % 
% 
Task_space_set_mode(PSM_CMD,2);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;0]);
Hybrid_admitance_set_goal_pose(PSM_CMD,...
    homePos,homeQuat,'MotionMode','absolute');

% Task_space_set_mode(PSM_CMD,1);
% Task_space_interp_set_goal(PSM_CMD,...
%     homePos,homeQuat,6,'Motion Mode','absolute');

%%
% Turn sine motion off for now - add in later
Hybrid_admittance_config(PSM_CMD,'sine_go',0);
% Set admittance direction!!
Hybrid_admittance_config(PSM_CMD,'n',[0;0;1]);
% Change to resolved rates/admittance mode - should immediately turn on
% admittance control and reach organ
Task_space_set_mode(PSM_CMD,2);
Hybrid_admittance_config(PSM_CMD,'f_bias',0.15);
Hybrid_admitance_set_goal_pose(PSM_CMD,[0;0;0],[1;0;0;0],'MotionMode','relative');

%%
% % Test a movement!
Hybrid_admittance_config(PSM_CMD,'sine_go',1);
Hybrid_admitance_set_goal_pose(PSM_CMD,...
    [-15;-15;0],[1;0;0;0],'MotionMode','relative');
