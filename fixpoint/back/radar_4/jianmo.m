function jianmo(p,showEnable,sj,storedata)
global handles1;
if(showEnable)
  %% plot of the current point cloud 
  scatter3(handles1.axes1,p(:,1),p(:,2),p(:,3),2.5,p(:,3),'filled'); 
  grid on;
  xlabel('x');ylabel('y');zlabel('z');
  scatter3(handles1.axes2,p(:,2),p(:,1),p(:,3),2.5,p(:,3),'filled');                        %plot della superficie trattata
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

path = cd;
filestr = strcat(path,'\');
filename1 = strcat(filestr,storedata(sj).filenam1,'.jpg')
h_fig = figure;
set(h_fig,'visible','off');
for i=1:r    
        col=(p(i,lno)+m)/n;
        plot3(p(i,1),p(i,2),p(i,3),'.','Color',[col 0.17 0.88],'MarkerSize',3);
        hold on;
end
axis equal;
grid on;
set(gca,'color',[0,0,0],'XColor','w','YColor','w','ZColor','w');
set(gcf,'color',[0,0,0]);
set(gcf, 'InvertHardCopy', 'off');
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
saveas(h_fig,filename1);
hold off;
disp('保存图片1完成');
fname='保存图片1完成';
set(handles1.statetext,'String',fname);

filename2 = strcat(filestr,storedata(sj).filenam2,'.jpg')
view([70 20]);
saveas(h_fig,filename2);
disp('保存图片2完成');
fname='保存图片2完成';
set(handles1.statetext,'String',fname);

filename3 = strcat(filestr,storedata(sj).filenam2,'.gif')
disp('生成GIF动画');
fname='生成GIF动画';
set(handles1.statetext,'String',fname);
h_fig = figure;
set(h_fig,'visible','off');
plot3(p(:,1),p(:,2),p(:,3),'w.','MarkerSize',3);
view([70 20]);
axis equal;
grid on;
set(gca,'color',[0,0,0],'XColor','r','YColor','r','ZColor','r');
set(gcf,'color',[0,0,0]);
set(gcf, 'InvertHardCopy', 'off');
title('Output Triangulation','fontsize',14);
xlabel('x');ylabel('y');zlabel('z');
genGif3D(1,storedata(sj).filenam2,h_fig);                                   %生成GIF动画
disp('gif已生成');                                                           %关闭figure，清空内存
fname='gif已生成';
set(handles1.statetext,'String',fname);

filename4 = strcat(path,'\UFileEX.dll');
NET.addAssembly(filename4);                                                 %指明dll文件的路径 
import UFileEX.*;                                                           %引用dll                                                         
key=strcat('test/',storedata(sj).filenam1,'.jpg');                          %云端key
upLoadfileDir = filename1;                                                  %上传文件路径            
output=UFile.Instance;                                                      %将类实例化 
b1=output.UploadFile(key,upLoadfileDir);                                    %上传文件

key=strcat('test/',storedata(sj).filenam2,'.jpg');                          %云端key
upLoadfileDir = filename2;                                                  %上传文件路径            
b1=output.UploadFile(key,upLoadfileDir);                                    %上传文件

key=strcat('test/',storedata(sj).filenam2,'.gif');                          %云端key
upLoadfileDir = filename3;                                                  %上传文件路径            
b1=output.UploadFile(key,upLoadfileDir);                                    %上传文件
