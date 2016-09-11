function MAKE_PSMCMD()
model_name = 'PSM_Commander';
current_dir = pwd;
PSMCMD_DEPENDENCY;
SETUP_BUILD_PATH('PSMCMD');
model_path = getenv('PSMCMD');
cd(model_path);
fprintf('Start to build model.\n');
slbuild(model_name);
cd(current_dir);
end

