function ListenTimerCallback(obj,event)
global handles1;
global ys;
global runstat;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%向云端发送心跳包%%%%%%%%%%%%%%%%%%%%%%%
port = str2num(paravalue.cloudserver.cloudport);  
netflag=netstate(port);
if netflag==1
    runstat=0;          %更新系统忙状态为空闲状态
    chonglian();
else
   storedata=0;
   send_meadata(storedata,3);
   disp('发送心跳包......');
   % fname='发送心跳包';
   % set(handles1.statetext,'String',fname); 
% end
end