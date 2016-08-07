function Task_space_interp_config(tg,paramName,paramValue)
%%  By Long Wang, 2015/7/6
switch paramName
    case 'sine'
        id = tg.getparamid('Task Space Trajectory Interpolation/sine go','Value');
        if strcmp(paramValue,'yes')
            tg.setparam(id,1);
        else
            tg.setpram(id,0);
        end
end
end