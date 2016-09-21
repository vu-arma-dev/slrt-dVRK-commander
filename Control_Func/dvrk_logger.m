classdef dvrk_logger < handle
    %%  dvrk_logger
    %   Created by Nico, 2016/7
    %   Last modifed by Long, 2016/9/20
    %   This class is used to log the data from the PSM robot.
    properties (SetAccess = public)
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
        function self = dvrk_logger()
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
                force_dir(contact_flags) = normc(force(contact_flags));
                %   apply offest in force direction
                contact_pos = position - force_dir*r_ball;
                %   append the results to log
                self.logs(i).contact_flags = contact_flags;
                self.logs(i).contact_pos = contact_pos;
            end
        end
        function plot_explr_map(self)
            %%  Plot the exploration result map and store data to plotData
            %   Only the collected points that are detected as contacts are
            %   plotted.
            %%  Format all seperated N logs to giant 3D matrix
            N_logs = size(self.logs,2);
            contact_pos_merged_3D = nan(3,self.max_log_length,N_logs);
            contact_flags_merged_2D = nan(self.max_log_length,N_logs);
            for i = 1:N_logs
                N_samples = length(self.logs(i).time);
                contact_pos_merged_3D(:,1:N_samples,i) = ...
                    self.logs(i).contact_pos;
                contact_flags_merged_2D(1:N_samples,i) = ...
                    self.logs(i).contact_flags;
            end
            %%  Partition 3D matrix to 2D
            %   Note that this step needs attention
            %   The current conversion is ONLY working for (3 by N) for
            %   each log. Because reshape is following columns
            contact_pos_merged = reshape(contact_pos_merged_3D,...
                [3,N_logs*self.max_log_length]);
            contact_flags_merged = reshape(contact_flags_merged_2D,...
                [N_logs*self.max_log_length,1]);
            %%  Delete all nan elements in the last log
            %   all nan elements are just holders for format purpose
            nan_idx = isnan(contact_flags_merged);
            contact_flags_merged(nan_idx) = [];
            contact_pos_merged(:,nan_idx) = [];
            self.plotData = struct('contact_flags',[],'contact_pos',[]);
            self.plotData.contact_flags = contact_flags_merged;
            self.plotData.contact_pos = contact_pos_merged;
            %%  plot
            figure;
            hold on;
            axis equal;
            scatter3(contact_pos_merged(1,contact_flags_merged==1),...
                contact_pos_merged(2,contact_flags_merged==1),...
                contact_pos_merged(3,contact_flags_merged==1),5);
            view(126,48);
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
                    points_idx_so_far = 1:k;
                    points_idx_so_far_contact = ...
                        points_idx_so_far(self.plotData.contact_flags(1:k)==1);
                    scatter3(self.plotData.contact_pos(1,points_idx_so_far),...
                        self.plotData.contact_pos(2,points_idx_so_far_contact),...
                        self.plotData.contact_pos(3,points_idx_so_far_contact),scatter_size);
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
    end
    methods(Static)
        function result = make_new_log()
            result = struct('time',[],'position',[],'force',[],'quat',[]);
        end
    end
end