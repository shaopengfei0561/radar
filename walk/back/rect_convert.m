function [x,y,z]=rect_convert(vdata,mstep)
global startpos;
global handles1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%算法参数配置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
storebottom=0;                              %限定Z坐标，取该坐标之上的点云数据 
storetop=3000;                              %限定Z坐标，取该坐标下方的点云数据
str = get(handles1.edit15, 'String');
storelx=str2num(str);                       %限定x坐标，取该坐标以右的点云数据
str = get(handles1.edit17, 'String');
storerx=str2num(str);                       %限定x坐标，取该坐标以左的点云数据
% 坐标参数初始化(雷达坐标系平移到库底的坐标系)
delx=0;         %x的偏移值为0
dely=0;         %y的偏移值为导轨起点到库底的水平距离
delz=0;         %z的偏移值为导轨距离地面高度
x=[];
y=[];
z=[];
pi = 3.1415926;
angle=linspace(-5.04/180*pi,185.04/180*pi,529);
angle=angle';
for i=1:1058    
    if i<=529
        x(i) = vdata(i)*cos(angle(i))+150;
        y(i) = mstep*4+startpos;
        z(i) = 6400-vdata(i)*sin(angle(i));
    else 
        x(i) = vdata(i)*cos(angle(i-529))+18311;
        y(i) = mstep*4+startpos;
        z(i) = 6400-vdata(i)*sin(angle(i-529))+100;
    end 
    if x(i)>=storerx || x(i)<=storelx || z(i)<=storebottom||z(i)>=storetop
       x(i) = 0;
       y(i) = 0;
       z(i) = 0;
    end
end
%雷达坐标系平移到库底的坐标系
x = x + delx;
y = y + dely;
z = z + delz;
end