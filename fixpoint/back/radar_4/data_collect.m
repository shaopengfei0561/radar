function data_collect()
global scanstat1;
global scanstat2;
global yt1 yt2;
global startflag;
global hObject1 handles1;
global lidarQuantity;
if startflag==1
% ����ɨ��״̬
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
% ����ˮƽ�Ƕ�λ��
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
%���ʹ�ֱ�Ƕ�����
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
fname='������̨��ת�����';
set(handles1.statetext,'String',fname);
set(handles1.statetext2,'String',fname);
disp('������̨��ת�����');
scanstat1=1;     
scanstat2=1;
else
    fname='���ȿ�������';
    set(handles1.statetext,'String',fname);
    set(handles1.statetext2,'String',fname);
end