function [p,quat] = Task_space_get_pose_cur(tg)
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
end

