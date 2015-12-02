function frmpara(data)
global toprenum;
global runstat;
global storeconfig;
global handles1;
global lidar1;
global lidar2;
global ldstat;
global lidarQuantity;
switch data(5)
    case 1
        clock
        disp('接收到云平台发送的扫描库位指令......');
        data
        if(runstat==0)
           toprenum=data(8);
           storeconfig=zeros(toprenum,8);
           for i=1:toprenum
               storeconfig(i,1)=data(9+27*(i-1))+data(10+27*(i-1))*256;                                                  %库号                       
               storeconfig(i,2)=data(11+33*(i-1));                                                                       %仓位号
               storeconfig(i,3)=data(12+33*(i-1))+data(13+33*(i-1))*2^8+data(14+33*(i-1))*2^16+data(15+33*(i-1))*2^24;   %该仓位x最小值
               storeconfig(i,4)=data(16+33*(i-1))+data(17+33*(i-1))*2^8+data(18+33*(i-1))*2^16+data(19+33*(i-1))*2^24;   %该仓位x最大值
               storeconfig(i,5)=data(20+33*(i-1))+data(21+33*(i-1))*2^8+data(22+33*(i-1))*2^16+data(23+33*(i-1))*2^24;   %该仓位y最小值
               storeconfig(i,6)=data(24+33*(i-1))+data(25+33*(i-1))*2^8+data(26+33*(i-1))*2^16+data(27+33*(i-1))*2^24;   %该仓位y最大值
               storeconfig(i,7)=data(28+33*(i-1))+data(29+33*(i-1))*2^8+data(30+33*(i-1))*2^16+data(31+33*(i-1))*2^24;   %该仓位z最小值
               storeconfig(i,8)=data(32+33*(i-1))+data(33+33*(i-1))*2^8+data(34+33*(i-1))*2^16+data(35+33*(i-1))*2^24;   %该仓位z最大值
           end
           send_data(0,2);                                                 %向云平台客户端发送应答消息
           if ldstat==0
           fopen(lidar1);
           if lidarQuantity == 2
                fopen(lidar2);
           end
           command_startDAQ_ColaB = [hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('00') hex2dec('00') hex2dec('00') hex2dec('11') ...
           hex2dec('73') hex2dec('45') hex2dec('4E') hex2dec('20') hex2dec('4C') hex2dec('4D') hex2dec('44') hex2dec('73') hex2dec('63') ...
           hex2dec('61') hex2dec('6E') hex2dec('64') hex2dec('61') hex2dec('74') hex2dec('61') hex2dec('20') hex2dec('01') hex2dec('33') ...
           ]; % 开始连续采集命令
           fwrite(lidar1,command_startDAQ_ColaB,'uint8');
           if lidarQuantity == 2
                fwrite(lidar2,command_startDAQ_ColaB,'uint8');
           end
           end
           runstat=1;
           data_collect();
        else
            send_data(0,3);                                                %向云平台客户端发送系统忙消息
            disp('系统忙......');
            fname='系统忙';
            set(handles1.statetext,'String',fname);
            set(handles1.statetext2,'String',fname);
        end
    otherwise       
end
end