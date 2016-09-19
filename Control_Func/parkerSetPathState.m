function parkerSetPathState( tg,state)
%% Long Wang
%% This func will set the state of path planner
% States description
% 1 -> moving toward starting position
% 2 -> ready to execute
% 3 -> running
% 4 -> finished
% otherwise: hold position
id = tg.getparamid('Trajectory Planner/PathState','Value');
tg.setparam(id,state);


end

