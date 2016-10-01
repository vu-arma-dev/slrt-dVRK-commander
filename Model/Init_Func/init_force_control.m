%%  Force control parameters
K_adm = diag([1,1,1])*25;
% f_bias=-0.2;
f_bias=0;
%%  Frames transformations
[R_FT2Rob,T_robot2organ,T_organ2robot] = CalculateFrameTF_PSM;
%%  Force control direction limits
ForceCtrlDirLimitConeAngle = 120*pi/180;
ForceCtrlDefaultDir = [0;0;0];
WristCtrlDirLimitConeAngle = 60*pi/180;