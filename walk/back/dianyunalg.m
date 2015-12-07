function dianyunalg()
global toprestore;
global toprenum;
global hObject1 handles1;
global runstat;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = str2num(paravalue.alg.trianthreshold);                     % 三角形边长阈值，超过此阈值的三角形将被过滤掉
%% 载入数据
for i=1:toprenum
    storedata(i).seq=0;              %库位号
    storedata(i).vol=0;              %库位体积测量结果
    storedata(i).filenam1=0;         %库位点云数据文件名
    storedata(i).filenam2=0;         %库位点云数据文件名
end
for sj=1:toprenum
    fname=strcat(num2str(toprestore(sj)),'.txt');
    a=load(fname);
    %% 点云压缩（压缩采样）
    % dis=5;
    % a=MyCompress(a,dis);
    spaceDownLength = str2num(paravalue.alg.spacedownlength);
    if spaceDownLength~=0
        a=spaceDownSampling(a,'cube3',1,spaceDownLength);
    else
        a=spaceDownSampling(a,'cube3',1);
    end
    %% 自适应去除背景
    bgthred = str2num(paravalue.alg.backgroudthreshold); 
    a = delBackground(a, bgthred);
    [r,l]=size(a);
    if r~=0
    %% 立方体过滤
    %storeWidth = str2num(paravalue.alg.storewidth); 
    %if max(a(:,2))>storeWidth
    %a(:,2)=a(:,2)*storeWidth/max(a(:,2));
    %end
    %% 奇偶点过滤
    %dis=1:100;
    %disse=find(dis>=(r/60000));   
    %a=CubeCompress(a,dis(disse(1)));
    %% 坐标过滤（提取所需坐标点）
    %a=MySelect(a，1，toprestore(sj));                                     %1：根据y坐标过滤；2：根据库位配置文件过滤（根据库位四个顶点坐标进行过滤）
    %% 保存点云数据
    savedata(a,1,sj);
    %% 表面重建
    myCrustPara1 = str2num(paravalue.alg.mycrustpara1);
    myCrustPara2 = str2num(paravalue.alg.mycrustpara2);
    [t]=MyCrust(a,myCrustPara1,myCrustPara2);
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
        maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));  % 计算三角形最大边长
        if maxvalue>deltathrd                                              % 三角形边长阈值，超过此阈值的三角形将被过滤掉
            t(i+1,:)=0;
        end
    end
    %% 删除0点
    row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
    t=t(row,:);
    %% 保存轮廓重建数据
    savedata(t,2,sj);
    %***********************************************************%
    %% 3D建模&体积测算
    jianmo(a,t,sj);
    % 体积算法一：三角剖分投影
    % v = vpolyhedron2(a,t,400)/1000000;
    % v = 0.6*vpolyhedron2(a,t,0)/1000000;
    % v = floor(v);
    % disp(['The volume is: ',num2str(v)]);
    
    % 体积算法二：立方体网格
    volumeLength = str2num(paravalue.alg.volumelength);
    volumeRatio = str2num(paravalue.alg.volumeratio);
    v = calVolumeByPnts(a, volumeLength, volumeRatio);
    v=floor(v/1000000);
    disp(['The volume2 is: ',num2str((v))]);
    
    fname=strcat('体积测量结果：',num2str(v),'立方分米');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                       %库位号
    storedata(sj).vol=v;                                    %库位体积测量结果
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
disp('通知云平台数据处理完成......');
send_meadata(storedata,1);
runstat=0;
end