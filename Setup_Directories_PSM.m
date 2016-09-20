Model_path = getenv('PSMCMD');
ECL_path = getenv('ECLDIR');
fprintf('Setting up all the directories ..')
working_dir = fileparts(Model_path);
restoredefaultpath;
addpath(genpath(working_dir),...
    genpath(ECL_path));
fprintf('..[ok]\n');