function Hybrid_admittance_config(tg,paramName,paramValue)
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

