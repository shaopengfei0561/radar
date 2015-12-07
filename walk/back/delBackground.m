function [ dataOut, varargout ] = delBackground( dataIn, netHigh, varargin  )
% 自适应去除残留的未处理掉的地面点云数据
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/6/15 updated
% 例子：
%   dataOut = delBackground( dataIn, 400  );
%       400mm作为水平切面，将dataIn中的地面背景去除

a = dataIn;
len1 = 50; 
minNum = 1; % 最少有几个点数才认为有目标
disp('deleting the background...');
tic;
%% 得到哪些立方格处的数据保留
index1 = find(a(:,3)>netHigh);
a1 = a(index1,:);
index2 = find(a(:,3)<=netHigh);
a2 = a(index2,:);
[a1Out,ind1,ind2] = spaceMapping1( a1, 'cube3', 1, 1500 , len1, 0); 
[a2Out,ind3,ind4] = spaceMapping1( a2, 'cube3', 1, 1500 , len1, 0); 
dataOut = a1;
[C,ia,ib] = intersect(a1Out,a2Out,'rows');
for i=1:length(ia)
  tempNum = length(find(ind2==ia(i)));
  if(tempNum>=minNum)
    % disp('hh');
    temp = find(ind4==ib(i));
    dataOut = [dataOut; a2(temp,:)];
  end
end
toc;
