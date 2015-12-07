[r,l]=size(a);
if max(a(:,2))>4500
   a(:,2)=a(:,2)*4500/max(a(:,2));
end
a=spaceDownSampling(a,'cube3',1);
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
V2 = vpolyhedron2(a,t); 
V2=floor(V2);
disp(['The volume2 is: ',num2str((V2)/1000000000)]);
%***********************************************************%
%% 3D建模&体积测算
jianmo2(a,t);