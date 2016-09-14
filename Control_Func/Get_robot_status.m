function paramOut=Get_robot_status(tg,paramName)
switch paramName
    case 'motionGoing'
        id = tg.getsignalid('Hybrid Position Force Admittance Control/Robot Moving/endMotion');
    case 'motion5thPoly'
        id = tg.getsignalid('Task Space Trajectory Interpolation/5th Order Polynomial and Slerp/Position Interp/p7');
end
paramOut=tg.getsignal(id);
end