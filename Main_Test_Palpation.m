% Main Test of palpation with data

% Start the communication
main_PSM_cmd;
datafolder=[fileparts(getenv('PSMCMD')) '\Data\'];

% Set home and end pose
homePos=[20;20;30];
homeQuat = rot2quat(rotd([1;0;0],-180)*rotd([0;0;1],20));
finalPos=[80;80;30];

% Set Grid
n_cycle=8;
xvec=linspace(homePos(1),finalPos(1),n_cycle);
yvec=repmat([homePos(2),finalPos(2)],1,n_cycle/2);

xvec=[xvec, repmat([finalPos(1),homePos(1)],1,n_cycle/2)];
yvec=[yvec,linspace(finalPos(2),homePos(2),n_cycle)];
%% Go to home
dataname=[datafolder 'palpationT1_' num2str(1)];

% Go home above the organ
Task_space_set_mode(PSM_CMD,1);
Task_space_interp_set_goal(PSM_CMD,...
    homePos,homeQuat,4,'MotionMode','absolute');
fprintf('Experiment at home above organ, hit any key to descend\n');
pause
    

%% Turn on admittance controller and sinusoid motion
Task_space_set_mode(PSM_CMD,2);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;0]);
Hybrid_admittance_config(PSM_CMD,'sine_go',1);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;1]);
Hybrid_admittance_config(PSM_CMD,'f_bias',0.15);
Hybrid_admitance_set_goal_pose(PSM_CMD,[0;0;0],[1;0;0;0],...
    'MotionMode','relative','LogName',dataname);
fprintf('Experiment at ready, hit any key to continue\n');
pause

% % % % % % % % % % % % % % % % % % % % % % % % % 
%% Actually run palpation
for i=1:length(xvec)
    dataname=[datafolder 'palpationT1_' num2str(i)];
    goalPos=[xvec(i),yvec(i),homePos(3)];
    Hybrid_admitance_set_goal_pose(PSM_CMD,...
        goalPos,homeQuat,'MotionMode','absolute','LogName',...
        dataname);
end
