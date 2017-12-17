ExpName = 'TrialTwo';
root_dir = fileparts(getenv('PSMCMD'));
DataFolder = [root_dir,filesep,'Data',filesep,'Probing'];
Files=dir([DataFolder,filesep,'TrialTwo','*']);
N_depth = 35;
probing_point=[];stiffness=[];
for t=1:length(Files)
    FileNames=Files(t).name;
    load(FileNames);
    
    forcevec=logger.current_log.force(:,1:N_depth); %he has a buffer of length 1000. but only 1:20 get filled every time
    for ii=1:N_depth
        forcemag(ii)=norm(forcevec(:,ii));% I only care about the force magnitude
    end
    
    position=logger.current_log.position(:,1:N_depth); 
    
    
    [minforce,idxstart]=min(forcemag);%lowest force is where i first make contact with organ
    [maxforce,idxend]=max(forcemag);%max force is where I am deepest into the organ

        probing_point(:,t)=position(:,idxstart);

    stiffness(t)=(maxforce-minforce)/norm(position(:,idxstart)-position(:,idxend));
end

%%



x1=min(probing_point(1,:)):0.5:max(probing_point(1,:));
x2=min(probing_point(2,:)):0.5:max(probing_point(2,:));
[X,Y]=meshgrid(x1,x2);
stiffnessZ=griddata(probing_point(1,:),probing_point(2,:),...
    stiffness,X,Y,'cubic');
% % threshold the stiffness
% stiffness_thresh = multithresh(stiffnessZ,9);
% stiffness_B = imquantize(stiffnessZ,stiffness_thresh);
% stiffness_B = stiffness_B/9;
heightZ = griddata(probing_point(1,:),probing_point(2,:),...
    probing_point(3,:),X,Y);
mesh(X,Y,heightZ,stiffnessZ);
axis equal
shading interp
colorbar