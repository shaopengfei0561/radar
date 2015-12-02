function dianyunalg(sj)
global toprenum;
global handles1;
global runstat;
global showEnable;
global paravalue;
global storeconfig;
global deviceID;
global flag_SFMODE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = str2num(paravalue.alg.trianthreshold);                          % 三角形边长阈值，超过此阈值的三角形将被过滤掉
%% 载入数据
for i=1:toprenum
    storedata(i).storeid=0;          %库号
    storedata(i).seq=0;              %库号
    storedata(i).vol=0;              %库位体积测量结果
    storedata(i).filenam1=0;         %库位点云数据文件名
    storedata(i).filenam2=0;         %库位点云数据文件名
end
for sj=1:toprenum
    fname=strcat('oridata_','z',num2str(deviceID),'z',num2str(storeconfig(sj,2)),'.txt');
    m_a=load(fname);
    a=m_a(:,1:3);
%% 自适应去背景
    backgroudThreshold = str2num(paravalue.alg.backgroudthreshold);
%   a = delBackground(a, backgroudThreshold);
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
    %% 3D建模&体积测算
    volumeLength = str2num(paravalue.alg.volumelength);
    volumeRatio = str2num(paravalue.alg.volumeratio);
    v = calVolumeByPnts(a, volumeLength, volumeRatio)/1000000;
    fname=strcat('体积测量结果：',num2str(v/1e3),'立方米');
    set(handles1.statetext,'String',fname);
    storedata(sj).storeid=storeconfig(sj,1);                %库号
    storedata(sj).seq=storeconfig(sj,2);                    %库位号
    storedata(sj).vol=v;                                    %库位体积测量结果
    m_clock=fix(clock);
    for i=2:6
        if m_clock(i)<10
           picname(2*i+1:2*i+2)= strcat('0',num2str(m_clock(i)));
        else
           picname(2*i+1:2*i+2)= num2str(m_clock(i));
        end
    end
    picname(1:4) = num2str(m_clock(1));
    if storeconfig(sj,2)*2-1<10
       picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2-1));
    else
       picname(15:16) = num2str(storeconfig(sj,2)*2-1);
    end
    storedata(sj).filenam1=picname; %库位点云数据文件名1
    if storeconfig(sj,2)*2<10
       picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2));
    else
       picname(15:16) = num2str(storeconfig(sj,2)*2);
    end
    storedata(sj).filenam2=picname;   %库位点云数据文件名2
    
%     jianmo(a,showEnable,sj,storedata);
    else
        m_clock=fix(clock);
        for i=2:6
            if m_clock(i)<10
               picname(2*i+1:2*i+2)= strcat('0',num2str(m_clock(i)));
            else
               picname(2*i+1:2*i+2)= num2str(m_clock(i));
            end
        end
        picname(1:4) = num2str(m_clock(1));
        if storeconfig(sj,2)*2-1<10
           picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2-1));
        else
           picname(15:16) = num2str(storeconfig(sj,2)*2-1);
        end
        storedata(sj).filenam1=picname;                         %库位点云数据文件名1
        if storeconfig(sj,2)*2<10
           picname(15:16) = strcat('0',num2str(storeconfig(sj,2)*2));
        else
           picname(15:16) = num2str(storeconfig(sj,2)*2);
        end
        storedata(sj).filenam2=picname;                         %库位点云数据文件名2
        storedata(sj).seq=storeconfig(sj,2);                    %库位号
        storedata(sj).storeid=storeconfig(sj,1);                %库号
        storedata(sj).vol=0;                                    %库位体积测量结果
        fname=strcat('体积测量结果：',num2str(0),'立方米');
        set(handles1.statetext,'String',fname);
        savedata(a,1,sj);
        t=[];
        savedata(t,2,sj);  
    end
end
%***********************************************************%
%% 发送测量数据
if flag_SFMODE~=1
send_meadata(storedata,1);
disp('通知云平台数据处理完成......');
fname='通知云平台数据处理完成';
set(handles1.statetext,'String',fname);
end
runstat=0;
end