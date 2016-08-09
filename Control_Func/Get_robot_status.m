function paramOut=Get_robot_status(tg,paramName)
switch paramName
    case 'motionGoing'
        id = tg.getsignalid('Hybrid Position Force Admittance Control/Robot Moving/endMotion');
end
paramOut=tg.getsignal(id);
end

