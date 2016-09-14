function [p,quat] = Task_space_get_pose_cur(tg,varargin)
 plot_pose= 'off';
 if numel(varargin)
   for i = 1:2:numel(varargin)
       propertyName = varargin{i};
       propertyValue = varargin{i+1};
       if strcmp(propertyName,'plot')
           plot_pose = propertyValue;
       end
   end
 end
p = zeros(3,1);
for i=1:3
    id = tg.getsignalid(['UDP communication/pos m to mm/s',num2str(i)]);
    p(i) = tg.getsignal(id);
end
quat = zeros(4,1);
for i=1:4
    id = tg.getsignalid(['UDP communication/Task cur quat/s',num2str(i)]);
    quat(i) = tg.getsignal(id);
end
if norm(quat)==0
    quat = [1;0;0;0];
end
if strcmp(plot_pose,'on')
    figure;
    axis equal;
    box on;
    axis_length = 15;
    draw_coordinate_system(axis_length*ones(3,1),eye(3),zeros(3,1),['r' 'g' 'b']);
    draw_coordinate_system(axis_length*ones(3,1),quat2rotm(quat'),p,['r' 'g' 'b']);
    plot3([0,p(1)],[0,p(2)],[0,p(3)],'-m','LineWidth',2);
    view(-215,32);
end
end

