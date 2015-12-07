function vcfrmpara(data)
%% 解析VC雷达数据采集软件发送的数据帧
global toprestore;
global toprenum;
global ListenTimer;
global f;
global hObject1 handles1;
% modified by YZJ start...
global showType;
global paravalue;
% modified by YZJ end...
switch data(5)
    case 1
          disp('VC已确认收到扫描库位命令......');
          
    case 2                                                                 % VC服务器发来的开始算法处理命令数据帧                                                                
          send_data(data,4);                                               % 向VC服务器发送应答
          disp('收到VC服务器发来的开始算法处理命令数据帧......');
          stop(ListenTimer);          
          for sj=1:toprenum
              %按照库位号下载相应数据
              fname=strcat(num2str(toprestore(sj)),'.txt');
              ftpget(fname,f);
          end 
          disp('数据下载完成......');
          % 表面重建
          % modified by YZJ start...
          if(~showType)
            dianyunalg();                                                  % 进入数据处理函数
          else
            dianyunalg2(); 
          end
          % modified by YZJ end...                                         % 进入数据处理函数                                                         
          % 恢复参数
          toprestore=[];
          toprenum=0;
          start(ListenTimer);
     
    case 3                                                                 
          disp('已接收到VC服务器发来的扫描库位消息......');                  %VC服务器发来的扫描库位消息
          send_meadata(data,2)                                             %向云平台发送扫描库位消息
          disp('向云平台发送扫描库位消息......');
    otherwise       
end
end