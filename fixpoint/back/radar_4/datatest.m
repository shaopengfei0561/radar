%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deltathrd = 250;                   % 三角形边长阈值，超过此阈值的三角形将被过滤掉
a=load('ren1.txt');
lno=2;
%% 立方体过滤
% a=spaceDownSampling(a,'cube3',1,5);
% minval=min(a(:,lno));
% maxval=max(a(:,lno));
% if minval<0
%     m=abs(minval);
% else
%     m=-minval;
% end
% n=maxval-minval;
% [r,l]=size(a);
% fname=strcat('c:\fig\','1.fig');
% h_fig = figure;
% set(h_fig,'visible','off');
% for i=1:r    
%         col=(a(i,lno)+m)/n;
%         plot3(a(i,1),a(i,2),a(i,3),'.','Color',[col 0.17 0.88]);
%         hold on;
% end
% axis equal;
% xlabel('x');ylabel('y');zlabel('z');
% saveas(h_fig, fname);
% hold off;
% set(h_fig,'visible','on');
figure;
% scatter3(a(:,2),a(:,3),a(:,1),15,a(:,3),'filled');
scatter3(a(:,1),a(:,2),a(:,3),15,a(:,3),'filled');
axis equal;
figure;
scatter3(a(:,1),a(:,2),a(:,3),15,a(:,3),'filled');
view(-170,0);
axis equal;