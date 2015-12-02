function flag = iniEncrypt(fname,ADMPWD_CONSTANT)
% 用密码对文件加密，生成加密文件，并删除明文文件
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% 例子：
%   flag = iniDecrypt('Config.ini','111');
%       用密码'111'加密Config.yu
%
fid=fopen(fname,'rb');
if(fid>0)
  tt=fread(fid, inf, 'uint8');
else
  flag = 0;
  disp('open ini file failed!');
  return;
end
fclose(fid);
tt=tt';
len = length(tt);
ADMPWD_CONSTANT = str2num(ADMPWD_CONSTANT);
rand('seed',ADMPWD_CONSTANT);
fname=strcat(fname(1:end-4),'.yu');
key = randi(1000,1,len);
fid=fopen(fname,'wb');
if(fid>0)
  fwrite(fid, tt+key, 'uint16');
  fclose(fid);
  flag = 1;
else
  flag = 0;
end