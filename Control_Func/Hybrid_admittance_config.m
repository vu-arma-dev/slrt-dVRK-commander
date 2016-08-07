function Hybrid_admittance_config(tg,paramName,paramValue)
switch paramName
    case 'n'
        id = tg.getparamid('Hybrid Position Force Admittance Control/n','Value');
    case 'go'
        id = tg.getparamid('Hybrid Position Force Admittance Control/go','Value');
    case 'sine_go'
        id = tg.getparamid('Hybrid Position Force Admittance Control/sine go','Value');
end
tg.setparam(id,paramValue);
end

