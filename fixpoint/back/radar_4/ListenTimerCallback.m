function ListenTimerCallback(obj,event)
global handles1;
global ys;
global runstat;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ƶ˷���������%%%%%%%%%%%%%%%%%%%%%%%
port = str2num(paravalue.cloudserver.cloudport);  
netflag=netstate(port);
if netflag==1
    runstat=0;          %����ϵͳæ״̬Ϊ����״̬
    chonglian();
else
   storedata=0;
   send_meadata(storedata,3);
   disp('����������......');
   % fname='����������';
   % set(handles1.statetext,'String',fname); 
% end
end