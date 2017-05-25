Model_path = getenv('PSMCMD');
ECL_path = getenv('ECLDIR');
fprintf('Setting up all the directories ..')
root_dir = fileparts(Model_path);
restoredefaultpath;
addpath(genpath(root_dir),...
    genpath(ECL_path));
rmpath(genpath([ECL_path,filesep,'.git']),...
        genpath([root_dir,filesep,'.git']));
fprintf('..[ok]\n');