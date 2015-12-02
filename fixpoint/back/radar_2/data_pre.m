function data= data_pre(vdata)
global mstep;
pi = 3.1415926;
angle=linspace(-5.04/180*pi,185.04/180*pi,529);
angle=angle';
for i=1:529
    data.x(i) = vdata(i)*cos(angle(i));
    data.y(i) = mstep*1.4;
    data.z(i) = vdata(i)*sin(angle(i));
    if data.x(i)>=2000 || data.x(i)<=0
        data.x(i) = 0;
        data.y(i) = 0;
        data.z(i) = 0;
    end
end
for i=530:1058
    data.x(i) = vdata(i)*cos(angle(i-529))+2180;
    data.y(i) = mstep*1.4;
    data.z(i) = vdata(i)*sin(angle(i-529));
    if data.x(i)>=2000 || data.x(i)<=0
        data.x(i) = 0;
        data.y(i) = 0;
        data.z(i) = 0;
    end
end
data.z=-data.z;
%µãÔÆ¾ÛÀà·Ö¸î
data=data_cluster(data);
mstep=mstep+1;
end