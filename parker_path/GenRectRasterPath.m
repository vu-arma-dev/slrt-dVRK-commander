function PATH = GenRectRasterPath()
%  Long Wang, 2014/9/18
%   Generate compatible raster path struct for parkreXYZ
%%  Properties of struct PATH
%   PATH.PtsNumber  ->  Total number of points
%   PATH.POINTS     ->  (3 X N) matrix all point coord
%   PATH.SegLen     ->  (1 X N) line segment length from the previous point to
%                       current one, i.e. the first segment is always 0.
%   PATH.SCALING    ->  (1 X N) matrix the scaling applied on all segment length, this
%                       will actually control the velocity profile, if no
%                       scaling, value is 1.
%   PATH.DATA       ->  (4 X N) This is Path plan data that parkerXYZ can take in.
%                        the first row is scaled distance and the other
%                        three are coordinates
%%  Create a PATH struct format
PATH.PtsNumber = 1000;
PATH.POINTS = zeros(3,PATH.PtsNumber);
PATH.SegLen = zeros(1,PATH.PtsNumber);
PATH.SCALING = ones(1,PATH.PtsNumber);
PATH.DATA = zeros(4,PATH.PtsNumber);
%%  Calculate PATH.POINTS
%   Define the box to scan
%   You are looking at the four corners from z+
%   x+ is to your right
%   y+ is to your top
    n_cycle = 15; % the cycle number times that will cover the whole range
    top_right = [77;50;-22];
    top_left = [-4;46;-23];
    bottom_left = [-6;-36;-22];
    bottom_right = [78;-34;-23];
    x_start_x = min([top_right(1),bottom_right(1)]);
    x_start_y = min([top_right(2),top_left(2)]);
    x_start_z = max([top_right(3),top_left(3),bottom_right(3),bottom_left(3)]);
    dx = max([top_left(1),bottom_left(1)]) - x_start_x;
    Dy = max([bottom_left(2),bottom_right(2)]) - x_start_y;
    dy = Dy/(2*n_cycle);
    x_start = [x_start_x;x_start_y;x_start_z];
%  start raster loop
%   every four movement is considered as "one cycle"
%   i.e. +dx,+dy,-dx,+dy
X = zeros(3,PATH.PtsNumber);
X(:,1) = x_start;
for cycle=1:n_cycle
    % current cycle start point index
    i = (cycle-1)*4 + 1;
    % +dx
    X(:,i+1) = X(:,i) + [dx;0;0];
    % +dy
    X(:,i+2) = X(:,i+1) + [0;dy;0];
    % -dx
    X(:,i+3) = X(:,i+2) + [-dx;0;0];
    % dy
    X(:,i+4) = X(:,i+3) + [0;dy;0];
end
N_control_pts = 4*n_cycle + 1;
X(:,N_control_pts+1:end) = repmat(X(:,N_control_pts),1,PATH.PtsNumber-N_control_pts);
PATH.POINTS = X;
%%  Calculate PATH.SegLen and PATH.DATA
PATH.ControlPts = X(:,1:N_control_pts);
[~,seglen] = arclength(X(1,:),X(2,:),X(3,:));
PATH.SegLen = [0,seglen'];
scaled_distance = cumsum(PATH.SegLen.*PATH.SCALING,2);
scaled_distance(N_control_pts:end) = ...
            linspace(scaled_distance(N_control_pts),scaled_distance(N_control_pts)+1,PATH.PtsNumber-N_control_pts+1); % this will ensure the distance values are monotomic
PATH.DATA = [scaled_distance;X];
DrawPathPlan(PATH.DATA);
save('PathPlan/Raster_Path','PATH');
end

