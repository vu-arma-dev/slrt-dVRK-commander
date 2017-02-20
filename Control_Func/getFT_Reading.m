function [ wrench ] = getFT_Reading( tg_FT )
%GETFT_READING Summary of this function goes here
%   Detailed explanation goes here
force=zeros(3,1);
torque=force;
force(1)=tg_FT.getsignal('ATI Force Torque Sensor/force/s1');
force(2)=tg_FT.getsignal('ATI Force Torque Sensor/force/s2');
force(3)=tg_FT.getsignal('ATI Force Torque Sensor/force/s3');

torque(1)=tg_FT.getsignal('ATI Force Torque Sensor/ATI_torque_convert_to_Nmm/s1');
torque(2)=tg_FT.getsignal('ATI Force Torque Sensor/ATI_torque_convert_to_Nmm/s2');
torque(3)=tg_FT.getsignal('ATI Force Torque Sensor/ATI_torque_convert_to_Nmm/s3');

wrench=[force;torque];
end

