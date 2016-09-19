function DefineExplorationMapCorners(MapName)
%%  Define the surface exploration map boundary
%   Long Wang, 2016/9/19
%   By selecting the points on the boundary of a polygon,
%   this func
%       1) let the user select the boundary points and save them using
%       MapName
%       2) call "GenRasterScanPath" to generate raster scan trajectory
%%  Input
%   MapName  -    The name to give for this map
if nargin<1
    MapName = input('Give new map name:(enter to be default "ExplrMap")','s');
    if isempty(MapName)
        MapName = 'ExplrMap';
    end
end
PSM_CMD = Initialize_PSM_CMD;
DefineNextPoint = 1;
SaveResult = 0;
clc;
fprintf('Manually move the PSM to a point and \n');
fprintf('[empty] - save this point \n');
fprintf('[s] - save all the points and quit  \n');
fprintf('[q] - quit without saving previous points \n');
N = 30;
MapRefCorners = zeros(N,2);
MapRefHeights = zeros(N,1);
idx = 1;
while DefineNextPoint
    KeyInput = input('Select:','s');
    switch KeyInput
        case ''
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            MapRefCorners(idx,:) = p(1:2);
            MapRefHeights(idx) = p(3);
            fprintf('Boudary point %0.0f added.\n',idx);
            idx = idx + 1;
        case 's'
            SaveResult = 1;
            DefineNextPoint = 0;
        case 'q'
            DefineNextPoint = 0;
    end
end
if SaveResult==1
    MapRefCorners(idx:end,:) =[];
    MapRefHeights(idx:end,:) =[];
    Config_mat_path = [getenv('PSMCMD'),'/Config_Mat'];
    save([Config_mat_path,'/',MapName],'MapRefCorners','MapRefHeights');
    GenRasterScanPath(MapName,'path name',[MapName,'Raster']);
end
end

