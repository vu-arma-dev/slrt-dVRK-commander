position_epsilon = .1; % [mm]
Vmax = 5; % [mm/s]
Vmin = 0.5; % [mm/s]
lin_vel_scale = 5; %lambda, this value must > 1
orientation_epsilon = 3*pi/180; %rad
OmegaMax = 15*pi/180;   %rad/s
OmegaMin = 2*pi/180;   %rad/s
ang_vel_scale = 5; %lambda is the radius of error =lamda*epsilon after which you use maximum speed
v_limits=[Vmin;Vmax;OmegaMin;OmegaMax];
scale_vec=[lin_vel_scale;ang_vel_scale];
epsilon_vec=[position_epsilon;orientation_epsilon];
