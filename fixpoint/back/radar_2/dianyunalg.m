function dianyunalg()
global toprestore;
global toprenum;
global hObject1 handles1;
global runstat;
global showEnable;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = str2num(paravalue.alg.trianthreshold);                          % 三角形边长阈值，超过此阈值的三角形将被过滤掉
%% 载入数据
for i=1:toprenum
    storedata(i).seq=0;              %库位号
    storedata(i).vol=0;              %库位体积测量结果
    storedata(i).filenam1=0;         %库位点云数据文件名
    storedata(i).filenam2=0;         %库位点云数据文件名
end
for sj=1:toprenum
    fname=strcat('yt',num2str(toprestore(sj)),'.txt');
    a=load(fname);
%% 自适应去背景
    backgroudThreshold = str2num(paravalue.alg.backgroudthreshold);
    a = delBackground(a, backgroudThreshold);
    [r,l]=size(a);
    if r~=0
%% 立方体过滤
    spaceDownLength = str2num(paravalue.alg.spacedownlength);
    if spaceDownLength~=0
        a=spaceDownSampling(a,'cube3',1,spaceDownLength);
    else
        a=spaceDownSampling(a,'cube3',1);
    end
    %% 坐标过滤（提取所需坐标点）
%   a=MySelect(a，1，toprestore(sj));                                   %1：根据y坐标过滤；2：根据库位配置文件过滤（根据库位四个顶点坐标进行过滤）
    %% 保存点云数据
    savedata(a,1,sj);
    %% 3D建模&体积测算
    jianmo(a,showEnable,sj);
%   v = calVolumeByPnts(a, 150, 0.57);
%   v = calVolumeByPnts(a, 150, 0.6709);
    volumeLength = str2num(paravalue.alg.volumelength);
    volumeRatio = str2num(paravalue.alg.volumeratio);
    v = calVolumeByPnts(a, volumeLength, volumeRatio)/1000000;
    fname=strcat('体积测量结果：',num2str(v/1e3),'立方米');
    set(handles1.text1,'String',fname);
    storedata(sj).seq=toprestore(sj);                       %库位号
    storedata(sj).vol=v;                                    %库位体积测量结果
    storedata(sj).filenam1=toprestore(sj)*2-1+100;          %库位点云数据文件名1
    storedata(sj).filenam2=toprestore(sj)*2+100;            %库位点云数据文件名2
    else
        storedata(sj).seq=toprestore(sj);                   %库位号
        storedata(sj).vol=0;                                %库位体积测量结果
        storedata(sj).filenam1=toprestore(sj)*2-1+100;          %库位点云数据文件名1
        storedata(sj).filenam2=toprestore(sj)*2+100;            %库位点云数据文件名2
        fname=strcat('体积测量结果：',num2str(0),'立方米');
        set(handles1.text1,'String',fname);
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);  
    end
end
%***********************************************************%
%% 发送测量数据 
send_meadata(storedata,1);
disp('通知云平台数据处理完成......');
% fname='通知云平台数据处理完成';
% set(handles1.statetext,'String',fname);
runstat=0;
end