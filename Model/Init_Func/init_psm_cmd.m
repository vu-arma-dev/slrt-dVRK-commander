%% System parameters
dt = 0.001;
%%  Force control parameters
K_adm = diag([1,1,1])*25;
% f_bias=-0.2;
f_bias=0;
%%  Frames transformations
[R_FT2Rob,T_robot2organ,T_organ2robot] = CalculateFrameTF_PSM;