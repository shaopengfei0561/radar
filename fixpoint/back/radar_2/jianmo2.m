function jianmo2(p,t)
tic
%% plot of the current point cloud
% filename=strcat('1.jpg');
% h_fig=figure(1);
% scatter3(p(:,1),p(:,2),p(:,3),2.5,p(:,3),'filled');
% axis equal;
% grid on;
% set(gca,'color',[0.1,0.1,0.1],'XColor','w','YColor','w','ZColor','w');
% set(gcf,'color',[0.1,0.1,0.1]);
% title('Points Cloud','fontsize',14);
% xlabel('x');ylabel('y');zlabel('z');
% view([150 60]);
% h_fig=figure(2);
% scatter3(p(:,1),p(:,2),p(:,3),2.5,p(:,3),'filled');
% axis equal;
% grid on;
% set(gca,'color',[0.1,0.1,0.1],'XColor','w','YColor','w','ZColor','w');
% set(gcf,'color',[0.1,0.1,0.1]);
% title('Points Cloud','fontsize',14);
% xlabel('x');ylabel('y');zlabel('z');
% view([110 30]);
% f=getframe(gcf);
% imwrite(f.cdata,filename);
% genGif3D(1,num2str(1*2+100),h_fig);                                %生成GIF动画
% close(h_fig);       
%% 去除多余点
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
h_fig=figure(3);
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','b','edgecolor','none'); %plot della superficie trattata
% trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b'); %plot della superficie trattata
axis equal;
grid on;
set(gca,'color',[0.1,0.1,0.1],'XColor','w','YColor','w','ZColor','w');
set(gcf,'color',[0.1,0.1,0.1]);
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
shading interp;
camlight left;
lighting phong;
toc
tic
fname=strcat('c:\fig\','1.jpg');
saveas(h_fig, fname);
toc
end