function [ dataOut, varargout ] = spaceMapping1( dataIn, method, varargin  )
% ���ڵ������ݽ�����Ŀ����пռ�λ�õ�ӳ�䣬����spaceMapping��д--------------------------������ȥ���������ݣ�������������������
%   Detailed explanation goes here
%   yuzhijun@wsn.cn, 2015/5/14
% ���ӣ�
%   dataOut = spaceMapping( dataIn, 'cube', 1, 25  );
%       ����cube������ȡ�����˲���������뾶25mm

nVarargs = length(varargin);
dataOut = [];
%% ����1���ռ������彵������ȡ��������������ƽ��ֵ�򵥴�ȡ�������ĳ������
if strcmp(method, 'cube')
  if(nVarargs~=2)
    error('the number of parameter is not correct!');
  else
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % ��������ʽ��1Ϊȡ���㣬2Ϊȡ��������������ƽ��ֵ
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
  %% ����1���ռ������彵������ȡ��������������ƽ��ֵ�򵥴�ȡ�������ĳ������(����Hu�ķ�������Ч�ʣ�����)
elseif strcmp(method, 'cube3')
  if(nVarargs>4)
    error('the number of parameter is not correct!');
  elseif(nVarargs==2)
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % ��������ʽ��1Ϊȡ���㣬2Ϊȡ�����������
    cubeLen = varargin{2};
    tempData = dataIn; % - ones(length(dataIn),1)*borderDown;
    tempData = floor(tempData/cubeLen);
    [dataOut, tempOut1, tempOut2] = unique(tempData,'rows','stable');
    varargout{1} = tempOut1;
    varargout{2} = tempOut2;
    dataOut = dataOut*cubeLen; %  + ones(length(dataOut),1)*borderDown
    if(subMethod==2)
      dataOut = dataOut+cubeLen/2;
    end
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  elseif(nVarargs==4)
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % ��������ʽ��1Ϊȡ���㣬2Ϊȡ�����������
    cubeLen1 = varargin{2}; % �߶��ϵĳ߶�
    cubeLen2 = varargin{3}; % ƽ���ϵĳ߶�
    nTargets = varargin{4}; % ��׼����ĸ���
    % cubeLen2 = 1300; % ��ʼֵ
    flag = 1;
    while(flag)
      tempData = dataIn; % - ones(length(dataIn),1)*borderDown;
      tempData1 = ones(length(tempData),1); 
      tempData2 = floor(tempData(:,1:2)/cubeLen2);
      tempData = [tempData2,tempData1];
      [dataOut, tempOut1, tempOut2] = unique(tempData,'rows');
      varargout{1} = cubeLen1;
      varargout{2} = cubeLen2;
      dataOut = [dataOut(:,1:2)*cubeLen2,dataOut(:,3)*cubeLen1]; % + ones(length(dataOut),1)*borderDown;
      if(nTargets>0)
        if(length(dataOut)>nTargets) 
          cubeLen2 = cubeLen2+5;
          flag = 1;
        else
          flag = 0;
        end
      else
        flag = 0;
        varargout{1} = tempOut1;
        varargout{2} = tempOut2;
      end
    end
    % disp(['cube length is: ' num2str(cubeLen2)]);
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  elseif(nVarargs==1)
    borderUp = max(dataIn);
    borderDown = min(dataIn);
    subMethod = varargin{1};  % ��������ʽ��1Ϊȡ���㣬2Ϊȡ�����������
    cubeLen = 25; % ��ʼֵ
    % cubeLen = 1500; % ��ʼֵ
    flag = 1;
    while(flag)
      tempData = dataIn; % - ones(length(dataIn),1)*borderDown;
      tempData = floor(tempData/cubeLen);
      [dataOut, tempOut1, tempOut2] = unique(tempData,'rows','stable');
      varargout{1} = tempOut1;
      varargout{2} = tempOut2;
      dataOut = dataOut*cubeLen; % + ones(length(dataOut),1)*borderDown;
      if(subMethod==2)
        dataOut = dataOut+cubeLen/2;
      end
      if(length(dataOut)>=65000) % 67
        cubeLen = cubeLen+2;
        flag = 1;
      else
        flag = 0;
      end
    end
    disp(['cube length is: ' num2str(cubeLen)]);
    dlmwrite('dataOut.txt', dataOut, 'delimiter', '\t','precision', 6);
  end
end

