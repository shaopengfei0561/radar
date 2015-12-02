% 旋转生产的轮廓图并生成gif动画
% 先保存各张图片，防止截屏时黑屏
%   yuzhijun@wsn.cn, 2015/8/27
% 例子：
%   genGif3D_1(1, '1', 1);
%       使能生成gif图，存为1.gif，将句柄为1的已绘制图像传入
% 
function varargout = genGif3D1(recordgif, fname, h_in)
% fname = 'test';
% recordgif = 1; % 是否保存动画

[az,el] = view;
degreeStep = 30;
fname = ['c:\web\resources\' fname '.gif'];
hFig=figure(h_in);
set(hFig,'renderer','openGL')
opengl software;
set(h_in,'Visible','off');
set(gca,'NextPlot','replaceChildren');
if recordgif
  for i=0:degreeStep:360
    view(az+i,el);
    set(gcf, 'InvertHardCopy', 'off'); 
    fname2 = ['temp1_' num2str(i) '.jpg'];
    saveas(h_in,fname2,'jpg');
  end
  for i=degreeStep:degreeStep:360
    fname2 = ['temp1_' num2str(i) '.jpg'];
    %[I, map] = imread(fname2);
    im=imread(fname2);%制作gif文件，图像必须是index索引图像
    [I,map]=rgb2ind(im,20);
    if i==degreeStep
      imwrite(I,map,fname,'gif', 'Loopcount',inf,'DelayTime',0.5);%第一次必须创建！
    else
      imwrite(I,map,fname,'gif','WriteMode','append','DelayTime',0.5);
    end;
  end
  delete('temp1_*.jpg');
end
close(h_in);