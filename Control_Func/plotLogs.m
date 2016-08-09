function plotLogs(logs)
    figure(1)
    hold on
    title('Force nom')
    figure(2)
    hold on
    title('Positon xy');
    figure(3)
    hold on
    title('Position z')
    for i=1:length(logs)
       time = logs(i).time;
       force = logs(i).force;
       pos = logs(i).position;
       normalizedForce = diag(sqrt(force'*force));
       %plot(posz,normalizedForce);
       figure(1);
       plot(time,normalizedForce);
       figure(2);
       plot(pos(1,:),pos(2,:));
       figure(3)
       plot(time,pos(3,:));
    end
end