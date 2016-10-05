classdef dvrk_logger < handle
    %%  dvrk_logger
    %   Created by Nico, 2016/7
    %   Last modifed by Long, 2016/9/20
    %   This class is used to log the data from the PSM robot.
    properties (SetAccess = public)
        logName
        logs
        current_log
        start_time
        plotData  % this is used to store data for visual use
    end
    
    properties (SetAccess = protected)
        current_log_idx
        max_log_length
    end
    
    methods
        function self = dvrk_logger(logName)
            self.logName = logName;
            self.max_log_length = 10000;
            self.current_log = struct('time',zeros(1,self.max_log_length), ...
                'position', zeros(3,self.max_log_length), ...
                'force', zeros(3,self.max_log_length), ...
                'quat', zeros(4,self.max_log_length));
            self.current_log_idx = 1;
            self.start_time = tic;
            self.logs = [];
        end
        function log_position_force_quat(self, position, force, quat)
            if self.current_log_idx > self.max_log_length
                self.continue_log();
            end
            idx = self.current_log_idx;
            timestamp = toc(self.start_time);
            self.current_log.time(idx) =  timestamp;
            self.current_log.position(:,idx) = position(:);
            self.current_log.force(:,idx) = force(:);
            self.current_log.quat(:,idx) = quat(:);
            self.current_log_idx = self.current_log_idx+1;
        end
        function end_log(self)
            idx = self.current_log_idx-1;
            self.logs = [self.logs, struct('time',[],'position',[],'force',[],'quat',[])];
            self.logs(end).time = self.current_log.time(:,1:idx);
            self.logs(end).force = self.current_log.force(:,1:idx);
            self.logs(end).position = self.current_log.position(:,1:idx);
            self.logs(end).quat = self.current_log.quat(:,1:idx);
            self.current_log_idx = 1;
        end
        function continue_log(self)
            if isempty(self.logs)
                self.logs = self.make_new_log();
            end
            self.logs(end).time = [self.logs(end).time, self.current_log.time];
            self.logs(end).force = [self.logs(end).force, self.current_log.force];
            self.logs(end).position = [self.logs(end).position, self.current_log.position];
            self.logs(end).quat = [self.logs(end).quat, self.current_log.quat];
            self.current_log_idx = 1;
        end
        %%  Following functions are added by Long based on Nico's class
        function compute_contact(self,varargin)
            %%  Compute contact locations and contact flags
            %   Parse optional inputs
            force_thresh = 0.1;
            r_ball = 6.30/2; % unit in [mm]
            if numel(varargin)
                for i = 1:2:numel(varargin)
                    propertyName = varargin{i};
                    propertyValue = varargin{i+1};
                    if strcmp(propertyName,'force thresh')
                        force_thresh = propertyValue;
                    elseif strcmp(propertyName,'r ball')
                        r_ball = propertyValue;
                    end
                end
            end
            N_logs = size(self.logs,2);
            for i = 1:N_logs
                %   info from the exploration
                N_samples = length(self.logs(i).time);
                force = self.logs(i).force;
                position = self.logs(i).position;
                %   compute contact information
                force_mag = diag(sqrt(force'*force));
                contact_flags = (force_mag>force_thresh);
                force_dir = zeros(3,N_samples);
                force_dir(:,contact_flags) = normc(force(:,contact_flags));
                %   apply offest in force direction
                contact_pos = position - force_dir*r_ball;
                %   append the results to log
                self.logs(i).contact_flags = contact_flags;
                self.logs(i).contact_pos = contact_pos;
                self.logs(i).surf_normal = force_dir;
            end
        end
        function plot_explr_map(self,varargin)
            MakeNewFigure= 'on';
            MarkerSize = 5;
            MarkerColor = 'b';
            if numel(varargin)
                for i = 1:2:numel(varargin)
                    propertyName = varargin{i};
                    propertyValue = varargin{i+1};
                    if strcmp(propertyName,'new figure')
                        MakeNewFigure = propertyValue;
                    elseif strcmp(propertyName,'MarkerSize')
                        MarkerSize = propertyValue;
                    elseif strcmp(propertyName,'MarkerColor')
                        MarkerColor = propertyValue;
                    end
                end
            end
            %%  Plot the exploration result map and store data to plotData
            %   Only the collected points that are detected as contacts are
            %   plotted.
            %%  Note that usually one logger only has two logs.
            %   The first log contains huge data
            %   The second log is the most recent collection.
            %%  Format all seperated N logs to giant 3D matrix
            max_log_length = length(self.logs(1).time);
            N_logs = size(self.logs,2);
            contact_pos_merged_3D = nan(3,max_log_length,N_logs);
            surf_normal_merged_3D = nan(3,max_log_length,N_logs);
            wrist_quat_merged_3D = nan(4,max_log_length,N_logs);
            contact_flags_merged_2D = nan(max_log_length,N_logs);
            for i = 1:N_logs
                N_samples = length(self.logs(i).time);
                contact_pos_merged_3D(:,1:N_samples,i) = ...
                    self.logs(i).contact_pos;
                surf_normal_merged_3D(:,1:N_samples,i) = ...
                    self.logs(i).surf_normal;
                wrist_quat_merged_3D(:,1:N_samples,i) = ...
                    self.logs(i).quat;
                contact_flags_merged_2D(1:N_samples,i) = ...
                    self.logs(i).contact_flags;
            end
            %%  Partition 3D matrix to 2D
            %   Note that this step needs attention
            %   The current conversion is ONLY working for (3 by N) for
            %   each log. Because reshape is following columns
            contact_pos_merged = reshape(contact_pos_merged_3D,...
                [3,N_logs*max_log_length]);
            surf_normal_merged = reshape(surf_normal_merged_3D,...
                [3,N_logs*max_log_length]);
            wrist_quat_merged = reshape(wrist_quat_merged_3D,...
                [4,N_logs*max_log_length]);
            contact_flags_merged = reshape(contact_flags_merged_2D,...
                [N_logs*max_log_length,1]);
            %%  Delete all nan elements in the last log
            %   all nan elements are just holders for format purpose
            nan_idx = isnan(contact_flags_merged);
            contact_flags_merged(nan_idx) = [];
            contact_pos_merged(:,nan_idx) = [];
            surf_normal_merged(:,nan_idx) = [];
            wrist_quat_merged(:,nan_idx) = [];
            self.plotData = struct('contact_flags',[],...
                'contact_pos',[],'surf_normal',[],'wrist_quat',[]);
            self.plotData.contact_flags = contact_flags_merged;
            self.plotData.contact_pos = contact_pos_merged;
            self.plotData.surf_normal = surf_normal_merged;
            self.plotData.wrist_quat = wrist_quat_merged;
            %%  plot
            if strcmp(MakeNewFigure,'on')
                figure;
                hold on;
                axis equal;
                view(126,48);
            end
            scatter3(contact_pos_merged(1,contact_flags_merged==1),...
                contact_pos_merged(2,contact_flags_merged==1),...
                contact_pos_merged(3,contact_flags_merged==1),MarkerSize,MarkerColor);
        end
        function gen_explr_video(self,varargin)
            %%  This func generates video of the exploration
            %%  parse optional arguments
            videoName = 'Explr_video';
            if numel(varargin)
                for i = 1:2:numel(varargin)
                    propertyName = varargin{i};
                    propertyValue = varargin{i+1};
                    if strcmp(propertyName,'video name')
                        videoName = propertyValue;
                    end
                end
            end
            %%  Define/Open VideoWriter obj
            root_path = fileparts(getenv('PSMCMD'));
            if ~exist([root_path,'\Figures_Videos\'],'dir')
                mkdir([root_path,'\Figures_Videos\']);
            end
            v = VideoWriter([root_path,'\Figures_Videos\',videoName],'MPEG-4');
            v.Quality = 100;
            %   Calculate fps
            time_diff = diff(self.logs(1).time);
            fps = 1/mean(time_diff);
            v.FrameRate = fps;
            open(v);
            %
            figure;
            hold on;
            axis equal;
            box on;
            grid on;
            scatter_size = 2.5;
            scatter3(self.plotData.contact_pos(1,self.plotData.contact_flags==1),...
                self.plotData.contact_pos(2,self.plotData.contact_flags==1),...
                self.plotData.contact_pos(3,self.plotData.contact_flags==1),scatter_size);
            view(115,22);
            fprintf('Adjust the view for video generation ... hit any key to continue ... \n');
            pause;
            [az,el] = view;
            view_lim = axis;
            N_samples = length(self.plotData.contact_flags);
            fprintf('Video being generated ...\n');
            reverseStr = [];
            for k = 1:N_samples
                if self.plotData.contact_flags(k)==1
                    % figure clean up and view set up
                    cla;
                    view(az,el);
                    axis(view_lim);
                    %   plot the current exploration map
                    points_idx_so_far = 1:k;
                    points_idx_so_far_contact = ...
                        points_idx_so_far(self.plotData.contact_flags(1:k)==1);
                    scatter3(self.plotData.contact_pos(1,points_idx_so_far_contact),...
                        self.plotData.contact_pos(2,points_idx_so_far_contact),...
                        self.plotData.contact_pos(3,points_idx_so_far_contact),...
                        scatter_size);
                    %   plot the force direction
                    force_arrow_end = 10*self.plotData.surf_normal(:,k)+...
                        self.plotData.contact_pos(:,k);
                    scatter3(self.plotData.contact_pos(1,k),...
                        self.plotData.contact_pos(2,k),...
                        self.plotData.contact_pos(3,k),5,'filled','m');
                    plot3([self.plotData.contact_pos(1,k),force_arrow_end(1)],...
                        [self.plotData.contact_pos(2,k),force_arrow_end(2)],...
                        [self.plotData.contact_pos(3,k),force_arrow_end(3)],...
                        '-r','LineWidth',2);
                    %   plot the wrist orientation
                    R_wrist = quat2rotm(self.plotData.wrist_quat(:,k)');
                    z_wrist = R_wrist(:,3);
                    wrist_arrow_end = -10*z_wrist + self.plotData.contact_pos(:,k);
                    plot3([self.plotData.contact_pos(1,k),wrist_arrow_end(1)],...
                        [self.plotData.contact_pos(2,k),wrist_arrow_end(2)],...
                        [self.plotData.contact_pos(3,k),wrist_arrow_end(3)],...
                        '-g','LineWidth',2);
                    frame = getframe;
                    writeVideo(v,frame);
                    msg = sprintf('%3.2f percent ... ',k/N_samples*100);
                    fprintf([reverseStr, msg]);
                    reverseStr = repmat(sprintf('\b'), 1, length(msg));
                end
            end
            fprintf(' [ok].');
            close(v);
        end
        function save(self)
            %%  save the logger object
            %   use this function only if you have setup the env variable
            %   "PSMCMD"
            root_path = fileparts(getenv('PSMCMD'));
            data_path = [root_path,'/Data'];
            if ~exist(data_path,'dir')
                mkdir(data_path);
            end
            logger = self;
            save([data_path,'/',self.logName],'logger');
        end
    end
    methods(Static)
        function result = make_new_log()
            result = struct('time',[],'position',[],'force',[],'quat',[]);
        end
    end
end