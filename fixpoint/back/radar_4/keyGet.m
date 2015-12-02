function ttt = keyGet(fname)
% Ω‚√‹Œƒº˛÷–¥Ê¥¢µƒ√‹¬Î◊÷∑˚¥Æ
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% ¿˝◊”£∫
%   ttt = keyGet('key.yu');
%       Ω‚√‹key.yu÷–¥Ê¥¢µƒ√‹¬Î◊÷∑˚¥Æ
%
fid=fopen(fname,'rb');
if(fid>0)
  tt=fread(fid, inf, 'uint16');
  tt=tt';
  len = length(tt);
  rand('seed',987654321);
  key = randi(1000,1,len);
  tt=tt-key;
  ttt = '';
  for i=1:length(tt)
    ttt = [ttt char(tt(i))];
  end
  fclose(fid);
else
  disp(['Œ¥’“µΩ' fname '£°']);
end
fclose('all');