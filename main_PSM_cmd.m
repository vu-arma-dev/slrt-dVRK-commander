%%  Main Func - PSM Commander
%   By Long Wang, Rashid Yasin
address = '192.168.1.201';              % Target Address
port = '22222';                         % Target Port
Model_path = getenv('PSMCMD');
ECL_path = getenv('ECLDIR');
filename = 'PSM_Commander';
version = '2015';
fprintf('Setting up all the directories ..')
working_dir = fileparts(Model_path);
restoredefaultpath;
addpath(genpath(working_dir),...
    genpath(ECL_path));
full_file_path = [Model_path,'/Build/',filename];
fprintf('..[ok]\n');
test = xpctargetping('TCPIP',address,port);

if strcmp(test,'success')
    %% In-Vivo Modes
    %% Start system after homing procedure
    fprintf('Initializing target ');
    PSM_CMD = xpc('TcpIp',address,port);
    fprintf(' [Ok]\n');
    %% Loading application
    fprintf('Loading application');
    load(PSM_CMD,full_file_path);
    fprintf(' [Ok]\n');
    PSM_CMD.start;
end