function [ measuredData, dataNum] = parseDataColaB2( binaryData )
% SICK激光雷达Cola B协议解析程序（暂未增加对校验和的验证）
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/8/20
% 例子：
%   measuredData = parseDataColaB2( binaryData  );
%       
startAngle = (binaryData(78)*2^24+binaryData(79)*2^16+binaryData(80)*2^8+binaryData(81))/10000;
dataNum = binaryData(84)*2^8+binaryData(85);
channelNum = binaryData(63)*2^8+binaryData(64);
angleStep = (binaryData(82)*2^8+binaryData(83))/10000; % 单位°

if(channelNum==1)
  measuredData = zeros(dataNum,2);
  for i=1:dataNum
    measuredData(i,1) = startAngle + (i-1)*angleStep;
    measuredData(i,2) = (binaryData(85+(i-1)*2+1)*2^8+binaryData(85+i*2))*4; % 单位mm
  end
elseif(channelNum==2)
  measuredData = zeros(dataNum,3);
  for i=1:dataNum
    measuredData(i,1) = startAngle + (i-1)*angleStep;
    measuredData(i,2) = (binaryData(85+(i-1)*2+1)*2^8+binaryData(85+i*2))*4; % 单位mm
    measuredData(i,3) = binaryData(85+dataNum*2+21+(i-1)*2+1)*2^8+binaryData(85+dataNum*2+21+i*2); % RSSI
  end
end

