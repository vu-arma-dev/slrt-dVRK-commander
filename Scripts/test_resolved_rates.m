Task_space_set_mode(PSM_CMD,2);
Hybrid_admittance_config(PSM_CMD,'sine_go',0);
Hybrid_admitance_set_goal_pose(PSM_CMD,...
    [5;0;0],[1;0;0;0],'MotionMode','relative');