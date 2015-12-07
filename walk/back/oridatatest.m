clc;
close all;
clear all;
global paravalue;
paravalue=ini2struct('Config.ini');
filename=5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 250;                   % 三角形边长阈值，超过此阈值的三角形将被过滤掉
file=['z',num2str(filename),'.txt'];
a=load(file);
%% 立方体过滤
% a = spaceDownSampling( a, 'cube', 1, 25  );
a=spaceDownSampling(a,'cube3',1);
a = delBackground(a, 800);
[r,l]=size(a);
% if max(a(:,2))>4500
%    a(:,2)=a(:,2)*4500/max(a(:,2));
% end
%***********************************************************%
%% 点云压缩（压缩采样）
% dis=5;
% a=MyCompress(a,dis);
%% 奇偶点过滤
% a=CubeCompress(a,10);
%% 坐标过滤（提取所需坐标点）
% m_a=MySelect(a，1，toprestore(sj));                                   %1：根据y坐标过滤；2：根据库位配置文件过滤（根据库位四个顶点坐标进行过滤）
% savedata(a,3,filename);
%% 表面重建
% [t]=MyCrust(a,540,0.95);
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
[m,n]=size(t);
%% 读入坐标
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
%% 3D建模&体积测算
% V2 = vpolyhedron2(a,t,400);
V1 = vpolyhedron2(a,t,0)*0.6; 
V1=floor(V1);
disp(['The volume1 is: ',num2str((V1)/1000000)]);
V2 = calVolumeByPnts(a, 30, 0.85);
V2=floor(V2);
disp(['The volume2 is: ',num2str((V2)/1000000)]);
%***********************************************************%
jianmo2(a,t);