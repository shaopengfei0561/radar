function send_data(data,mode)
global ys;                                                                 %��ƽ̨�ͻ���
global deviceID;
mes_frame(1:4)=uint8(hex2dec('df'));                                       %֡ͷ
switch mode
    case 2
        mes_frame(5)=1;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=11;                                                    %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=1;                                                    %��ʼ�ɼ�����ָ�����óɹ�
        mes_frame(9)=mod(deviceID,2^8);                                    %�豸ID�����ֽڣ�
        mes_frame(10)=floor(deviceID/2^8);                                 %�豸ID�����ֽڣ�
        mes_frame(11)=crc(mes_frame(1:10));                                %У��λ
        % ��������
        fwrite(ys,mes_frame,'uint8');                                      %����ƽ̨�ͻ��˷���Ӧ����Ϣ
    case 3
        mes_frame(5)=1;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=9;                                                    %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=3;                                                    %��ʼ�ɼ�����ָ�����óɹ�
        mes_frame(9)=mod(deviceID,2^8);                                    %�豸ID�����ֽڣ�
        mes_frame(10)=floor(deviceID/2^8);                                 %�豸ID�����ֽڣ�
        mes_frame(11)=crc(mes_frame(1:10));                                %У��λ
        % ��������
        fwrite(ys,mes_frame,'uint8');                                      %����ƽ̨�ͻ��˷���ϵͳæ��Ϣ
    otherwise 
end
