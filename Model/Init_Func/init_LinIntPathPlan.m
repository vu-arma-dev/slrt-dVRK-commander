%% Insertion Path Parameters
PathState=1; % initial state for path planning
PathPtNum = 1000;
DesiredPath=[linspace(0,15,PathPtNum);
    0*ones(1,PathPtNum);
    0*ones(1,PathPtNum);
    0*ones(1,PathPtNum);];
PathPlanSpeed=1; %mm/sec