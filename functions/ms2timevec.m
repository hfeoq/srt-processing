function out = ms2timevec(in)
out = [0,0,0,0];

if ~isnumeric(in) || ~isscalar(in) 
    disp('invalid input!')
    return,
end

if in<0
    disp('invalid input!')
    return,
end
in = double(in);

rem=in;
% out(1) = floor(in/60/60/1e3);
% rem = in-out(1)*60*60*1e3;
% out(2) = floor(rem/60/1e3);
% rem = rem - out(2)*60*1e3;
% out(3) = floor(rem/1000);
% out(4) = rem - out(3)*1000;

n_ms = in-floor(in/1000)*1000;
out(4) = n_ms;
n_sec = (in-n_ms)/1000;
out(1) = floor(n_sec/60/60);

rem = n_sec - out(1)*60*60;
out(2) = floor(rem/60);
out(3) = rem- out(2)*60;

end