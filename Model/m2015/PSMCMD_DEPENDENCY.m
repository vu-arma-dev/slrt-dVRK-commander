function PSMCMD_DEPENDENCY()
%%  Long Wang, 2016/6/29
%   This func will exclusively setup the denpendency for IREP xPC model
%   (Matlab 2015 version).
%   There will be generally two libraries needed for any ARMA robot.
%       1) Embedded Common Library
%       2) Custom robot emebedded library, (e.g. in this case, Embedded_Func under model directory)
%%  Get ECL Path (if not existed, set up one.)
matlab_version = '2015';
if strcmp(matlab_version,'2010')
    path_ECL = SETUP_ENV_PATH('ECL2010');
else
    path_ECL = SETUP_ENV_PATH('ECLDIR');
end
%%  Custom Embdded Library
path_Model = SETUP_ENV_PATH('PSMCMD');
%     path_Embedded = [path_Model,'\Embedded_Func'];
%%  Other dependencies
path_IREP_Init = [path_Model,'\Init_Func'];
%     path_IREP_Mat = [path_Model,'\Config_Mat'];
%     path_IREP_icon = [path_Model,'\icons'];
path_IREP_simulink = [path_Model,'\m2015'];
%%  Adding all the path
restoredefaultpath;
addpath(  genpath(path_ECL),...
    path_IREP_Init,...
    path_IREP_simulink);
%               path_Embedded,...
%               path_IREP_Mat,...
%               path_IREP_icon,...

end