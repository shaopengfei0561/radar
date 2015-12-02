function flag = iniDecrypt(fname,ADMPWD_CONSTANT)
% 用密码对文件解密，生成明文文件
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% 例子：
%   flag = iniDecrypt('Config.yu','111');
%       用密码'111'解密Config.yu
%
fid=fopen(fname,'rb');
if(fid>0)
  tt=fread(fid, inf, 'uint16');
else
  flag = 0;
  disp('open encrypted file failed!');
  return;
end
fclose(fid);
tt=tt';
len = length(tt);
ADMPWD_CONSTANT = str2num(ADMPWD_CONSTANT);
rand('seed',ADMPWD_CONSTANT);
fname=strcat(fname(1:end-3),'.ini');
key = randi(1000,1,len);
tt=tt-key;
encryptStr = '';
for i=1:length(tt)
  encryptStr = [encryptStr char(tt(i))];
end
fid=fopen(fname,'wb');
if(fid>0)
  fwrite(fid, encryptStr, 'uint8');
  fclose(fid);
  flag = 1;
else
  flag = 0;
end