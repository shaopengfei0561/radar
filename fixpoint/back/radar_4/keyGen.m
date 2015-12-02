function flag = keyGen(newPwd)
% 用密码对文件解密，生成明文文件
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% 例子：
%   flag = keyGen('111');
%       用密码'111'生成key文件
%
if(isempty(str2num(newPwd)))
  flag = 0;
  disp('密码只能包含数字，且不能为空！');
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
    % 用新密钥更新原有的加密配置文件
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
  % 用新密钥更新原有的加密配置文件
  fname=strcat('Config','.ini');
  flag = iniEncrypt(fname,newPwd);
  if flag
    delete(fname);
  end
end
fclose('all');