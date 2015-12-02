function [x,y,z]=rect_convert(vdata,mstep,sj,pointNum)
global startangle1;
global endangle1;
global bgfrmnum1;
global startangle2;
global endangle2;
global bgfrmnum2;
global paravalue;
global storeconfig;
global angleData1;
global angleData2;
global deviceType;
global lidarQuantity;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%À„∑®≤Œ ˝≈‰÷√%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=[];
y=[];
z=[];
pi = 3.1415926;

YTRotation1 = str2num(paravalue.yt.ytrotation1);
LidarRotation1 = str2num(paravalue.yt.lidarrotation1);
YTRotation2 = str2num(paravalue.yt.ytrotation2);
LidarRotation2 = str2num(paravalue.yt.lidarrotation2);

angle1=angleData1*pi/180+LidarRotation1*pi/180;
angle2=angleData2*pi/180+LidarRotation2*pi/180;

Xshift1 = str2num(paravalue.coordinatetransform.xshift1);
Yshift1 = str2num(paravalue.coordinatetransform.yshift1);
Zshift1 = str2num(paravalue.coordinatetransform.zshift1);
Xshift2 = str2num(paravalue.coordinatetransform.xshift2);
Yshift2 = str2num(paravalue.coordinatetransform.yshift2);
Zshift2 = str2num(paravalue.coordinatetransform.zshift2);

Xstart  = storeconfig(sj,3);
Xend    = storeconfig(sj,4);
Ystart  = storeconfig(sj,5);
Yend    = storeconfig(sj,6);
Zstart  = storeconfig(sj,7);
Zend    = storeconfig(sj,8);

YTRotation1 = str2num(paravalue.yt.ytrotation1);
YTRotation2 = str2num(paravalue.yt.ytrotation2);

YTResolution = str2num(paravalue.yt.ytresolution);

if lidarQuantity == 2
    temppointNum = pointNum*2;
    if startangle2 <= (360*YTResolution) && startangle2 >= (350*YTResolution)
         temp2 = endangle2+(360*YTResolution)-startangle2;
    else
         temp2 = abs(endangle2-startangle2);
    end
else
    temppointNum = pointNum;
end 

if startangle1 <= (360*YTResolution) && startangle1 >= (350*YTResolution)
     temp1 = endangle1+(360*YTResolution)-startangle1;
else
     temp1 = abs(endangle1-startangle1);
end

if deviceType == 1
    for i=1:temppointNum
        if i<=pointNum
           a=(temp1/YTResolution/bgfrmnum1*mstep)*pi/180+YTRotation1*pi/180;
           x(i) = vdata(i)*cos(1.5*pi-angle1(i))*cos(pi-a)+Xshift1;
           y(i) = vdata(i)*cos(1.5*pi-angle1(i))*sin(pi-a)+Yshift1;
           z(i) = vdata(i)*sin(1.5*pi-angle1(i))+Zshift1;
       else
           a=(temp2/YTResolution/bgfrmnum2*mstep)*pi/180+YTRotation2*pi/180;
           x(i) = vdata(i)*cos(1.5*pi-angle2(i-pointNum))*cos(pi-a)+Xshift2;
           y(i) = vdata(i)*cos(1.5*pi-angle2(i-pointNum))*sin(pi-a)+Yshift2;
           z(i) = vdata(i)*sin(1.5*pi-angle2(i-pointNum))+Zshift2;
        end
       if( vdata(i)==2500 )
           x(i) = 0;
           y(i) = 0;
           z(i) = 0;
       end
    %  if x(i)<=Xstart || x(i)>Xend || y(i)>=Yend|| y(i)<=Ystart||z(i)<=Zstart||z(i)>=Zend
    %      x(i) = 0;
    %      y(i) = 0;
    %      z(i) = 0;
    %  end
    end
else   
    angle1=linspace(-5.04/180*pi,185.04/180*pi,529)+LidarRotation1*pi/180;
    angle1=angle1';
    angle2=linspace(-5.04/180*pi,185.04/180*pi,529)+LidarRotation2*pi/180;
    angle2=angle2';
    for i=1:temppointNum  
        if i<=pointNum
            a=(temp1/YTResolution/bgfrmnum1*mstep+startangle1/YTResolution)*pi/180+YTRotation1*pi/180;
            x(i) = vdata(i)*cos(angle1(i))*cos(a)+Xshift1;
            y(i) = -vdata(i)*cos(angle1(i))*sin(a)+Yshift1;
            z(i) = -vdata(i)*sin(angle1(i))+Zshift1;
        else
            a=(temp2/YTResolution/bgfrmnum2*mstep+startangle2/YTResolution)*pi/180+YTRotation2*pi/180;
            x(i) = -vdata(i)*cos(angle2(i-pointNum))*cos(a)+Xshift2;
            y(i) = vdata(i)*cos(angle2(i-pointNum))*sin(a)+Yshift2;
            z(i) = -vdata(i)*sin(angle2(i-pointNum))+Zshift2;
        end 
        %  if x(i)<=Xstart || x(i)>Xend || y(i)>=Yend|| y(i)<=Ystart||z(i)<=Zstart||z(i)>=Zend
        %     x(i) = 0;
        %     y(i) = 0;
        %     z(i) = 0;
        %  end
    end   
end