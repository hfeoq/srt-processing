% input should be like: '00:00:29,738'

% outputs:
% time_ms: 29738
% time_vec: [0,0,29,738];

function [time_ms,time_vec] = single_time_pattern_to_time(str)

time_ms = 0;
time_vec = [0,0,0,0];

A = regexp(str, '\d*', 'match');
if length(A)~=4
    disp('invalid input')
    
    return,
else
    for i = 1:4
        time_vec(i) = str2num(A{i});
    end
end
time_ms = timevec2ms(time_vec);


end