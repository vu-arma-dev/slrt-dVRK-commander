function CollectForceSensorFrameData(SaveDataName)
%%  Collect the point locations on the force sensor
%   Long Wang, 2016/9/19
if nargin<1
    SaveDataName = 'FT2Rob_data';
end
PSM_CMD = Initialize_PSM_CMD('GoHome','on');
DefineNextPoint = 1;
SaveResult = 0;
clc;
fprintf('Manually move the PSM to a point and \n');
fprintf('[A] - save point as "A"  \n');
fprintf('[B] - save point as "B"  \n');
fprintf('[C] - save point as "C"  \n');
fprintf('[D] - save point as "D"  \n');
fprintf('[P] - save point as "Pin"  \n');
fprintf('[s] - save all the points and quit  \n');
fprintf('[q] - quit without saving previous points \n');
while DefineNextPoint
    KeyInput = input('Select:','s');
    switch KeyInput
        case 'A'
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            A = p;
            fprintf('"A" saved.\n');
            DefineNextPoint = 1;
        case 'B'
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            B = p;
            fprintf('"B" saved.\n');
            DefineNextPoint = 1;
        case 'C'
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            C = p;
            fprintf('"C" saved.\n');
            DefineNextPoint = 1;
        case 'D'
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            D = p;
            fprintf('"D" saved.\n');
            DefineNextPoint = 1;
        case 'P'
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            pin = p;
            fprintf('"pin" saved.\n');
            DefineNextPoint = 1;
        case 's'
            SaveResult = 1;
            DefineNextPoint = 0;
        case 'q'
            DefineNextPoint = 0;
    end
end
if SaveResult==1
    Config_mat_path = [getenv('PSMCMD'),'/Config_Mat'];
    save([Config_mat_path,'/',SaveDataName],...
        'A','B','C','D','pin');
    fprintf('All points saved.\n');
end
end

