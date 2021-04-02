classdef sub < handle
    properties
        num % numeric label  
        txt % string
        uid % unique id, should be used in srt obj only
        label
    end
    
    properties (SetAccess = immutable)
        
    end
    
    properties (Dependent)
        run_time_ms  % dependent feature
        start_time_ms % like: 123000
        finish_time_ms
        time_range % 2 by 4 array
        time_stamp % string
    end
    
    properties( SetAccess = private)
        start_time_ms_hid
        finish_time_ms_hid
        constructed  % finished constructor? tf
        
    end
    
    
    
    methods
        function self = sub(sub_num,sub_time_stamp,sub_txt) 
            if nargin == 0 % create an empty obj
                %self = sub(0,[0,0],'');
                sub_num = 0;
                sub_time_stamp = [0,0];
                sub_txt = '';
            end
            self.num = sub_num;
            self.txt = sub_txt;
            
            if isnumeric(sub_time_stamp)
                
                if length(sub_time_stamp) == 2
                    self.start_time_ms = sub_time_stamp(1);
                    self.finish_time_ms = sub_time_stamp(2);
                elseif length(sub_time_stamp) == 4
                    self.time_range = sub_time_stamp;
                else
                    warning('input time stamp is invalid')
                    self.time_range = zeros(2,4);
                end
                
            elseif ischar(sub_time_stamp)
                [tf,data] = is_time_stamp(sub_time_stamp);
                if tf
                    self.time_range = [ data.start_time;data.end_time];
                else
                    warning('input time stamp is invalid')
                    self.time_range = zeros(2,4);
                end
                
                
            end
            self.uid = 0;
            self.label = 1;
            self.constructed =true;
            
            
        end
        

        
        function set.txt(self,in) % set text
            if ischar(in)
                if isempty(in)
                    self.txt = string('');
                    return,
                end
                n_row = length( in(:,1));
                if n_row>1
                    warning('it''s highly unrecommended to use multi-row char as input')
                    str = string('');
                    for i = 1:n_row
                        str{i} = in(i,:);
                    end
                    self.txt = str;
                    return,
                else
                    self.txt = string(in); % single-line char
                    return,
                end
            elseif isstring(in)
                if ~isvector()
                    warning('input string is not vectorized, something might be wrong')
                in = in(:);
                end
                str = string('');
                for i = 1:length(in)
                    str{i} = in{i};
                end
                self.txt = str;
                return,
            else
                warning('invalid input, cell input to be finished')
            end
            
            
        end
    end
    
    methods % general operations on time stamp 
        function  delay_ms(self,val) % delay in ms
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            
            self.start_time_ms = self.start_time_ms+val;
            self.finish_time_ms = self.finish_time_ms+val;
            
        end
        
        function scaling(self,k,b)
            if ~isnumeric(k)||~isnumeric(b)
                warning('invalid input!')
                return,
            end
            if ~isscalar(k)||~isscalar(b)
                warning('invalid input, input must be a single value')
                return,
            end
            self.start_time_ms = k.*self.start_time_ms+b;
            self.finish_time_ms = k.*self.finish_time_ms+b;            
        end
        
    end
    
    methods % set methods for hided time properties
        function set.start_time_ms_hid(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            self.start_time_ms_hid = uint32(val);            
        end
        function set.finish_time_ms_hid(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            self.finish_time_ms_hid = uint32(val);            
        end        
        
    end
    
    methods
        function set.num(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end            
            
            if val<0
                warning('sub label must be >=0!')
                val = 0;
            end
            
            if abs(val-round(val))>1e-9
                warning('sub label must be an integer!')
                val = round(val);
            end
            self.num = uint32(val);
            
        end
    end
    
    methods % get and set methods for dependent time props
        function set.start_time_ms(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            if val<0
                warning('value must be >=0!')
                val = 0;
                
            end
            self.start_time_ms_hid = val;
        end
        function val = get.start_time_ms(self)
            val = double(self.start_time_ms_hid);
        end

        function set.finish_time_ms(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            if val<0
                warning('value must be >=0!')
                val = 0;
                
            end
            self.finish_time_ms_hid = val;
        end
        function val = get.finish_time_ms(self)
            val = double(self.finish_time_ms_hid);
        end
        
        function set.run_time_ms(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            if val<=0
                warning('value must be >=0!')
                val = 0;
                return,
            end

            curr_ctr_time = mean([double(self.start_time_ms_hid) ,double(self.finish_time_ms_hid)  ]);
            self.start_time_ms_hid = curr_ctr_time-.5*val;
            self.finish_time_ms_hid = curr_ctr_time+.5*val;
        end
        function val = get.run_time_ms(self)
            if self.finish_time_ms_hid < self.start_time_ms_hid
                warning(' start_time_ms is larger than finish_time_ms!')
            end
            val = double(self.finish_time_ms_hid - self.start_time_ms_hid);
        end
        
        function set.time_range(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            
            sz = size(val);
            if length(sz)~=2
                warning('invalid input!')
                return,
            end
            if sz(1)~=2 || sz(2)~=4
                warning('invalid input!')
                return,
            end
            self.start_time_ms_hid = timevec2ms(val(1,:));
            self.finish_time_ms_hid = timevec2ms(val(2,:));
        end
        function val = get.time_range(self)
            val = zeros(2,4);
            val(1,:) = ms2timevec(self.start_time_ms_hid);
            val(2,:) = ms2timevec(self.finish_time_ms_hid);
        end
        
        function set.time_stamp(self,val)
            [tf,data] = is_time_stamp(val);
            if ~tf
                warning('invalid input!')
                return,
            else
                self.start_time_ms_hid = data.start_ms;
                self.finish_time_ms_hid = data.end_ms;
            end
        end
        function val = get.time_stamp(self)
            time1 = uint32(ms2timevec(self.start_time_ms_hid));
            time2 = uint32(ms2timevec(self.finish_time_ms_hid));
            val = [ num2str(time1(1)) ':' num2str(time1(2)) ':' num2str(time1(3)) ',' num2str(time1(4)) ...
                '-->' ... 
                num2str(time2(1)) ':' num2str(time2(2)) ':' num2str(time2(3)) ',' num2str(time2(4))];
        end
        function set.uid(self,val) 
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            if val<0
                warning('value must be >=0!')
                val = 0;
                return,
            end
            self.uid = uint32(val);
        end
        
        function set.label(self,val)
            if ~isnumeric(val)
                warning('invalid input!')
                return,
            end
            if ~isscalar(val)
                warning('invalid input, input must be a single value')
                return,
            end
            if val<0
                warning('value must be >=0!')
                val = 0;
                return,
            end
            self.label = uint32(val);
        end
        
    end
end