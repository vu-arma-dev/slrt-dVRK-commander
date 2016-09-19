%% Hybrid Admittance - Trajectory generation Parameters
PathPtNum = 1000;
LinInterpDesiredTraj=[linspace(0,15,PathPtNum);
    0*ones(1,PathPtNum);
    0*ones(1,PathPtNum);
    0*ones(1,PathPtNum);];
LinInterpTrajSpeed=1; %mm/sec