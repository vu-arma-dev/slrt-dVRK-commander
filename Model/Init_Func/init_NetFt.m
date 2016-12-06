%%  main init for ATI_NetFt
%   Do NOT use this together with "init_psm_cmd"
dt = 0.001;
socketSentFtMsgTypes = cell(1,9);
for i = 1:3
    socketSentFtMsgTypes{i} = 'uint32';
end
for i=4:9
    socketSentFtMsgTypes{i} = 'int32';
end
ATI_NetFt_reading_Gain = 1000000;
% the gain value of "ATI_NetFt_reading_Gain" is set by the ATI Net F/T box
% and it is reflected in the parsing function in mtsATINetFTSensor.cpp - 
% https://github.com/jhu-saw/sawATIForceSensor/blob/df38da0fd6e7176dad737502f219dbaf46491c85/code/mtsATINetFTSensor.cpp#L159
% ATI_NetFt_port = 49152;