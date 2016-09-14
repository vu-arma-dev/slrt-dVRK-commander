function [ R_vec] = Get_R_vec( tg )
R_vec = zeros(9,1);
for i = 1:9
    id = tg.getsignalid(['UDP communication/Embedded MATLAB Function/s',num2str(i)]);
    R_vec(i) = tg.getsignal(id);
end

end

