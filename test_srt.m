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