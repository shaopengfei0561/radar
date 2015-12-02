function [ V, varargout ] = calVolumeByPnts( dataIn, len, ratio, varargin  )
% 利用点云数据的空间分布直接计算体积
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/6/15
% 例子：
%   V = calVolumeByPnts( dataIn, 30, 0.69  );
%       边长30mm的立方柱，伸缩比为0.69

a=unique(dataIn,'rows');
disp('computing the volume...');

tic;
%% 得到每个单位立方柱的高度
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
