function ttt = keyGet(fname)
% �����ļ��д洢�������ַ���
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/9/21
% ���ӣ�
%   ttt = keyGet('key.yu');
%       ����key.yu�д洢�������ַ���
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
  disp(['δ�ҵ�' fname '��']);
end
fclose('all');