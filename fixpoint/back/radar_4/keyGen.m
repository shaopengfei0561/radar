function flag = keyGen(newPwd)
% ��������ļ����ܣ����������ļ�
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% ���ӣ�
%   flag = keyGen('111');
%       ������'111'����key�ļ�
%
if(isempty(str2num(newPwd)))
  flag = 0;
  disp('����ֻ�ܰ������֣��Ҳ���Ϊ�գ�');
  return;
end
fname=strcat('key','.yu');
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
  len = length(newPwd);
  rand('seed',987654321);
  key = randi(1000,1,len);
  fid=fopen(fname,'wb');
  if(fid>0)
    fwrite(fid, newPwd+key, 'uint16');
    fclose(fid);
    % ������Կ����ԭ�еļ��������ļ�
    fname=strcat('Config','.yu');
    flag = iniDecrypt(fname,ttt);
    fname=strcat('Config','.ini');
    flag = iniEncrypt(fname,newPwd);
    if flag
      delete(fname);
    end
  else
    error('open ini file failed!');
  end
else
  len = length(newPwd);
  rand('seed',987654321);
  key = randi(1000,1,len);
  fid=fopen(fname,'wb');
  fwrite(fid, newPwd+key, 'uint16');
  fclose(fid);
  % ������Կ����ԭ�еļ��������ļ�
  fname=strcat('Config','.ini');
  flag = iniEncrypt(fname,newPwd);
  if flag
    delete(fname);
  end
end
fclose('all');