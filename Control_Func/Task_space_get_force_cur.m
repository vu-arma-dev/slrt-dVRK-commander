function f = Task_space_get_force_cur(tg)
f = zeros(3,1);
for i=1:3
    id = tg.getsignalid(['UDP communication/Force to organ/s',num2str(i)]);
    f(i) = tg.getsignal(id);
end
end

