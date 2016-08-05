function Task_space_interp_config(tg,flag)
%%  By Long Wang, 2015/7/6
%   This function is used for force central program on big snake xPC
%   make sure the "Go" switch is off before enable
id_go = tg.getparamid('Task Space Command/go','Value');
tg.setparam(id_go,0);
id_flag = tg.getparamid('Task En','Value');
tg.setparam(id_flag,flag);

end