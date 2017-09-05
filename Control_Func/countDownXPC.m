function countDownXPC(tg,time)
%%  Count Down time according to xPC
%   By Long Wang, 2017/9/4
%   This is to count down a given time according to xPC clock
t0 = tg.ExecTime;
while (tg.ExecTime-t0)<time
end
end