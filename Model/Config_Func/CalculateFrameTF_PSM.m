function [R_FT2Rob,T_Rob2Org,T_Org2Rob] = CalculateFrameTF_PSM()
%%  Calculate frame transformations for PSM
%   By Long Wang, 2016/9/13
%   This func calculates the following frame transformations for PSM robot.
%   1)  R_FT2Rob - Rotation matrix from force sensor frame to robot base
%       frame
%   2)  [R_organ2robot, p_organ_in_robot] - 
%       Rotation matrix and position offset from organ/phatom frame to
%       robot base.
%%  Loading the data collected
Config_mat_path = [getenv('PSMCMD'),'/Config_Mat'];
FT2RobData = load([Config_mat_path,'/FT2Rob_data']);

%%  Calculate R_FT2Rob
%   Read "FT2Rob_data_ReadMe" for the definitions of all measurements
%   Use a linear least square methods herer to solve the plane fit problem
%   Note that the result "pn_norm" could be either pointing outward force
%   sensor or inward.
%   To determine if using pn_norm or (-pn_norm), use cross(AD,AC)
X = [FT2RobData.A';...
    FT2RobData.B';...
    FT2RobData.C';...
    FT2RobData.D'];
pn_norm = pinv(X)*ones(size(X,1),1);
pn_norm = normc(pn_norm);
nz_try = normc(cross(FT2RobData.D - FT2RobData.A,FT2RobData.C - FT2RobData.A));
if (pn_norm'*nz_try) > (-pn_norm'*(nz_try))
    % This case, nz_try is more aligned with pn_norm
    nz_FT_in_Rob = pn_norm;
else
    % This case, nz_try is more aligned with (-pn_norm)
    nz_FT_in_Rob = -pn_norm;
end
nx_in_space = normc(FT2RobData.pin - FT2RobData.center);
% projectionMat_nz = nz_FT_in_Rob*inv(nz_FT_in_Rob'*nz_FT_in_Rob)*nz_FT_in_Rob';
% Replace inv(A)*b with A\b
% Replace b*inv(A) with b/A
projectionMat_nz = nz_FT_in_Rob/(nz_FT_in_Rob'*nz_FT_in_Rob)*nz_FT_in_Rob';
nx_FT_in_Rob = normc((eye(3) - projectionMat_nz)*nx_in_space);
ny_FT_in_Rob = cross(nz_FT_in_Rob,nx_FT_in_Rob);
R_FT2Rob = [nx_FT_in_Rob,ny_FT_in_Rob,nz_FT_in_Rob];
save([Config_mat_path,'/FT2Rob_Frame'],'R_FT2Rob');
%%  Calculate transformation frames from organ to robot
R_organ2robot = eye(3);
p_organ_in_robot = zeros(3,1);
T_Org2Rob = [R_organ2robot,p_organ_in_robot;...
    0,0,0,1];
T_Rob2Org = inv(T_Org2Rob);
save([Config_mat_path,'/Org2Rob_Frame'],'T_Org2Rob','T_Rob2Org');
end