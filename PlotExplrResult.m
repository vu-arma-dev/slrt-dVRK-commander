function [] = PlotExplrResult()
%%  Plot the exploration Results from different zones
root_path = fileparts(getenv('PSMCMD'));
data_path = [root_path,'/Data'];
ZoneNames = cell(4,1);
ZoneNames{1} = 'adaptive_wrist_zone1_video_v1';
ZoneNames{2} = 'adaptive_wrist_zone2_video_v1';
ZoneNames{3} = 'adaptive_wrist_zone3_video_v1';
ZoneNames{4} = 'adaptive_wrist_zone4_video_v1';
ZoneColors = {'g','m','c','b'};
for i = 1:4
    load([data_path,'/',ZoneNames{i}]);
    logger.compute_contact;
    if i==1
    logger.plot_explr_map('new figure','on',...
        'MarkerSize',1,'MarkerColor',ZoneColors{i});
    else
    logger.plot_explr_map('new figure','off',...
        'MarkerSize',1,'MarkerColor',ZoneColors{i});
    end
end
end

