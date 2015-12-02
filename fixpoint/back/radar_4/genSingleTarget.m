function rawData=genSingleTarget(targetType, par1, par2, par3, direction) 
% ���ɱ�׼�������ֽֽ��ȣ���3D��������
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/5/20

%% generate data
rawData = [];
if(targetType==1) % 1=�־�2=ֽ��/������
  outRadii = par1;
  inRadii = par2; % ��λ����
  len = par3;
  stepY = 25;
  stepX = 25;
  stepZ = 25;
  
  tempY1 = 0;
  tempY2 = len;
  refPoint = [outRadii, outRadii];
  for i=1:(outRadii-inRadii)/stepX+1
    [CircleX, CircleZ] = circle(refPoint, inRadii+(i-1)*stepX);
    tempdata1 = [CircleX',ones(length(CircleX),1)*tempY1,CircleZ'];
    tempdata2 = [CircleX',ones(length(CircleX),1)*tempY2,CircleZ'];
    rawData = [rawData;tempdata1;tempdata2];
  end

  refPoint = [outRadii, outRadii];
  [CircleX1, CircleZ1] = circle(refPoint, outRadii);
  [CircleX2, CircleZ2] = circle(refPoint, inRadii);
  for i=1:len/stepY-1
    tempY = i*stepY;
    tempdata1 = [CircleX1',ones(length(CircleX1),1)*tempY,CircleZ1'];
    tempdata2 = [CircleX2',ones(length(CircleX2),1)*tempY,CircleZ2'];
    rawData = [rawData;tempdata1;tempdata2];
  end
  
  % �����д��־�ʵ�ʶѷŷ�����ת�־�����
  if(direction==1)
    rawData=[rawData(:,2),rawData(:,1),rawData(:,3)];
  end
  rawData=unique(rawData,'rows');
  dlmwrite('dataOneTape.txt', rawData, 'delimiter', '\t','precision', 8);
  standardVolume = pi*outRadii^2*len/1e6; % ��������
  standardLen = max([par1, par2, par3]);
  dataOneTape = rawData;
  save dataOneTape.mat dataOneTape standardVolume standardLen;

elseif(targetType==2)
  bottomLen1 = par1; % ��λ���ף����泤
  bottomLen2 = par2; % ��λ���ף������
  len = par3; % ��λ���ף������峤
  nStepXZ = 10;
  stepY = 25;
  
  tempY1 = 0;
  tempY2 = len;
  refPoint = [bottomLen1/2, bottomLen2/2];
  for i=1:nStepXZ
    len1 = i*bottomLen1/nStepXZ;
    len2 = i*bottomLen2/nStepXZ;
    [rectangleX, rectangleZ] = rectData(refPoint, len1, len2);
    tempdata1 = [rectangleX',ones(length(rectangleX),1)*tempY1,rectangleZ'];
    tempdata2 = [rectangleX',ones(length(rectangleX),1)*tempY2,rectangleZ'];
    rawData = [rawData;tempdata1;tempdata2];
  end
 
  refPoint = [bottomLen1/2, bottomLen2/2];
  [rectangleX, rectangleZ] = rectData(refPoint, bottomLen1, bottomLen2);
  for i=1:len/stepY-1
    tempY = i*stepY;
    tempdata1 = [rectangleX',ones(length(rectangleX),1)*tempY,rectangleZ'];
    rawData = [rawData;tempdata1;tempdata2];
  end
  % �����д��־�ʵ�ʶѷŷ�����ת�־�����
  if(direction==1)
    rawData=[rawData(:,2),rawData(:,1),rawData(:,3)];
  end
  dlmwrite('dataOneTape.txt', rawData, 'delimiter', '\t','precision', 8);
  standardVolume = bottomLen1*bottomLen2*len/1e6; % ��������
  standardLen = max([par1, par2, par3]);
  dataOneTape = rawData;
  save dataOneTape.mat dataOneTape standardVolume standardLen;
end
