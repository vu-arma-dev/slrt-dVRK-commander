function queryValue=Get_robot_force_control_info(tg,infoName)
%%  get robot (PSM) force controller information
%   Edied based on Get_robot_force_info, by Rashid Yasin 9/9/2017
%   This func aquires robot force control information
%   Give the infoName to be one of {'dir',...?}
%   Then the output queryValue would be one of the following:
%        - focr control direction
if nargin<2
    infoName = 'dir'; % query force by default if not specified
end
BlockName =['Contact and Force Compute/',...
    'Contact force and surface normal compute/'];
switch infoName
    case 'dir'
        BlockName=['Hybrid Position Force Admittance Control/'...
        'Force Control Direction/direction limiting cone/Switch/'];
        queryValue = zeros(3,1);
        for i = 1:3
            id = tg.getsignalid([BlockName,'s',num2str(i)]);
            queryValue(i) = tg.getsignal(id);
        end
end
end