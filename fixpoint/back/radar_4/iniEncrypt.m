function flag = iniEncrypt(fname,ADMPWD_CONSTANT)
% ��������ļ����ܣ����ɼ����ļ�����ɾ�������ļ�
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% ���ӣ�
%   flag = iniDecrypt('Config.ini','111');
%       ������'111'����Config.yu
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