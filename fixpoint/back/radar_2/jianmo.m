function jianmo(p,showEnable,sj)
global toprestore;
global hObject1 handles1;
if(showEnable)
  %% plot of the current point cloud 
  scatter3(handles1.axes2,p(:,1),-p(:,2),p(:,3),2.5,p(:,3),'filled'); 
  grid on;
  xlabel('x');ylabel('y');zlabel('z');
  scatter3(handles1.axes3,-p(:,2),p(:,1),p(:,3),2.5,p(:,3),'filled');                        %plot della superficie trattata
  view([70 20]);
  grid on;
  xlabel('x');ylabel('y');zlabel('z');
end
%% plot of the oyput triangulation
lno=1;
minval=min(p(:,lno));
maxval=max(p(:,lno));
if minval<0
    m=abs(minval);
else
    m=-minval;
end
n=maxval-minval;
[r,l]=size(p);

filename=strcat('c:\web\resources\',num2str(toprestore(sj)*2-1+100),'.jpg');
h_fig = figure;
% set(h_fig,'visible','off');
%for i=1:r    
%        col=(p(i,lno)+m)/n;
%        plot3(p(i,1),-p(i,2),p(i,3),'.','Color',[col 0.17 0.88],'MarkerSize',3);
%        hold on;
%end
x=p(:,1);
y=-p(:,2);
z=p(:,3);
c=z+1;
scatter3(x,y,z,1,c,'filled'); 
hold on;

axis equal;
grid on;
set(gca,'color',[0,0,0],'XColor','w','YColor','w','ZColor','w');
set(gcf,'color',[0,0,0]);
set(gcf, 'InvertHardCopy', 'off');
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
saveas(h_fig,filename);
hold off;
disp('保存图片1完成');


filename=strcat('c:\web\resources\',num2str(toprestore(sj)*2+100),'.jpg');
view([70 20]);
saveas(h_fig,filename);
disp('保存图片2完成');

disp('生成GIF动画');
h_fig = figure;
set(h_fig,'visible','off');
plot3(p(:,1),-p(:,2),p(:,3),'w.','MarkerSize',3);
view([70 20]);
axis equal;
grid on;
set(gca,'color',[0,0,0],'XColor','r','YColor','r','ZColor','r');
set(gcf,'color',[0,0,0]);
set(gcf, 'InvertHardCopy', 'off');
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
genGif3D1(1,num2str(toprestore(sj)*2+100),h_fig);                                %生成GIF动画
disp('gif已生成');                                                              %关闭figure，清空内存