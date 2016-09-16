function [ NotMono,points] = PathDistMonoCheck( filename )
load(filename);
s = PATH.DATA(1,:);
s_diff = s(2:end) - s(1:end-1);   % the first distance value is always 0
NotMono = sum(s_diff<=0); 
if NotMono
    points = PATH.DATA(2:4,[0,s_diff]<=0);
else
    points = [nan,nan,nan];
end
end

