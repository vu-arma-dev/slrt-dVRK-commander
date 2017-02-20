function ATI_NetFT = Main_ATI_NetFT(varargin)
%%  Main func for ATI Net FT application
%   By Long Wang
%   This func starts the xPC application that does the same protocol as ATI
%   Net FT box
% Properties:
% 'FT Type': nano17
%           gamma
%           NOT IMPLEMENTED: nano43
% 'Path': 'Keep' - do not add to path or reset path
%         'Reset' - add to and reset path

%%  parse the input:
FT_Type= 'nano17';
Path_Type='Reset';
if numel(varargin)
    for i = 1:2:numel(varargin)
        propertyName = varargin{i};
        propertyValue = varargin{i+1};
        if strcmp(propertyName,'FT Type')
            FT_Type = propertyValue;
        elseif strcmp(propertyName,'Path')
            Path_Type= propertyValue;
        end
    end
end

Model_path = getenv('PSMCMD');

if strcmp(Path_Type,'Reset')
    %%  Folder path
    ECL_path = getenv('ECLDIR');
    fprintf('Setting up all the directories ..')
    working_dir = fileparts(Model_path);
    restoredefaultpath;
    addpath(genpath(working_dir),...
        genpath(ECL_path));
    fprintf('..[ok]\n');
end
%%  xPC Model information
switch FT_Type
    case 'gamma'
        address = '192.168.1.145';              % ARMA PC Target Address
        port = '22222';                         % Target Port
        filename = 'ATI_NetFT';
    case 'nano17'
        address = '192.168.1.145';              % ARMA PC Target Address
        port = '22222';                         % Target Port
        filename = 'ATI_NetFT_nano17';
    case 'nano43'
        address = '192.168.1.145';              % ARMA PC Target Address
        port = '22222';                         % Target Port
        filename = 'ATI_NetFT_nano43';        
end
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
%     pause(3);
%     Unbias_FT_sensor(ATI_NetFT);
else
    fprintf('Fail to connect to xCP machine.\n');
end
end