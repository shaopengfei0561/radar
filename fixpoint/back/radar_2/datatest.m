%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% deltathrd = 250;                   % 三角形边长阈值，超过此阈值的三角形将被过滤掉
% a=load('yt121.txt');
% lno=3;
% %% 立方体过滤
% a = delBackground( a, 500);
% a=spaceDownSampling(a,'cube3',1);
% minval=min(a(:,lno));
% maxval=max(a(:,lno));
% if minval<0
%     m=abs(minval);
% else
%     m=-minval;
% end
% n=maxval-minval;
% [r,l]=size(a);
% fname=strcat('c:\fig\','1.jpg');
% h_fig = figure(1);
% tic
% set(h_fig,'visible','off');
% for i=1:r    
%         col=(a(i,lno)+m)/n;
%         plot3(a(i,1),a(i,2),a(i,3),'.','Color',[col 0.17 0.88],'MarkerSize',3);
%         hold on;
% end
% axis equal;
% xlabel('x');ylabel('y');zlabel('z');
% grid on;
% set(gca,'color',[0,0,0],'XColor','w','YColor','w','ZColor','w');
% set(gcf,'color',[0,0,0]);
% set(gcf, 'InvertHardCopy', 'off');
% hold off;
% % set(h_fig,'visible','on');
% toc
% tic
% saveas(h_fig, fname);
% fname=strcat('c:\fig\','2.jpg');
% view([40 30]);
% saveas(h_fig,fname);
% disp('保存图片2完成');
% toc
% h_fig=figure(2);
% set(h_fig,'visible','off');
% scatter3(a(:,1),a(:,2),a(:,3),15,a(:,3),'filled');
% axis equal;
% xlabel('x');ylabel('y');zlabel('z');
% grid on;
% set(gca,'color',[0,0,0],'XColor','w','YColor','w','ZColor','w');
% set(gcf,'color',[0,0,0]);
% tic
% fname=strcat('c:\fig\','1.jpg');
% % saveas(h_fig, fname);
% f=getframe(gcf);
% imwrite(f.cdata,fname);
% toc
clc;
p=load('yt12.txt');
p = delBackground( p, 500);
h_fig = figure;
% set(h_fig,'visible','off');
plot3(p(:,1),-p(:,2),p(:,3),'w.','MarkerSize',3);
view([70 20])
axis equal;
grid on;
set(gca,'color',[0,0,0],'XColor','r','YColor','r','ZColor','r');
set(gcf,'color',[0,0,0]);
set(gcf, 'InvertHardCopy', 'off');
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
% genGif3D1(1,num2str(2),h_fig);                                %生成GIF动画
disp('gif已生成');       