clc;
% close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deltathrd = 150;                   % �����α߳���ֵ����������ֵ�������ν������˵�
a=load('oridata_z1z11.txt');
% ����Ӧȥ������
% a = delBackground(a, 500);
% if max(a(:,2))>4500
%    a(:,2)=a(:,2)*4500/max(a(:,2));
% end
%***********************************************************%
%% ����ѹ����ѹ��������
% dis=5;
% a=MyCompress(a,dis);
%% ���������
% a=spaceDownSampling(a,'cube3',1,30);
h_fig = figure;
set(h_fig,'visible','on');
plot3(a(:,1),a(:,2),-a(:,3),'g.');
xlabel('x');ylabel('y');zlabel('z');
axis equal;
[r,l]=size(a);
%% ��ż�����
% a=CubeCompress(a,10);
%% ������ˣ���ȡ��������㣩
% m_a=MySelect(a��1��toprestore(sj));                                   %1������y������ˣ�2�����ݿ�λ�����ļ����ˣ����ݿ�λ�ĸ�����������й��ˣ�
%% �����ؽ�
% [t]=MyCrust(a,540,0.95);
% [m,n]=size(t);
% %% ɾ�������
% [a_m,a_n]=size(a);
% for i=1:m
%     for j=1:3    
%         if t(i,j)>a_m
%            t(i,:)=0;
%         end
%     end
% end
% row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
% t=t(row,:);
% [m,n]=size(t);
% %% ��������
% k=1;
% for i=1:m
%     for j=1:3    
%     x(k)=a(t(i,j),1);
%     y(k)=a(t(i,j),2);
%     z(k)=a(t(i,j),3);
%     k=k+1;
%     end
% end
% %% ȥ��ճ��������
% for i=0:(k/3-1)
%     maxvalue = Maxline(x(3*i+1:3*i+3),y(3*i+1:3*i+3),z(3*i+1:3*i+3));       % �������������߳�
%     if maxvalue>deltathrd                                                   % �����α߳���ֵ����������ֵ�������ν������˵�
%         t(i+1,:)=0;
%     end
% end
% %% ɾ��0��
% row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
% t=t(row,:);
%V2 = vpolyhedron2(a,t,400); 
% V2 = vpolyhedron2(a,t,0)*0.6; 
% V2=floor(V2);
% disp(['The volume2 is: ',num2str((V2)/1000000)]);
% v = calVolumeByPnts(a, 30, 1);
%***********************************************************%
%% 3D��ģ&�������
% jianmo2(a,t);
% savedata(a,1,1);
% savedata(t,2,1);