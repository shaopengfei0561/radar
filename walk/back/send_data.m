function send_data(data,mode)
global t4;                                                                 %VC�״����ݲɼ�������
global t3;                                                                 %��ƽ̨�ͻ���
mes_frame(1:4)=uint8(hex2dec('df'));                                       %֡ͷ
switch mode
    case 1 
        mes_frame=[data,239,239,239,239];
        % ��������
        fwrite(t4,mes_frame,'uint8');                                      %���״�VC�ɼ�������ת����ʼ�ɼ��״���������
        
    case 2
        mes_frame(5)=1;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=9;                                                    %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=1;                                                    %��ʼ�ɼ�����ָ�����óɹ�
        mes_frame(9)=crc(mes_frame(1:8));                                  %У��λ
        % ��������
        fwrite(t3,mes_frame,'uint8');                                      %����ƽ̨�ͻ��˷���Ӧ����Ϣ
        
    case 3
        mes_frame(5)=1;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=9;                                                    %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=3;                                                    %��ʼ�ɼ�����ָ�����óɹ�
        mes_frame(9)=crc(mes_frame(1:8));                                  %У��λ
        % ��������
        fwrite(t3,mes_frame,'uint8');                                      %����ƽ̨�ͻ��˷���ϵͳæ��Ϣ
        
    case 4                                                                 %��VC����������Ӧ����Ϣ
        mes_frame(5)=2;                                                    %��Ϣ�����ֶ�
        mes_frame(6)=9;                                                    %֡�������ֽڣ�
        mes_frame(7)=0;                                                    %֡�������ֽڣ�
        mes_frame(8)=1;                                                    %��ʼ�㷨����ָ�����óɹ�
        mes_frame(9)=crc(mes_frame(1:8));                                  %У��λ
        mes_frame(10)=239;
        mes_frame(11)=239;
        mes_frame(12)=239;
        mes_frame(13)=239;
        % ��������
        fwrite(t4,mes_frame,'uint8');     
    otherwise 
end
