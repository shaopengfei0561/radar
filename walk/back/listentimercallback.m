function ListenTimerCallback(obj,event)
global t3;
global runstat;
global paravalue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ͻ�������״̬�ж�%%%%%%%%%%%%%%%%%%%%%%%
port = str2num(paravalue.localserver.localport);
netflag=netstate(port);
if netflag==1
    disp('�ͻ����ѶϿ����ȴ�����......');
    runstat=0;          %����ϵͳæ״̬Ϊ����״̬
    disp('����ϵͳæ״̬Ϊ����״̬......');
    fclose(t3);
    fopen(t3);
    disp('�ͻ���������......');
end
end