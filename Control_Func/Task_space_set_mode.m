function Task_space_set_mode(tg,mode)
%TASK_SPACE_SET_MODE Summary of this function goes here
%   Detailed explanation goes here
id = tg.getparamid('mode','Value');
tg.setparam(id,mode);


end

