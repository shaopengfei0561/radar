function ListenTimerCallback(obj,event)
global t3;
global runstat;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%与客户端连接状态判断%%%%%%%%%%%%%%%%%%%%%%%
port = str2num(paravalue.localserver.localport);
netflag=netstate(port);
if netflag==1
    disp('客户端已断开，等待重连......');
    runstat=0;          %更新系统忙状态为空闲状态
    disp('更新系统忙状态为空闲状态......');
    fclose(t3);
    fopen(t3);
    disp('客户端已连接......');
end
end