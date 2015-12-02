function oridataDisplay(vdata,pointNum)
global handles1;
global paravalue;
global angleData1;
global angleData2;
global lidar2frm;
global lidarQuantity;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ëã·¨²ÎÊýÅäÖÃ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=[];
y=[];
z=[];
pi = 3.1415926;
angle1=angleData1*pi/180;
angle2=angleData2*pi/180;

Xshift1 = str2num(paravalue.coordinatetransform.xshift1);
Yshift1 = str2num(paravalue.coordinatetransform.yshift1);
Zshift1 = str2num(paravalue.coordinatetransform.zshift1);
Xshift2 = str2num(paravalue.coordinatetransform.xshift2);
Yshift2 = str2num(paravalue.coordinatetransform.yshift2);
Zshift2 = str2num(paravalue.coordinatetransform.zshift2);
 

for i=1:pointNum   
   x(i) = vdata(i)*cos(1.5*pi-angle1(i))+Xshift1;
   z(i) = vdata(i)*sin(1.5*pi-angle1(i))+Zshift1;
   if( vdata(i)==2500)
       x(i) = 0;
       z(i) = 0;
   end
end
if lidarQuantity == 2
for i=1:pointNum   
   m_x(i) = lidar2frm(i)*cos(1.5*pi-angle1(i))+Xshift2;
   m_z(i) = lidar2frm(i)*sin(1.5*pi-angle1(i))+Zshift2;
   if( lidar2frm(i)==2500)
       m_x(i) = 0;
       m_z(i) = 0;
   end
end
end
m_data=[x',z'];
row=find(abs(m_data(:,1))+abs(m_data(:,2))>0);
m_data=m_data(row,:);
plot(handles1.axes1,m_data(:,1),m_data(:,2),'r.','visible','on');

if lidarQuantity == 2
n_data=[m_x',m_z'];
row=find(abs(n_data(:,1))+abs(n_data(:,2))>0);
n_data=n_data(row,:);
plot(handles1.axes2,n_data(:,1),n_data(:,2),'g.','visible','on');
end