% evaluate if input is a time stamp 
% format: 00:00:29,738 --> 00:00:39,738


function [tf,data ] = is_time_stamp(in)
data = [];
data.start_ms = 0;
data.end_ms = 0;
data.start_time = [0,0,0,0];
data.end_time = [0,0,0,0];
tf = false;

 if ~ischar(in)&& ~isstring(in)
    disp('warning: input is not a char or string!')
     tf = false;
     return,
 end
 if isstring(in)
     disp('it is not recommended to insert a string in is_time_stamp')
    in = str2char(in(1));
 end
 
 feat_str = '-->';
 
 if ~contains(in,feat_str)
     tf = false;
     return,
     
 end
 
 [start_idx,end_idx] = regexp(in,'-->') ;
 if isempty(start_idx)
     disp('something is wrong!')
 tf = false;
 return,
 elseif length(start_idx)>1
     disp('something is wrong, two or more feature strings found')
  tf = false;
     return,
 end
 
 str_len = length(in);
 
 if str_len <= 10
     tf = false;
     disp('string contains --> but is not a time stamp')
     return,
 end
 
 
 time_spec =  '\d*:\d*:\d*,\d*';
 
 start_time_str = in(1:start_idx);
 
temp_idx = regexp( start_time_str, time_spec);
if isempty(temp_idx)
    tf = false;
    disp('input is not time stamp')
    return,
    
else
    
[data.start_ms,data.start_time] = single_time_pattern_to_time(start_time_str);
end

end_time_str = in(end_idx:end);
temp_idx = regexp(end_time_str, time_spec);
if isempty(temp_idx)
    tf = false;
    disp('input is not time stamp')
    return,
    
else
    
[data.end_ms,data.end_time] = single_time_pattern_to_time(end_time_str);
end
tf = true;

 
end