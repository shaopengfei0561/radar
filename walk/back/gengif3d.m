% ��ת����������ͼ������gif����
% �ȱ������ͼƬ����ֹ����ʱ����
%   yuzhijun@wsn.cn, 2015/8/27
% ���ӣ�
%   genGif3D_1(1, '1', 1);
%       ʹ������gifͼ����Ϊ1.gif�������Ϊ1���ѻ���ͼ����
% 
function varargout = genGif3D1(recordgif, fname, h_in)
% fname = 'test';
% recordgif = 1; % �Ƿ񱣴涯��

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
    im=imread(fname2);%����gif�ļ���ͼ�������index����ͼ��
    [I,map]=rgb2ind(im,20);
    if i==degreeStep
      imwrite(I,map,fname,'gif', 'Loopcount',inf,'DelayTime',0.5);%��һ�α��봴����
    else
      imwrite(I,map,fname,'gif','WriteMode','append','DelayTime',0.5);
    end;
  end
  delete('temp1_*.jpg');
end
close(h_in);