function Main_Probing_Explore(ExplrPathName,varargin)
%%  Demonstration of PSM Exploring Unknown Surface
%   This experiment is to scan the surface of the enviroment
%%  Parse optional input
if nargin<1
    ExplrPathName = input('Give Exploration path file name:(ExplrMapZone1Raster)','s');
end
wrist_mode= 'adaptive';
force_dir = 'adaptive';
frictionComp = 'none';
LogName = nan;
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'wrist mode')
            wrist_mode = propertyValue;
        elseif strcmp(propertyName,'force direction')
            force_dir = propertyValue;
        elseif strcmp(propertyName,'friction comp')
            frictionComp= propertyValue;
        elseif strcmp(propertyName,'log name')
            LogName = propertyValue;
        end
    end
end
%%  Intialize and Home the robot
PSM_CMD = Initialize_PSM_CMD('GoHome','on');
fprintf('Robot is at home pose.\n');
if isnan(LogName)
    LogName = input('Experiment data log name:','s');
end
%%  Move to the starting point of the pre-defined exploration trajectory
%   Switch the tra
Task_space_set_mode(PSM_CMD,2);
Hybrid_adm_config(PSM_CMD,'n',[0;0;0]);
Hybrid_adm_config(PSM_CMD,'sine_go',0);
Hybrid_adm_config(PSM_CMD,'trajectory mode','path');
Hybrid_adm_set_trajectory(PSM_CMD,'load trajectory',ExplrPathName);
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory speed',4);
fprintf('Robot is moving to the start poing of the pre-defined path\n');
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','ready');
t0 = tic;
reverseStr = [];
while Get_robot_status(PSM_CMD,'trajState')==1
    msg = sprintf('%3.2f sec ... ',toc(t0));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    countDownXPC(PSM_CMD,0.05);
end
fprintf('[ok]\n');
fprintf('hit any key to continue ...\n');
pause;
%%  Robot moving to touch the surface
Hybrid_adm_config(PSM_CMD,'K_adm',eye(3)*35);
Hybrid_adm_config(PSM_CMD,'f_bias',0.25);
Hybrid_adm_config(PSM_CMD,'n',[0.3271;-0.2056;0.9230]);
fprintf('Robot is reaching to contact surface ...\n');
t0 = tic;
reverseStr = [];
while ~Get_robot_force_info(PSM_CMD,'contact')
    msg = sprintf('%3.2f sec ... ',toc(t0));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    countDownXPC(PSM_CMD,0.05);
end
fprintf('[ok]\n');
fprintf('Hit any key to start the surface exploration ...\n');
pause;
%%  Turn on the adaptive force control direction mode and adaptive wrist control
Hybrid_adm_config(PSM_CMD,'wrist mode',wrist_mode);
Hybrid_adm_config(PSM_CMD,'force dir mode',force_dir);
%%  Start raster scan trajectory
Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','go');
%%  The probing parameters
nProbingDepth = 10;
minForce = 0.05;
maxForce = 1;
forcesComd = ...
    [linspace(minForce,maxForce,nProbingDepth);...
    linspace(maxForce,minForce,nProbingDepth)];
if ~strcmp(LogName,'nolog')
    fprintf('\nProbing and recording started ...\n');
    probingLocIdx = 1;
    scanMotionTime = 1;
    trajState = Get_robot_status(PSM_CMD,'trajState');
    while (trajState == 3) || (trajState == 1) || (trajState == 2)
        if trajState == 3
            %%  Perform a probing motion using force control
            fprintf('Probing location %0.0f ... ',probingLocIdx);
            reverseStr = [];
            %   step 1 - pause the surface following motion
            Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','pause');
            countDownXPC(PSM_CMD,0.1); 
            Hybrid_adm_config(PSM_CMD,'f_bias',0.05);
            countDownXPC(PSM_CMD,0.2);
            % a delay for the robot to reoriente the wrist
            %   step 2 - command the forces and record data
            logger=dvrk_logger([LogName,num2str(probingLocIdx)]);
            for j=1:2
                for i =1:nProbingDepth
                    Hybrid_adm_config(PSM_CMD,'f_bias',forcesComd(j,i));
                    countDownXPC(PSM_CMD,0.2);
                    % Get and log position, force, quaternion
                    [pos,quat]=Task_space_get_pose_cur(PSM_CMD);
                    if strcmp(frictionComp,'projection')
                        force=Get_robot_force_info(PSM_CMD,'surface_normal_force');
                    elseif strcmp(frictionComp,'none')
                        force=Get_robot_force_info(PSM_CMD);
                    end
                    logger.log_position_force_quat(pos,force,quat);
                    msg = sprintf('%0.0f/%0.0f depths ... ',...
                        (j-1)*nProbingDepth+i,2*nProbingDepth);
                    fprintf([reverseStr, msg]);
                    reverseStr = repmat(sprintf('\b'), 1, length(msg));
                end
            end
            %   step 3 - resume the scanning motion for a given time
            Hybrid_adm_config(PSM_CMD,'f_bias',0.25);
            countDownXPC(PSM_CMD,0.2);
            Hybrid_adm_set_trajectory(PSM_CMD,'trajectory state','resume');
            logger.end_log;
            logger.save('Probing');
            fprintf('[result saved]\n');
            countDownXPC(PSM_CMD,scanMotionTime);
            probingLocIdx = probingLocIdx + 1;
        end
        trajState = Get_robot_status(PSM_CMD,'trajState');
    end
    fprintf('\nlog finished.\n');
else
    fprintf('\nNo log name given.\n');
end
end