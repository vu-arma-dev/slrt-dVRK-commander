function Hybrid_adm_config(tg,paramName,paramValue)
%%  Configure the properties of the "Hybrid Admittance Controller"
%   By Long Wang, 2016/7/6
%   Properties include:
%   n -                 the force control direction
%   go -                enable to go comand
%   sine_go -           sine superimposed enable
%   f_bias -            the biased force command
%   K_adm -             the force admittance gain matrix
%   trajectory mode -   to control the robot to move, you can either give a
%                       final goal pose, or you can pre-specify a 
%                       trajectory to load to the linear interpolation 
%                       trajectory generator
switch paramName
    case 'n'
        id = tg.getparamid('Hybrid Position Force Admittance Control/n','Value');
    case 'go'
        id = tg.getparamid('Hybrid Position Force Admittance Control/go','Value');
    case 'sine_go'
        id = tg.getparamid(...
            'Hybrid Position Force Admittance Control/Superimposed Position and Force/sine go',...
            'Value');
    case 'f_bias'
        id= tg.getparamid('','f_bias');
    case 'K_adm'
        id=tg.getparamid('','K_adm');
    case 'trajectory mode'
        id = tg.getparamid(...
            'Hybrid Position Force Admittance Control/Desired Trajectory/mode',...
            'Value');
        if strcmp(paramValue,'path')
            mode_value = 1;
        else 
            mode_value = 0;
        end
        paramValue = mode_value;
end
tg.setparam(id,paramValue);
end

