function paramOut=Hybrid_admittance_get_config(tg,paramName)
switch paramName
    case 'n'
        id = tg.getparamid('Hybrid Position Force Admittance Control/n','Value');
    case 'go'
        id = tg.getparamid('Hybrid Position Force Admittance Control/go','Value');
    case 'sine_go'
        id = tg.getparamid('Hybrid Position Force Admittance Control/sine go','Value');
    case 'f_bias'
        id= tg.getparamid('','f_bias');
    case 'K_adm'
        id=tg.getparamid('','K_adm');
end
paramOut=tg.getparam(id,paramValue);
end

