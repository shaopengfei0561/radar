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
disp('����ͼƬ1���');
fname='����ͼƬ1���';
set(handles1.statetext,'String',fname);

filename2 = strcat(filestr,storedata(sj).filenam2,'.jpg')
view([70 20]);
saveas(h_fig,filename2);
disp('����ͼƬ2���');
fname='����ͼƬ2���';
set(handles1.statetext,'String',fname);

filename3 = strcat(filestr,storedata(sj).filenam2,'.gif')
disp('����GIF����');
fname='����GIF����';
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
genGif3D(1,storedata(sj).filenam2,h_fig);                                   %����GIF����
disp('gif������');                                                           %�ر�figure������ڴ�
fname='gif������';
set(handles1.statetext,'String',fname);

filename4 = strcat(path,'\UFileEX.dll');
NET.addAssembly(filename4);                                                 %ָ��dll�ļ���·�� 
import UFileEX.*;                                                           %����dll                                                         
key=strcat('test/',storedata(sj).filenam1,'.jpg');                          %�ƶ�key
upLoadfileDir = filename1;                                                  %�ϴ��ļ�·��            
output=UFile.Instance;                                                      %����ʵ���� 
b1=output.UploadFile(key,upLoadfileDir);                                    %�ϴ��ļ�

key=strcat('test/',storedata(sj).filenam2,'.jpg');                          %�ƶ�key
upLoadfileDir = filename2;                                                  %�ϴ��ļ�·��            
b1=output.UploadFile(key,upLoadfileDir);                                    %�ϴ��ļ�

key=strcat('test/',storedata(sj).filenam2,'.gif');                          %�ƶ�key
upLoadfileDir = filename3;                                                  %�ϴ��ļ�·��            
b1=output.UploadFile(key,upLoadfileDir);                                    %�ϴ��ļ�
