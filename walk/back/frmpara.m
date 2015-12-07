function frmpara(data)
global toprenum;
global toprestore;
global runstat;
switch data(5)
    case 1
        clock
        disp('接收到云平台发送的扫描库位指令......');
        data
        if(runstat==0)
           toprenum=data(8);
           toprestore=data(9:9:(toprenum*9+9)); 
           data(6)=data(6)+4;
           data(9*toprenum+9)=crc(data(1:(9*toprenum+8)));
           send_data(data,1);                                              %向雷达VC采集服务器转发开始采集雷达数据命令
           disp('下发指令到VC......');
           send_data(0,2);                                                 %向云平台客户端发送应答消息
           runstat=1;
        else
            send_data(0,3);                                                %向云平台客户端发送系统忙消息
            disp('系统忙......');
        end
    case 2
        while(data(8)==2)                                                  %若云平台接收测量结果失败则重发
           send_data(data,1);                                               
        end
    otherwise       
end
end