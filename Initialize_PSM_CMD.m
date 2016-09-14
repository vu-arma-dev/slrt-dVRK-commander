function PSM_CMD = Initialize_PSM_CMD()
%%  Intialize Func - PSM Commander
%   By Long Wang, Rashid Yasin
%   This func starts the xPC application "PSM commander" to control PSM.
%   It also unbias the force sensor
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
%%  Wait for the force sensor unbiasing
t0 = tic;
fprintf('\nForce sensor being unbiased ...\n')
reverseStr = [];
while(toc(t0)<6.5)
    pause(0.05);
    msg = sprintf('%.2f seconds ... ',toc(t0));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end
fprintf(' [ok].\n')

end