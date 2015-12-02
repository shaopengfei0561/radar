function dianyunalg2() % created by YZJ
global toprestore;
global toprenum;
global hObject1 handles1;
global runstat;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 250;                   % 三角形边长阈值，超过此阈值的三角形将被过滤掉
%% 载入数据
for i=1:20
    storedata(i).seq=0;             %库位号
    storedata(i).vol=0;             %库位体积测量结果
    storedata(i).filenam=0;         %库位点云数据文件名
end
for sj=1:toprenum
    % fname=strcat('oridata_',num2str(toprestore(sj)),'.txt');
    fname=strcat(num2str(toprestore(sj)),'.txt');
    a=load(fname);
    [r,l]=size(a);
    if r~=0
    v = calVolumeByPnts(a, 30, 0.85);
    v=floor(v/1000000);
    
    %% ----------------读入标准物体的轮廓数据
    load('dataOneTape.mat');
    dataOneTape=unique(dataOneTape,'rows');
    nTapes = floor(v/standardVolume);
    disp(['The simulated target number is: ' num2str(nTapes)]);
    
    %% ----------------得到在哪些立方格处放置标准钢卷
    cubeLen = (1+0.2)*standardLen;
    len = 30; % 先做降采样，边长
    aTemp = spaceDownSampling( a, 'cube3', 1, len);
    % [a1Out, ind1, ind2] = spaceMapping2( aTemp, 'cube3', 1, cubeLen);
    [a1Out, ind1, ind2] = spaceMapping2( aTemp, 'cube3', 1, cubeLen, cubeLen, 5000/2, 0 );  % 限定为两排的效果，符合中储目前的堆放方式20150617
    nTapesVec = [];
    for ii=1:size(a1Out,1)
      tempInd = find(ind2==ii);
      tempHigh = max(aTemp(tempInd,3));
      nTapesVec = [nTapesVec; floor(tempHigh/cubeLen)+1];
    end
    nTapesCur = sum(nTapesVec);
    if(nTapesCur>nTapes)
      n1 = length(ind1);
      % 映射数目可能比需要的数目多，末位淘汰
      nHist = histc(ind2,1:n1);
      [B,IX] = sort(nHist,'descend');
      a1Out = a1Out(IX,:);
      nTapesVec = nTapesVec(IX,:);
      for j=1:n1
        nTapesCur = sum(nTapesVec(1:n1-j));
        if(nTapesCur<=nTapes)
          break;
        end
      end
      a1Out = a1Out(1:n1-j,:);
      nTapesVec = nTapesVec(1:n1-j);
    end
    a2 = [];
    for i=1:size(a1Out,1)
      for j=1:nTapesVec(i)
        tempdata = [a1Out(i,1:2) cubeLen*(j-1)];
        a2 = [a2; tempdata];
      end
    end
    
    %% ----------------生成目标数据
    rawData = [];
    for i=1:length(a2)
      tempdata1 = dataOneTape(:,1)+a2(i,1)+standardLen*0.2*rand;
      tempdata2 = dataOneTape(:,2)+a2(i,2)+standardLen*0.2*rand;
      tempdata3 = dataOneTape(:,3)+a2(i,3)+standardLen*0.2*rand;
      tempdata = [tempdata1,tempdata2,tempdata3];
      rawData = [rawData;tempdata];
    end
    dlmwrite('simulatedData.txt', rawData, 'delimiter', '\t','precision', 6);
    
    %% ----------------再次基于标准数据进行剖分及显示
    a = rawData;
    %% 立方体过滤
    % [a] = spaceDownSampling( a, 'cube', 1, 25  );
    a=spaceDownSampling(a,'cube3',1);
    %% 奇偶点过滤
    %dis=1:100;
    %disse=find(dis>=(r/60000));
    %a=CubeCompress(a,dis(disse(1)));
    %% 坐标过滤（提取所需坐标点）
    %a=MySelect(a，1，toprestore(sj));                                   %1：根据y坐标过滤；2：根据库位配置文件过滤（根据库位四个顶点坐标进行过滤）
    %% 保存点云数据
    savedata(a,1,sj);
    %% 表面重建
    disp('/\/\/\/\/\/\/\/\/\/\/\/\/\/round 2\/\/\/\/\/\/\/\/\/\/\/\/\/');
    [t]=MyCrust(a,500,0.05);
    [m,n]=size(t);
    %% 删除多余点
    [a_m,a_n]=size(a);
    for i=1:m
      for j=1:3
        if t(i,j)>a_m
          t(i,:)=0;
        end
      end
    end
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
    %% 读入坐标
    [m,n]=size(t);
    k=1;
    for i=1:m
      for j=1:3
        x(k)=a(t(i,j),1);
        y(k)=a(t(i,j),2);
        z(k)=a(t(i,j),3);
        k=k+1;
      end
    end
    %% 去除粘连三角形
    for i=0:(k/3-1)
      maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));       % 计算三角形最大边长
      if maxvalue>deltathrd                                                   % 三角形边长阈值，超过此阈值的三角形将被过滤掉
        t(i+1,:)=0;
      end
    end
    %% 删除0点
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
    %% 保存轮廓重建数据
    savedata(t,2,sj);
    %% 3D显示
    jianmo(a,t,sj);
    disp(['The volume is: ',num2str(v)]);
    fname=strcat('体积测量结果：',num2str(v),'立方分米');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                   %库位号
    storedata(sj).vol=v;                                %库位体积测量结果
    storedata(sj).filenam1=toprestore(sj)*2-1;              %库位点云数据文件名1
    storedata(sj).filenam2=toprestore(sj)*2;                %库位点云数据文件名2
    else
        storedata(sj).seq=toprestore(sj);                   %库位号
        storedata(sj).vol=0;                                %库位体积测量结果
        storedata(sj).filenam1=toprestore(sj)*2-1;          %库位点云数据文件名1
        storedata(sj).filenam2=toprestore(sj)*2;            %库位点云数据文件名2 
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);
    end
end
%***********************************************************%
%% 发送测量数据 
send_meadata(storedata,1);
runstat=1;
end