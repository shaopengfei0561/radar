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
        disp('���յ���ƽ̨���͵�ɨ���λָ��......');
        data
        if(runstat==0)
           toprenum=data(8);
           storeconfig=zeros(toprenum,8);
           for i=1:toprenum
               storeconfig(i,1)=data(9+27*(i-1))+data(10+27*(i-1))*256;                                                  %���                       
               storeconfig(i,2)=data(11+33*(i-1));                                                                       %��λ��
               storeconfig(i,3)=data(12+33*(i-1))+data(13+33*(i-1))*2^8+data(14+33*(i-1))*2^16+data(15+33*(i-1))*2^24;   %�ò�λx��Сֵ
               storeconfig(i,4)=data(16+33*(i-1))+data(17+33*(i-1))*2^8+data(18+33*(i-1))*2^16+data(19+33*(i-1))*2^24;   %�ò�λx���ֵ
               storeconfig(i,5)=data(20+33*(i-1))+data(21+33*(i-1))*2^8+data(22+33*(i-1))*2^16+data(23+33*(i-1))*2^24;   %�ò�λy��Сֵ
               storeconfig(i,6)=data(24+33*(i-1))+data(25+33*(i-1))*2^8+data(26+33*(i-1))*2^16+data(27+33*(i-1))*2^24;   %�ò�λy���ֵ
               storeconfig(i,7)=data(28+33*(i-1))+data(29+33*(i-1))*2^8+data(30+33*(i-1))*2^16+data(31+33*(i-1))*2^24;   %�ò�λz��Сֵ
               storeconfig(i,8)=data(32+33*(i-1))+data(33+33*(i-1))*2^8+data(34+33*(i-1))*2^16+data(35+33*(i-1))*2^24;   %�ò�λz���ֵ
           end
           send_data(0,2);                                                 %����ƽ̨�ͻ��˷���Ӧ����Ϣ
           if ldstat==0
           fopen(lidar1);
           if lidarQuantity == 2
                fopen(lidar2);
           end
           command_startDAQ_ColaB = [hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('02') hex2dec('00') hex2dec('00') hex2dec('00') hex2dec('11') ...
           hex2dec('73') hex2dec('45') hex2dec('4E') hex2dec('20') hex2dec('4C') hex2dec('4D') hex2dec('44') hex2dec('73') hex2dec('63') ...
           hex2dec('61') hex2dec('6E') hex2dec('64') hex2dec('61') hex2dec('74') hex2dec('61') hex2dec('20') hex2dec('01') hex2dec('33') ...
           ]; % ��ʼ�����ɼ�����
           fwrite(lidar1,command_startDAQ_ColaB,'uint8');
           if lidarQuantity == 2
                fwrite(lidar2,command_startDAQ_ColaB,'uint8');
           end
           end
           runstat=1;
           data_collect();
        else
            send_data(0,3);                                                %����ƽ̨�ͻ��˷���ϵͳæ��Ϣ
            disp('ϵͳæ......');
            fname='ϵͳæ';
            set(handles1.statetext,'String',fname);
            set(handles1.statetext2,'String',fname);
        end
    otherwise       
end
end