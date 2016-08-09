% Plotalllogs
datafolder=[fileparts(getenv('PSMCMD')) '\Data\'];
name='log_';
for i=1:16
    dataname=[datafolder name num2str(i)];
    load(dataname);
    plotLogs(logger.logs);
end