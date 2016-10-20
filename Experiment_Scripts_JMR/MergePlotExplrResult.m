function MergePlotExplrResult()
%%  This func merges the robot exploration results and plot them
Setup_Directories_PSM;
root_path = fileparts(getenv('PSMCMD'));
data_path = [root_path,'/Data'];
ZoneNames = cell(4,1);
ZoneNames{1} = 'zone1_adp_wrist_cdp';
ZoneNames{2} = 'zone2_adp_wrist_cdp';
ZoneNames{3} = 'zone3_adp_wrist_cdp';
ZoneNames{4} = 'zone4_adp_wrist_cdp';
ZoneColors = {'g','m','c','b'};
pointCloud_4_Zones = cell(4,1);
fprintf('Compute contacts and plot exploration data for different zones ...\n');
reverseStr = [];
for i = 1:4
    %   load exploration data
    load([data_path,'/',ZoneNames{i}]);
    %   compute contact and plot
    logger.compute_contact;
    if i==1
    logger.plot_explr_map('new figure','on',...
        'MarkerSize',1,'MarkerColor',ZoneColors{i});
    else
    logger.plot_explr_map('new figure','off',...
        'MarkerSize',1,'MarkerColor',ZoneColors{i});
    end
    msg = sprintf('%0.0f zones of 4 finished ... ',i);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    %   pass to point cloud data structure
    contact_positions = logger.plotData.contact_pos;
    contact_flags = logger.plotData.contact_flags;
    pointCloud_4_Zones{i} = pointCloud(contact_positions(:,contact_flags==1)');
end
fprintf(' [ok].')
%%  merge point clouds
MergeGridStep = 0.5;
for i=1:4
    if i==1
        pointCloudMerge = pointCloud_4_Zones{i};
    else
        pointCloudMerge = pcmerge(pointCloudMerge,pointCloud_4_Zones{i},MergeGridStep);
    end
end
RobotExplrPtCloud = pcdownsample(pointCloudMerge,'gridAverage',MergeGridStep);
save([data_path,'/PSMExplrPtCloud'],'RobotExplrPtCloud');
pcwrite(RobotExplrPtCloud,[data_path,'/PSMExplrPtCloud'],'PLYFormat','binary');
end

