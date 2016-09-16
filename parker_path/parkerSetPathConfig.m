function parkerSetPathConfig( tg, path_speed,distantce_limit)
%% Long Wang
id = tg.getparamid('','PathPlanSpeed');
tg.setparam(id,path_speed);
if nargin<3
    distantce_limit = -1;
end
id = tg.getparamid('Trajectory Planner/Path Following/sLimit','Value');
tg.setparam(id,distantce_limit);



end

