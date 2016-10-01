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
filename = 'PSM_Commander_realtime_udp';
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
