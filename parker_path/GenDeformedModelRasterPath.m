function PATH = GenDeformedModelRasterPath()
%%  Long Wang, 2014/9/18
%   Generate compatible raster path struct for parkreXYZ, JHU experiment
%   setup
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
A = [10;44;-39];  % points coordinates unit in [mm]
Z_ref = A(3);      % since we will execute the scan based XY plane, so we don't care Z
B = [-2;13;-35];
C = [37;3;-46];
D = [42;37;-50];
E = [64;-21;-54];
F = [85;13;-63];
G = [-11;-31;-50];
H = [22;-42;-54];
I = [49;-55;-60];
B(3) = Z_ref;
C(3) = Z_ref;
D(3) = Z_ref;
E(3) = Z_ref;
F(3) = Z_ref;
G(3) = Z_ref;
H(3) = Z_ref;
I(3) = Z_ref;
stepsize = 2;   % unit in [mm]
ABCD_Pattern = GenScanPattern([A,B,C,D],'quad',stepsize);
DCEF_Pattern = GenScanPattern([D,C,E,F],'quad',stepsize);
CEIH_Pattern = GenScanPattern([C,E,I,H],'quad',stepsize);
HGBC_Pattern = GenScanPattern([H,G,B,C],'quad',stepsize);

ControlPts = [  ABCD_Pattern,...
                DCEF_Pattern,...
                CEIH_Pattern,...
                HGBC_Pattern];
                
NumControlPts = size(ControlPts,2);
PATH.ControlPts =ControlPts;
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
save('PathPlan/Raster_Deformed','PATH');
end

