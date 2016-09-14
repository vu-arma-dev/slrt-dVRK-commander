%%  Main Test of palpation with data
%   This experiment is to scan the surface of the enviroment
%   Start the communication
PSM_CMD = Initialize_PSM_CMD('GoHome','on');
datafolder=[fileparts(getenv('PSMCMD')) '\Data\'];
[homePos,homeQuat] = Task_space_get_pose_cur(PSM_CMD);
fprintf('Experiment at home above organ, hit any key to descend\n');
pause;

%% Turn on admittance controller and sinusoid motion
Task_space_set_mode(PSM_CMD,2);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;0]);
Hybrid_admittance_config(PSM_CMD,'sine_go',0);
Hybrid_admittance_config(PSM_CMD,'n',[0;0;1]);
Hybrid_admittance_config(PSM_CMD,'f_bias',0.15);
Hybrid_admitance_set_goal_pose(PSM_CMD,[0;-5;0],[1;0;0;0],...
    'MotionMode','relative');
fprintf('Experiment at ready, hit any key to continue\n');
pause;

% % % % % % % % % % % % % % % % % % % % % % % % %
%% Actually run palpation
for i=1:length(xvec)
    dataname=[datafolder 'palpationT1_' num2str(i)];
    goalPos=[xvec(i),yvec(i),homePos(3)];
    Hybrid_admitance_set_goal_pose(PSM_CMD,...
        goalPos,homeQuat,'MotionMode','absolute','LogName',...
        dataname);
end
