function ATI_NetFT = Main_ATI_NetFT()
%%  Main func for ATI Net FT application
%   By Long Wang
%   This func starts the xPC application that does the same protocol as ATI
%   Net FT box
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
address = '192.168.1.202';              % ARMA PC Target Address
port = '22222';                         % Target Port
filename = 'ATI_NetFT';
full_file_path = [Model_path,'/Build/',filename];
test = xpctargetping('TCPIP',address,port);
%%  Start application
if strcmp(test,'success')
    fprintf('Initializing target ');
    ATI_NetFT = xpc('TcpIp',address,port);
    fprintf(' [Ok]\n');
    %% Loading application
    fprintf('Loading application');
    load(ATI_NetFT,full_file_path);
    fprintf(' [Ok]\n');
    ATI_NetFT.start;
    %%  Unbias the F/T sensor
    Unbias_FT_sensor(ATI_NetFT);
else
    fprintf('Fail to connect to xCP machine.\n');    
end
end