function jianmo(p,t)
%% plot of the current point cloud
figure(1);
plot3(p(:,1),p(:,2),p(:,3),'g.');
axis equal;
title('Points Cloud','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
%% È¥³ý¶àÓàµã
[m,n]=size(t);
[p_m,p_n]=size(p);
for i=1:m
    for j=1:3    
    if t(i,j)>p_m
       t(i,:)=0;
    end
    end
end
row=find(abs(t(:,1))+abs(t(:,2))+abs(t(:,3))>0);
t=t(row,:);
%% plot of the oyput triangulation
figure(2);
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','b','edgecolor','none'); %plot della superficie trattata
axis equal;
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
shading interp;
camlight left;
lighting phong;
end