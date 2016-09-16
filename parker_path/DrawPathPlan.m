function DrawPathPlan( DATA )
%%  Long Wang, 2014/9/19
%   This func will draw the path plan given the path data from parkerXYZ
if size(DATA,1)==4
    X = DATA(2:4,:);
elseif size(DATA,1)==3
    X = DATA(1:3,:);
end
figure;
hold on;
axis equal;
view(45,45);
scatter3(X(1,1),X(2,1),X(3,1),'r','fill');
plot3(X(1,:),X(2,:),X(3,:));
draw_coordinate_system([10;10;10],eye(3),zeros(3,1),'rgb');
end

