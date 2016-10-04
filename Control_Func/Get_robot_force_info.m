function queryValue=Get_robot_force_info(tg,infoName)
%%  get robot (PSM) force information
%   By Long Wang, 9/25/2016
%   This func aquires robot force and contact information
%   Give the infoName to be one of {'force', 'contact', 'surf_normal'}
%   Then the output queryValue would be one of the following:
%        - force reading written in robot base frame
%        - contact flag
%        - surface normal estimate written in robot base frame
if nargin<2
    infoName = 'force'; % query force by default if not specified
end
BlockName =['Contact and Force Compute/',...
    'Contact force and surface normal compute/'];
switch infoName
    case 'force'
        queryValue = zeros(3,1);
        for i = 1:3
            id = tg.getsignalid([BlockName,'p2/s',num2str(i)]);
            queryValue(i) = tg.getsignal(id);
        end
    case 'contact'
        id = tg.getsignalid([BlockName,'p1']);
        queryValue = tg.getsignal(id);
    case 'surf_normal'
        queryValue = zeros(3,1);
        for i = 1:3
            id = tg.getsignalid([BlockName,'p3/s',num2str(i)]);
            queryValue(i) = tg.getsignal(id);
        end
    case 'surface_normal_force'
        BlockName =['Contact and Force Compute/',...
            'Friction Compensation/'];
        queryValue = zeros(3,1);
        for i = 1:3
            id = tg.getsignalid([BlockName,'p1/s',num2str(i)]);
            queryValue(i) = tg.getsignal(id);
        end
end
end