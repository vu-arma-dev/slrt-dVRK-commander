function PSM_CMD = Initialize_PSM_CMD(varargin)
%%  Intialize Func - PSM Commander
%   By Long Wang, Rashid Yasin
%   This func starts the xPC application "PSM commander" to control PSM.
%   It also unbias the force sensor
%%  Parsing optional inputs:
GoHome = 'off';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'GoHome')
            GoHome = propertyValue;
        end
    end
end
%%  Folder path
Model_path = getenv('PSMCMD');
ECL_path = getenv('ECLDIR');
fprintf('Setting up all the directories ..')
working_dir = fileparts(Model_path);
restoredefaultpath;
addpath(genpath(working_dir),...
    genpath(ECL_path));
fprintf('..[ok]\n');
%%  xPC Model information
address = '192.168.1.201';              % ARMA PC Target Address
port = '22222';                         % Target Port
filename = 'PSM_Commander';
full_file_path = [Model_path,'/Build/',filename];
test = xpctargetping('TCPIP',address,port);
%%  Start application
if strcmp(test,'success')
    fprintf('Initializing target ');
    PSM_CMD = xpc('TcpIp',address,port);
    fprintf(' [Ok]\n');
    %% Loading application
    fprintf('Loading application');
    load(PSM_CMD,full_file_path);
    fprintf(' [Ok]\n');
    PSM_CMD.start;
end
%% Move to the staring pose
if strcmp(GoHome,'on')
    Config_mat_home_path = [getenv('PSMCMD'),'/Config_Mat/HomeRob'];
    load(Config_mat_home_path);
    Task_space_set_mode(PSM_CMD,1);
    Task_space_interp_set_goal(PSM_CMD,...
        HomeRob.p,HomeRob.quat,10,'MotionMode','absolute','CheckCompletion','yes');
    fprintf('Robot is homing ...\n');
    t0 = tic;
    reverseStr = [];
    while Get_robot_status(PSM_CMD,'motion5thPoly')
        msg = sprintf('%3.2f sec ... ',toc(t0));
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        pause(0.05);
    end
    fprintf('[ok]\n');
end
%%  Unbias the F/T sensor
Unbias_FT_sensor(PSM_CMD);
end