clear

char0 = '00:00:29,738 --> 00:00:39,738';

half_char = '00:00:29,738';

str0 = string(char0);
str1 = [str0,'aaa'];

[startIndex,endIndex] = regexp(str1,'-->') ;

temp = regexp(str0, '\d*', 'match');

%expression = 'c[aeiou]+t';
expression = '\d*:\d*:\d*,\d*';

startIndex = regexp(half_char,expression,'match');
si2 = regexp(half_char,'\d*');

%%

clear;cab

fname = '理查德·朱维尔的哀歌.Richard.Jewell.Orange字幕组.简体&英文 utf8.srt';
pname = 'C:\Users\Chen\Desktop\MATLAB\srt processing\srt files';

cd(pname)

fid = fopen(fname,'r','l','utf-8');

read_file = true;

data_str = string('');

while read_file
    curr_line = fgetl(fid);
    
    if ~isequal(curr_line,-1)
        data_str = [data_str,curr_line];
    else
        fclose(fid)
        break,
    end
    
end
