function frmpara(data)
global toprenum;
global toprestore;
global runstat;
switch data(5)
    case 1
        clock
        disp('���յ���ƽ̨���͵�ɨ���λָ��......');
        data
        if(runstat==0)
           toprenum=data(8);
           toprestore=data(9:9:(toprenum*9+9)); 
           data(6)=data(6)+4;
           data(9*toprenum+9)=crc(data(1:(9*toprenum+8)));
           send_data(data,1);                                              %���״�VC�ɼ�������ת����ʼ�ɼ��״���������
           disp('�·�ָ�VC......');
           send_data(0,2);                                                 %����ƽ̨�ͻ��˷���Ӧ����Ϣ
           runstat=1;
        else
            send_data(0,3);                                                %����ƽ̨�ͻ��˷���ϵͳæ��Ϣ
            disp('ϵͳæ......');
        end
    case 2
        while(data(8)==2)                                                  %����ƽ̨���ղ������ʧ�����ط�
           send_data(data,1);                                               
        end
    otherwise       
end
end