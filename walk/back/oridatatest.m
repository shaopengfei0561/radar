clc;
close all;
clear all;
global paravalue;
paravalue=ini2struct('Config.ini');
filename=5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 250;                   % �����α߳���ֵ����������ֵ�������ν������˵�
file=['z',num2str(filename),'.txt'];
a=load(file);
%% ���������
% a = spaceDownSampling( a, 'cube', 1, 25  );
a=spaceDownSampling(a,'cube3',1);
a = delBackground(a, 800);
[r,l]=size(a);
% if max(a(:,2))>4500
%    a(:,2)=a(:,2)*4500/max(a(:,2));
% end
%***********************************************************%
%% ����ѹ����ѹ��������
% dis=5;
% a=MyCompress(a,dis);
%% ��ż�����
% a=CubeCompress(a,10);
%% ������ˣ���ȡ��������㣩
% m_a=MySelect(a��1��toprestore(sj));                                   %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
% savedata(a,3,filename);
%% �����ؽ�
% [t]=MyCrust(a,540,0.95);
[t]=MyCrust(a,500,0.05);
[m,n]=size(t);
%% ɾ�������
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
%% ��������
k=1;
for i=1:m
    for j=1:3    
    x(k)=a(t(i,j),1);
    y(k)=a(t(i,j),2);
    z(k)=a(t(i,j),3);
    k=k+1;
    end
end
%% ȥ��ճ��������
for i=0:(k/3-1)
    maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));       % �������������߳�
    if maxvalue>deltathrd                                                   % �����α߳���ֵ����������ֵ�������ν������˵�
        t(i+1,:)=0;
    end
end
%% ɾ��0��
row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
t=t(row,:);
%% 3D��ģ&�������
% V2 = vpolyhedron2(a,t,400);
V1 = vpolyhedron2(a,t,0)*0.6; 
V1=floor(V1);
disp(['The volume1 is: ',num2str((V1)/1000000)]);
V2 = calVolumeByPnts(a, 30, 0.85);
V2=floor(V2);
disp(['The volume2 is: ',num2str((V2)/1000000)]);
%***********************************************************%
jianmo2(a,t);