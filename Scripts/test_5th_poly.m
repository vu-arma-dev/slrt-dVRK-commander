Task_space_set_mode(PSM_CMD,1);
Task_space_interp_set_goal(PSM_CMD,...
    [10;0;0],rot2quat(eye(3)),2,'MotionMode','relative');

Task_space_interp_set_goal(PSM_CMD,...
    [0;0;0],rot2quat(rotd([0;0;1],-10)),3,'MotionMode','relative');

Task_space_interp_set_goal(PSM_CMD,...
    [0;0;5],rot2quat(eye(3)),3,'MotionMode','relative');

Task_space_interp_set_goal(PSM_CMD,...
    [-3;-4;-123],rotm2quat(R_des),3,'MotionMode','absolute');