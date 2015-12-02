function [x,y,z]=rect_convert(vdata,mstep)
global railspeed;
global startpos;
global bgfrmnum;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�㷨��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
storebottom=0;                              %�޶�Z���꣬ȡ������֮�ϵĵ������� 
storetop=6000;                              %�޶�Z���꣬ȡ�������·��ĵ�������
% ���������ʼ��(�״�����ϵƽ�Ƶ���׵�����ϵ)
delx=0;         %x��ƫ��ֵΪ0
dely=0;         %y��ƫ��ֵΪ������㵽��׵�ˮƽ����
delz=0;         %z��ƫ��ֵΪ����������߶�
x=[];
y=[];
z=[];
pi = 3.1415926;
angle=linspace(-5.04/180*pi,185.04/180*pi,529);
angle=angle';
yStep = 4500/bgfrmnum;   %Y����ȷֲ�����
for i=1:1058    
    if i<=529
        x(i) = vdata(i)*cos(angle(i));
        y(i) = yStep*mstep+startpos;
        z(i) = 6400-vdata(i)*sin(angle(i));
    else 
        x(i) = vdata(i)*cos(angle(i-529))+18311;
        y(i) =yStep*mstep+startpos;
        z(i) = 6400-vdata(i)*sin(angle(i-529));
    end 
    if x(i)>=17000 || x(i)<=1000 || z(i)<=storebottom||z(i)>=storetop
       x(i) = 0;
       y(i) = 0;
       z(i) = 0;
    end
end
%�״�����ϵƽ�Ƶ���׵�����ϵ
x = x + delx;
y = y + dely;
z = z + delz;
end


