function jianmo(p,t,sj)
global toprestore;
A1=evalin('base','toprestore');  %spmd中不可有全局变量
global hObject1 handles1;
guidata(hObject1,handles1);
global showEnable;
%A2=evalin('base','showEnable');
startmatlabpool(2);   %启动并行计算环境
if(showEnable)
  %% plot of the current point cloud
  axes(handles1.axes2);
  plot3(p(:,1),p(:,2),p(:,3),'g.');
  title('Points Cloud','fontsize',14);
  xlabel('x');ylabel('y');zlabel('z');
  axis equal;
end
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
spmd   %任务并行计算
fname=strcat('c:\web\resources\',num2str(A1(sj)*2-1),'.jpg');
% fname=strcat('d:\radar\output\',num2str(toprestore(sj)*2-1),'.jpg');
h_fig = figure;
set(h_fig,'visible','off');
trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b'); %plot della superficie trattata
axis equal;
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
shading interp;
camlight left;
lighting phong;
saveas(h_fig, fname);

fname=strcat('c:\web\resources\',num2str(A1(sj)*2),'.jpg');
% fname=strcat('d:\radar\output\',num2str(toprestore(sj)*2),'.jpg');
view([-120 30]);
saveas(h_fig, fname);
disp('genGif3D');
tic;

genGif3D(1,num2str(A1(sj)*2),h_fig); % 生成GIF动画
%close(h_fig);               %关闭figure，清空内存
toc;
end
if(showEnable)
  axes(handles1.axes3);
  trisurf(t,p(:,1),p(:,2),p(:,3),'facecolor','c','edgecolor','b'); %plot della superficie trattata
  axis equal;
  title('Output Triangulation','fontsize',14);
  xlabel('x');ylabel('y');zlabel('z');
  shading interp;
  camlight left;
  lighting phong;
end
matlabpool close;%终止并行计算环境