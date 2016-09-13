dt = 0.001;
K_adm = diag([1,1,1])*25;
R_organ2robot=[-0.9269  -0.0698     -0.3686;
    0.1108  -0.9896     -0.0912;
    -0.3585  -0.1254      0.9251];
R_organ2robot=renormalize(R_organ2robot);
p_organ_in_robot=[0.0549;
    0.0278
    -0.1262]; %Should be in meters

H_organ2robot=[R_organ2robot,p_organ_in_robot;
    zeros(1,3), 1];
% Long trying to debug the transformation
H_organ2robot = eye(4);
p_organ_in_robot = zeros(3,1);
R_organ2robot = eye(3);

H_robot2organ=inv(H_organ2robot);
R_robot2organ=H_robot2organ(1:3,1:3);
p_robot_in_organ=H_robot2organ(1:3,4);

Rft2organ=eye(3);

% f_bias=-0.2;
f_bias=0;