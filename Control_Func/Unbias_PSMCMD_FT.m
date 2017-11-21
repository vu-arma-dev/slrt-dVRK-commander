function Unbias_PSMCMD_FT(tg)
%%  Unbias the F/T sensor
%   By Long Wang, 2016/9/26
%   This func sets the unbiasing trigger for F/T sensor and then wait for
%   6.5 seconds to finish.
%   The unbiasing timer counter is triggered when a rising edge is
%   detected.
BlockName = 'ATI Force Torque Sensor/FT reset';
id_reset = tg.getparamid(BlockName,'Value');
tg.setparam(id_reset,0);
tg.setparam(id_reset,1);
tg.setparam(id_reset,0);
%%  Wait for the force sensor unbiasing
t0 = tic;
fprintf('\nForce sensor being unbiased ...\n')
reverseStr = [];
while(toc(t0)<6.5)
    pause(0.05);
    msg = sprintf('%.2f seconds ... ',toc(t0));
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end
fprintf(' [ok].\n')

end

