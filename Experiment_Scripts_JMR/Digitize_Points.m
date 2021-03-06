function Digitize_Points(DataName)
%%  Digitize points in robot base frame
%   Long Wang, 2016/9/19
%%  Input
%   MapName  -    The name to give for this map
if nargin<1
    DataName = input('Give the name to save the data:(enter to be default "DigitizedPoints")','s');
    if isempty(DataName)
        DataName = 'DigitizedPoints';
    end
end
PSM_CMD = Initialize_PSM_CMD('GoHome','on');
DefineNextPoint = 1;
SaveResult = 0;
clc;
fprintf('Manually move the PSM to a point and \n');
fprintf('[empty] - save this point \n');
fprintf('[s] - save all the points and quit  \n');
fprintf('[q] - quit without saving previous points \n');
N = 200;
DigitizedProbeCenters = zeros(N,3);
ForceDigitized = zeros(N,3);
idx = 1;
while DefineNextPoint
    KeyInput = input('Select:','s');
    switch KeyInput
        case ''
            [p,~] = Task_space_get_pose_cur(PSM_CMD);
            DigitizedProbeCenters(idx,:) = p;
            % The force direction is needed to compensate the offset from
            % the probe center to the surface contacts
            ForceDigitized(idx,:)= Get_robot_force_info(PSM_CMD);
            fprintf('Point position %0.0f digitized.\n',idx);
            idx = idx + 1;
        case 's'
            SaveResult = 1;
            DefineNextPoint = 0;
        case 'q'
            DefineNextPoint = 0;
    end
end
if SaveResult==1
    r_probe = 6.3/2;
    DigitizedProbeCenters(idx:end,:) =[];
    ForceDigitized(idx:end,:) = [];
    OffsetProbe = r_probe*normr(ForceDigitized);
    DigitizedPoints = DigitizedProbeCenters - OffsetProbe;
    root_path = fileparts(getenv('PSMCMD'));
    data_path = [root_path,'/Data'];
    save([data_path,'/',DataName],...
        'DigitizedPoints','DigitizedProbeCenters','ForceDigitized');
end
end

