function data_collect()
global scanstat1;
global scanstat2;
global yt1 yt2;
global startflag;
global hObject1 handles1;
global lidarQuantity;
if startflag==1
% 进入扫描状态
data(1)=255;
data(2)=1;
data(3)=0;
data(4)=2;
data(5)=40;
data(6)=0;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
fwrite(yt1,data,'uint8');
if lidarQuantity == 2
	fwrite(yt2,data,'uint8');
end

data(1)=255;
data(2)=1;
data(3)=0;
% 发送水平角度位置
data(4)=75;
data(5)=0;
data(6)=1;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
fwrite(yt1,data,'uint8');
if lidarQuantity == 2
	fwrite(yt2,data,'uint8');
end 
%发送垂直角度配置
data(4)=77;
data(5)=0;
data(6)=0;
crcb=sum(data(2:6));
if(crcb>255)
   crcb=mod(crcb,256);
end
data(7)=crcb;
fwrite(yt1,data,'uint8');
if lidarQuantity == 2
	fwrite(yt2,data,'uint8');
end 
fname='控制云台旋转到起点';
set(handles1.statetext,'String',fname);
set(handles1.statetext2,'String',fname);
disp('控制云台旋转到起点');
scanstat1=1;     
scanstat2=1;
else
    fname='请先开启服务';
    set(handles1.statetext,'String',fname);
    set(handles1.statetext2,'String',fname);
end