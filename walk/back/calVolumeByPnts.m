function [ V, varargout ] = calVolumeByPnts( dataIn, len, ratio, varargin  )
% ���õ������ݵĿռ�ֲ�ֱ�Ӽ������
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/6/15
% ���ӣ�
%   V = calVolumeByPnts( dataIn, 30, 0.69  );
%       �߳�30mm����������������Ϊ0.69

a=unique(dataIn,'rows');
disp('computing the volume...');

tic;
%% �õ�ÿ����λ�������ĸ߶�
V = 0;
a = spaceDownSampling( a, 'cube3', 1, len); 
[a1Out, tempInd1, tempInd2] = spaceMapping2( a, 'cube3', 1, len); 
for i=1:length(a1Out)
  tempInd = find(tempInd2==i);
  tempHigh = max(a(tempInd,3));
  V = V + tempHigh;
end
V = V*len*len;
V = V*ratio;
disp(['The total volume is ' num2str(V/1e9) ' m^3']);
toc;
