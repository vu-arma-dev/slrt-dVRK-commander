Task_space_set_mode(PSM_CMD,1);
Task_space_interp_set_goal(PSM_CMD,...
    [0;0;0],rot2quat(eye(3)),8,'MotionMode','relative');