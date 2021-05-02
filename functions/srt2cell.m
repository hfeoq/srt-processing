% convert srt to cell

function [data ,n_line] = srt2cell(varargin);
if nargin == 0
    [fname,pname ] = uigetfile('*.srt');
elseif nargin == 1
    fname = varargin{1};
    pname = pwd;
elseif nargin == 2
    fname = varargin{1};
    pname = varargin{2};   
else
    error('nargin must be 0, 1 or 2!')
end

cd(pname)
fid = fopen(fname,'r','l','utf-8');
data = string('');
read_file = true;
n_line = 0;

while read_file
    curr_line = fgetl(fid);
    
    if ~isequal(curr_line,-1)
        data = [data,curr_line];
        n_line = n_line + 1;
    else
        fclose(fid)
        read_file = false;
        break,
    end
    
end



end