function [ dataOut ] = spaceDownSampling( dataIn, method, varargin  )
% 点云数据空间降采样
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/4/7
% 例子：
%   dataOut = spaceDownSampling( dataIn, 'cube', 1, 25  );
%       采用cube方法，取顶点滤波，立方体半径25mm

nVarargs = length(varargin);
dataOut = [];
%% 方法1：空间立方体降采样，取落在立方体里点的平均值或单纯取立方体的某个顶点
if strcmp(method, 'cube')
  if(nVarargs~=2)
    error('the number of parameter is not correct!');
  else
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % 降采样方式，1为取顶点，2为取落在立方体里点的平均值
    cubeLen = varargin{2};
    Nx = ceil((borderUp(1)-borderDown(1))/cubeLen);
    Ny = ceil((borderUp(2)-borderDown(2))/cubeLen);
    Nz = ceil((borderUp(3)-borderDown(3))/cubeLen);
    for i=1:Nx
      for j=1:Ny
        for k=1:Nz
          curDown = [borderDown(1)+(i-1)*cubeLen borderDown(2)+(j-1)*cubeLen borderDown(3)+(k-1)*cubeLen];
          curUp = [borderDown(1)+i*cubeLen borderDown(2)+j*cubeLen borderDown(3)+k*cubeLen];
          temp1 = find( (dataIn(:,1)>=curDown(1)) & (dataIn(:,1)<curUp(1)) );
          temp2 = find( (dataIn(:,2)>=curDown(2)) & (dataIn(:,2)<curUp(2)) );
          temp3 = find( (dataIn(:,3)>=curDown(3)) & (dataIn(:,3)<curUp(3)) );
          temp4 = intersect(temp1,temp2);
          temp5 = intersect(temp3,temp4);
          if ~isempty(temp5)
            if(subMethod==1)
              temp = curUp;
            else
              temp = mean(dataIn(temp5,:));
            end
            dataOut = [dataOut; temp];
          end
        end
      end
    end
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  end
  %% 方法1：空间立方体降采样，取落在立方体里点的平均值或单纯取立方体的某个顶点(采用Hu的方法提升效率，最优)
elseif strcmp(method, 'cube3')
  if(nVarargs>2)
    error('the number of parameter is not correct!');
  elseif(nVarargs==2)
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % 降采样方式，1为取顶点，2为取立方体的中心
    cubeLen = varargin{2};
    tempData = dataIn; % - ones(length(dataIn),1)*borderDown;
    tempData = floor(tempData/cubeLen);
    dataOut = unique(tempData,'rows');
    dataOut = dataOut*cubeLen; %  + ones(length(dataOut),1)*borderDown
    if(subMethod==2)
      dataOut = dataOut+cubeLen/2;
    end
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  elseif(nVarargs==1)
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % 降采样方式，1为取顶点，2为取立方体的中心
    cubeLen = 25; % 初始值
    flag = 1;
    while(flag)
      tempData = dataIn; % - ones(length(dataIn),1)*borderDown;
      tempData = floor(tempData/cubeLen);
      dataOut = unique(tempData,'rows');
      dataOut = dataOut*cubeLen; % + ones(length(dataOut),1)*borderDown;
      if(subMethod==2)
        dataOut = dataOut+cubeLen/2;
      end
      if(length(dataOut)>=65000)
        cubeLen = cubeLen+10;
        flag = 1;
      else
        flag = 0;
      end
    end    
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  end

  %% 方法2：丢点降采样
elseif strcmp(method, 'skipPoint')
  if(nVarargs>1)
    error('the number of parameter is not correct!');
  else
    if(nVarargs==1)
      skipPointNumber = varargin{1};
    elseif(nVarargs==0)
      skipPointNumber = ceil(length(dataIn)/65000); % 假设最多保留65000个顶点
    end
    if(skipPointNumber<=1)
      dataOut = dataIn;
      dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
      return;
    end
    index = 1:skipPointNumber:length(dataIn);
    dataOut = dataIn(index,:);
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  end
end

