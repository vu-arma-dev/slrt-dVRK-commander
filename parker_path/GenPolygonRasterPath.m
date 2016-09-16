function PATH = GenPolygonRasterPath()
%%  Long Wang, 2014/9/18
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
%   In this section, write an abitary point sequences using function "GenScanPattern"
%   1) Manually select triangles or quadrilaterals.
%   2) write point groups, make sure the point sequences are continuous
%   An Example here:    say I want to scan an arbitary hexagon shape [ABCDEF]
%                       We can always seperate it to three parts - two
%                       triangles and one quadrilaterals
%                       Let us define Tri_1 = ABF, Quad_2 = BCEF, Tri_3 =
%                       CDE (the third point will be always the end of the individual scan pattern)
A = [50;50;0];  % points coordinates unit in [mm]
B = [0;50;0];
C = [-50;0;0];
D = [-50;-50;0];
E = [0;-50;0];
F = [50;0;0];
stepsize = 5;   % unit in [mm]
AFB_Pattern = GenScanPattern([A,F,B],'tri',stepsize);
BCEF_Pattern = GenScanPattern([B,C,E,F],'quad',stepsize);
EDC_Pattern = GenScanPattern([E,D,C],'tri',stepsize);
ControlPts = [  AFB_Pattern,...
                BCEF_Pattern,...
                EDC_Pattern];
NumControlPts = size(ControlPts,2);
PATH.POINTS(:,1:NumControlPts) = ControlPts;
PATH.POINTS(:,NumControlPts+1:end) = repmat(ControlPts(:,end),1,PATH.PtsNumber - NumControlPts);
%%  Calculate PATH.SegLen and PATH.DATA
[~,seglen] = arclength(PATH.POINTS(1,:),PATH.POINTS(2,:),PATH.POINTS(3,:));
PATH.SegLen = [0,seglen'];
scaled_distance = cumsum(PATH.SegLen.*PATH.SCALING,2);
scaled_distance(NumControlPts:end) = ...
            linspace(scaled_distance(NumControlPts),scaled_distance(NumControlPts)+1,PATH.PtsNumber-NumControlPts+1); % this will ensure the distance values are monotomic
PATH.DATA = [scaled_distance;PATH.POINTS];
DrawPathPlan(PATH.DATA);
save('PathPlan/Raster_Arbitrary','PATH');
end

