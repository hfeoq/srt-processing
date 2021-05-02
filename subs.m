classdef subs < handle
    properties (SetAccess = private)
        data % stores single subs
        curr_uid % most recent uid
        
    end
    
    properties (Dependent)
        duration % duration (max. value for end_time_ms) in ms
        duration_vec % duration in time vec
        
        active_sub_duration % duration in ms with active subs
        sub_dens % percent of time covered by subtitles, from 0-1 ( = active_sub_duration/duration)
        
    end
    
    properties (Dependent)
        len % n of lines
    end
    
    methods 
        function self = subs(in) % input can be: empty or cell array of sub objects or a single cell object
            self.curr_uid = 1;
            self.data = {};
            
            if nargin == 0
                return,
            end
            
            if isa(in,'sub')
                self.import_sub_single(in)
            return,
            end
            
            if iscell(in)
                if isvector(in)
                    for i = 1:length(in)
                        self.import_sub(in{i})
                    end
                else
                    warning('input should be a cell array with single dimension!')
                    in = in(:);
                    self.import_sub(in);
                end
            end
            
            error('invalid input!')
            
        end
        
        function val = get.len(self)
            val = length(self.data);
        end
        
        function set.curr_uid(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            
            self.curr_uid = uint32(val);
            
        end
        
        function val = get.duration(self) 
            if isempty(self.data)
                
                val = 0;
                return,
            else
                temp = zeros(self.len,1);
                for i = 1:self.len
                    temp(i) = self.data{i}.finish_time_ms;
                end
                val = max(temp);
            end
            
        end
        
        function val = get.duration_vec(self)
            if isempty(self.data)
                
                val = 0;
                return,
            else
                val = ms2timevec(self.duration);
            end
        end
        
        function val = get.active_sub_duration(self)
            if isempty(self.data)
                val = 0;
                return,
            else
                temp = zeros(self.len,2);
                for i = 1:self.len
                    temp(i,:) = [self.data{i}.start_time_ms,self.data{i}.finish_time_ms];
                end
                ms_covered = [];
                for i = 1:self.len
                    ms_covered = [ms_covered, temp(i,1):temp(i,2)];
                end
                
                val = length(unique(ms_covered));
                if val~=length(ms_covered)
                    disp('overlapped subs found, this could or could not be a problem')
                end
                
            end
        end
        
        function val = get.sub_dens(self)
            if isempty(self.data)
                val = 0;
                return,
            else
                val = self.active_sub_duration/self.duration;
            end
        end
        
        function import_sub(self,import_data) % load a single sub/subs obj/cell array
            if isa(import_data,'sub')
            import_data.uid = self.curr_uid;
            %self.data = [self.data , import_data];
            self.import_sub_single(import_data)
            elseif iscell(import_data)
                if isempty(import_data)
                    return,
                elseif ~isvector(import_data)
                    warning('input should be a cell array with single dimension!')
                    import_data = import_data(:);
                end
                for i = 1:length(import_data)
                    self.import_sub_single(import_data{i})
                end
            end
        end
        
        function import_sub_single(self,single_sub)
            if ~isa(single_sub,'sub')
                warning('you must input a sub object when calling this function')
            return,
            else
                self.curr_uid = self.curr_uid + 1;
                single_sub.uid = self.curr_uid;
                self.data = [self.data,single_sub];
            end
            
        end
        
        
    end
    
    
    
    
end