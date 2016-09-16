function parkerSetPathPause( tg, PAUSEFlag )
id = tg.getparamid('Trajectory Planner/Path Following/pause','Value');
tg.setparam(id,PAUSEFlag);


end

