function dianyunalg2() % created by YZJ
global toprestore;
global toprenum;
global hObject1 handles1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 100;                   % 三角形边长阈值，超过此阈值的三角形将被过滤掉
%% 载入数据
for i=1:21
    storedata(i).seq=0;             %库位号
    storedata(i).vol=0;             %库位体积测量结果
    storedata(i).filenam=0;         %库位点云数据文件名
end
for sj=1:toprenum
    fname=strcat('oridata_',num2str(toprestore(sj)),'.txt');
    a=load(fname);
    [r,l]=size(a);
    if r~=0
    %***********************************************************%
    %% 点云压缩（压缩采样）
    % dis=5;
    % a=MyCompress(a,dis);
    %% 立方体过滤
    % [a] = spaceDownSampling( a, 'cube', 1, 25  );
    a=spaceDownSampling(a,'cube3',1);
    %% 奇偶点过滤
%     dis=1:100;
%     disse=find(dis>=(r/60000));   
%     a=CubeCompress(a,dis(disse(1)));
    %% 坐标过滤（提取所需坐标点）
    % a=MySelect(a，1，toprestore(sj));                                   %1：根据y坐标过滤；2：根据库位配置文件过滤（根据库位四个顶点坐标进行过滤）
    %% 保存点云数据
    % savedata(a,1,sj);
    %% 表面重建
    [t]=MyCrust(a);
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
    % savedata(t,2,sj);
    %***********************************************************%
    %% 3D建模&体积测算
    % jianmo(a,t);
    v = vpolyhedron2(a,t)/1000000;
    v = floor(v);
    
    %% ----------------读入标准物体的轮廓数据
    load('dataOneTape.mat');
    dataOneTape=unique(dataOneTape,'rows');
    nTapes = floor(v/standardVolume);
    disp(['The simulated target number is: ' num2str(nTapes)]);
    
    %% ----------------得到在哪些立方格处放置标准钢卷
    [a2,ind1,ind2] = spaceMapping( a, 'cube3', 1, (1+0.2)*standardLen ); %
    n1 = length(ind1);
    if(n1>nTapes)
      nHist = histc(ind2,1:n1);
      [B,IX] = sort(nHist,'descend');
      a2 = a2(IX(1:nTapes),:);
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
    %     dis=1:100;
    %     disse=find(dis>=(r/60000));
    %     a=CubeCompress(a,dis(disse(1)));
    %% 坐标过滤（提取所需坐标点）
    % a=MySelect(a，1，toprestore(sj));                                   %1：根据y坐标过滤；2：根据库位配置文件过滤（根据库位四个顶点坐标进行过滤）
    %% 保存点云数据
    savedata(a,1,sj);
    %% 表面重建
    disp('/\/\/\/\/\/\/\/\/\/\/\/\/\/round 2\/\/\/\/\/\/\/\/\/\/\/\/\/');
    [t]=MyCrust(a);
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
    jianmo(a,t);
    
    disp(['The volume is: ',num2str(v)]);
    fname=strcat('体积测量结果：',num2str(v),'立方分米');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                   %库位号
    storedata(sj).vol=v;                        %库位体积测量结果
    storedata(sj).filenam=toprestore(toprenum);         %库位点云数据文件名
    else
        storedata(sj).seq=toprestore(sj);                   %库位号
        storedata(sj).vol=0;                                %库位体积测量结果
        storedata(sj).filenam=toprestore(toprenum);         %库位点云数据文件名
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);
    end
end
storedata(21).vol=0;                                    %整个库区体积测量结果
storedata(21).filenam=21;                               %整个库区点云数据文件名
%***********************************************************%
%% 发送测量数据 
data_send(storedata,1);
end