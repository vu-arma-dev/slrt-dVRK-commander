function f = Task_space_get_force_cur(tg)
f = zeros(3,1);
for i=1:3
    id = tg.getsignalid(['Force_in_Rob/s',num2str(i)]);
    f(i) = tg.getsignal(id);
end
end

