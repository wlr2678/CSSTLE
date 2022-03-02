clear
% Fetch HTML from page
url = "http://www.cmse.gov.cn/gfgg/202107/t20210721_48416.html";
options = weboptions('CharacterEncoding', 'UTF-8');
data = webread(url, options);
%%
% Format new TLE
date = convertCharsToStrings(extractBetween(data, '发布日期: <span>', '</span>'))
line1 = strcat("1 ", erase(extractBetween(data, '<font face="Courier New">1 ', '</font>'), '&nbsp;'))
line2 = strcat("2 ", extractBetween(data, '<font face="Courier New">2 ', '</font>'))
newTLE = {date, line1, line2};
%%
% Save TLE if updated
log = fopen('TLEs.txt', 'r+');

lines = {''};

if fseek(log, 1, 'bof') ~= -1
    lines = textscan(log, '%s', 'Delimiter', '\n');
    lines = lines{1, 1};
end

if  ~ismember(lines, date)
    fprintf("Not found in log, saving new TLE...\n")
    fprintf(log, '\n');
    fprintf(log, strcat(date, '\n'));
    fprintf(log, strcat(line1, '\n'));
    fprintf(log, strcat(line2, '\n'));
else
    fprintf("Found in log, not updated\n")
end

fclose(log);